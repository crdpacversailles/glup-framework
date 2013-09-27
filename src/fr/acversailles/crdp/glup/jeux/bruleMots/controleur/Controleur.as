package fr.acversailles.crdp.glup.jeux.bruleMots.controleur {
	import fr.acversailles.crdp.utils.functions.tr;
	import fr.acversailles.crdp.glup.framework.calques.GestionCalques;
	import fr.acversailles.crdp.glup.framework.controle.SynchronisationEvent;
	import fr.acversailles.crdp.glup.framework.donnees.IOptions;
	import fr.acversailles.crdp.glup.framework.son.DiffusionSons;
	import fr.acversailles.crdp.glup.framework.son.LibrairieSons;
	import fr.acversailles.crdp.glup.jeux.bruleMots.BlocMot;
	import fr.acversailles.crdp.glup.jeux.bruleMots.BruleMots;
	import fr.acversailles.crdp.glup.jeux.bruleMots.modele.Modele;

	import flash.events.MouseEvent;

	/**
	 * @author joachim
	 */
	public class Controleur {
		private var modele : Modele;
		private var jeu : BruleMots;
		private var options : IOptions;
		private var _enPause : Boolean;
		private var blocsTrouves : Vector.<BlocMot>;
		private var _fini : Boolean;

		public function Controleur(modele : Modele, jeu : BruleMots, options : IOptions) {
			this.options = options;
			this.jeu = jeu;
			this.modele = modele;
		}

		public function nouveauJeu() : void {
			// on force la pause
			_enPause = false;
			_fini = false;
			modele.nouveauJeu();
			for each (var bloc : BlocMot in blocsTrouves) {
				bloc.removeEventListener(SynchronisationEvent.EXTINCTION, gererExtinctionMot);
			}
			blocsTrouves = new Vector.<BlocMot>();
			jeu.demarrerChrono();
			jeu.bloquerSaisies(false);
			jeu.chargerPhrases();
		}

		public function gerer(event : MouseEvent) : void {
			if (_enPause) return;
			if (event.type == MouseEvent.MOUSE_DOWN && event.target is BlocMot) {
				var cible : BlocMot = event.target as BlocMot;
				if (cible.special) gererBonneReponse(cible);
				else gererErreur(cible);
			}
		}

		private function gererErreur(cible : BlocMot) : void {
			jeu.toutEteindre();
			jeu.effetOnde(cible);
		}

		private function gererBonneReponse(cible : BlocMot) : void {
			cible.bruler();
			cible.addEventListener(SynchronisationEvent.EXTINCTION, gererExtinctionMot);
			if (blocsTrouves.indexOf(cible) == -1) blocsTrouves.push(cible);
			if (blocsTrouves.length == modele.nbMotsATrouver) gererVictoire();
			else jeu.alerteFurtive(tr("ENCORE")+" "+(modele.nbMotsATrouver-blocsTrouves.length));
		}

		private function gererExtinctionMot(event : SynchronisationEvent) : void {
			if (_fini) return;
			var cible : BlocMot = BlocMot(event.target);
			cible.removeEventListener(SynchronisationEvent.EXTINCTION, gererExtinctionMot);
			blocsTrouves.splice(blocsTrouves.indexOf(cible), 1);
		}

		private function gererVictoire() : void {
			_fini = true;
			jeu.bloquerSaisies(true);
			jeu.demanderBloquage();
			jeu.arreterchrono();
			DiffusionSons.jouerSon(LibrairieSons.GAGNE_1);
			GestionCalques.afficherCalque(GestionCalques.VICTOIRE_SANS_SCORE);
		}

		public function pause() : void {
			_enPause = true;
			for each (var bloc : BlocMot in blocsTrouves) {
				bloc.figer(true);
			}
		}

		public function play() : void {
			_enPause = false;
			for each (var bloc : BlocMot in blocsTrouves) {
				bloc.figer(false);
			}
		}

		public function gererFinChrono() : void {
			_fini = true;
			jeu.bloquerSaisies(true);
			jeu.demanderBloquage();
			DiffusionSons.jouerSon(LibrairieSons.PERDU_1);
			GestionCalques.afficherCalque(GestionCalques.DEFAITE_SANS_SCORE);
		}
	}
}
