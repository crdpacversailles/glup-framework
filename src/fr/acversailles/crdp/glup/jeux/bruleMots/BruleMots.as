package fr.acversailles.crdp.glup.jeux.bruleMots {
	import fr.acversailles.crdp.glup.framework.donnees.IContenu;
	import fr.acversailles.crdp.glup.framework.donnees.IOptions;
	import fr.acversailles.crdp.glup.framework.donnees.Phrase;
	import fr.acversailles.crdp.glup.framework.jeu.AbstractJeu;
	import fr.acversailles.crdp.glup.framework.parametres.PG;
	import fr.acversailles.crdp.glup.jeux.bruleMots.controleur.Controleur;
	import fr.acversailles.crdp.glup.jeux.bruleMots.modele.Modele;

	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	/**
	 * @author joachim
	 */
	public class BruleMots extends AbstractJeu {
		private var modele : Modele;
		private var controleur : Controleur;
		private var _saisiesBloquees : Boolean;
		private var supportTexte : SupportTexte;
		private var supportOnde : SupportOnde;

		public function BruleMots(options : IOptions, contenu : IContenu) {
			super(options, contenu);
			addEventListener(Event.ADDED_TO_STAGE, construire);
		}

		private function construire(event : Event) : void {
			supportTexte = new SupportTexte(parseInt(options.parametresSpecifiques('duree_extinction'))*1000);
			supportJeu.addChild(supportTexte);
			supportTexte.x = 0;
			supportTexte.y = PG.HAUTEUR_CONSIGNE;
			supportOnde = new SupportOnde();
			supportJeu.addChild(supportOnde);
			addEventListener(MouseEvent.MOUSE_DOWN, gererMouseDown);
			modele = new Modele(contenu, options);
			controleur = new Controleur(modele, this, options);
		}

		override public function activer() : void {
			reinitialiser();
		}

		override public function desactiver() : void {
			controleur.pause();
		}

		private function gererMouseDown(event : MouseEvent) : void {
			if (_saisiesBloquees) return;
			controleur.gerer(event);
		}

		override public function pause() : void {
			controleur.pause();
		}

		override public function play() : void {
			controleur.play();
		}

		override public function reinitialiser() : void {
			supportTexte.reinitialiser();
			controleur.nouveauJeu();
		}

		public function bloquerSaisies(bool : Boolean) : void {
			_saisiesBloquees = bool;
		}

		public function chargerPhrases() : void {
			var envoiPossible : Boolean = true;
			var phrase : Phrase;
			do {
				phrase = modele.getPhraseSuivante();
				envoiPossible = supportTexte.ajouterTexte(phrase);
				if (envoiPossible)
					modele.nbMotsATrouver += phrase.nbBlocsSpeciaux;
			} while (envoiPossible && modele.resteDesPhrases());
		}

		public function toutEteindre() : void {
			supportTexte.toutEteindre();
		}

		public function effetOnde(cible : BlocMot) : void {
			var milieu : Point = Point.interpolate(cible.getBounds(this).topLeft, cible.getBounds(this).bottomRight, 0.5);
			supportOnde.declencherEffet(milieu);
		}

		override public function gererFinChrono() : void {
			controleur.gererFinChrono();
		}
	}
}
