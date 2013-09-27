package fr.acversailles.crdp.glup.jeux.popMots.controleur {
	import fr.acversailles.crdp.glup.framework.son.LibrairieSons;
	import fr.acversailles.crdp.glup.framework.calques.GestionCalques;
	import fr.acversailles.crdp.glup.framework.son.DiffusionSons;
	import fr.acversailles.crdp.glup.framework.donnees.IOptions;
	import fr.acversailles.crdp.glup.jeux.popMots.PopMots;
	import fr.acversailles.crdp.glup.jeux.popMots.modele.Modele;

	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/**
	 * @author joachim
	 */
	public class Controleur {
		private var timerApparitions : Timer;
		private var modele : Modele;
		private var jeu : PopMots;
		private var timerDisparitions : Timer;
		private var vitesseTimer : Number;
		private var options : IOptions;
		private var timerVictoire : Timer;

		public function Controleur(modele : Modele, jeu : PopMots, options : IOptions) {
			this.options = options;
			this.jeu = jeu;
			this.modele = modele;
			vitesseTimer = parseFloat(options.parametresSpecifiques("delai-moyen-entre-mots")) * 1000;
			timerApparitions = new Timer(vitesseTimer);
			timerDisparitions = new Timer(vitesseTimer);
			timerApparitions.addEventListener(TimerEvent.TIMER, gererTopTimerApparitions);
			timerDisparitions.addEventListener(TimerEvent.TIMER, gererTopTimerDisparitions);
			timerVictoire = new Timer(500, 1);
			timerVictoire.addEventListener(TimerEvent.TIMER, victoire);
		}

		private function gererTopTimerDisparitions(event : TimerEvent) : void {
			timerDisparitions.delay = Math.random() * vitesseTimer + vitesseTimer / 2;
			if (modele.getNbBallonsAffiches() <= parseInt(options.parametresSpecifiques("affichage-simultane-min"))) {
				return;
			}
			var numBallon : int = modele.donnerNumeroBallonAEnlever();
			if (numBallon == -1) return;
			jeu.faireDisparaitreBallon(numBallon);
		}

		private function gererTopTimerApparitions(event : TimerEvent) : void {
			timerApparitions.delay = Math.random() * vitesseTimer + vitesseTimer / 2;
			if (modele.getNbBallonsAffiches() >= parseInt(options.parametresSpecifiques("affichage-simultane-max"))) {
				return;
			}
			var numEmplacement : int = modele.donnerNumeroEmplacementDisponible();
			if (numEmplacement == -1) {
				return;
			}
			var numBallon : int = modele.donnerNumeroBallonAffichable();
			if (numBallon == -1) {
				return;
			}

			jeu.ajouterBallon(numBallon, numEmplacement);
		}

		public function activer() : void {
			timerApparitions.start();
			timerDisparitions.start();
		}

		public function signalerClicBallon(numero : uint) : void {
			modele.selectionEnonce(numero);
			if (modele.gagne)
				gererVictoire();
		}

		private function gererVictoire() : void {
			DiffusionSons.arreterMusique();
			timerVictoire.start();
			jeu.demanderBloquage();
			jeu.arreterchrono();
			timerApparitions.stop();
			timerDisparitions.stop();
		}

		public function signalerDisparitionParExplosion(numero : uint) : void {
			modele.libererEmplacement(numero);
		}

		public function signalerDisparitionSpontanee(numero : uint, numeroEmplacement : uint) : void {
			modele.setEtatBallon(numero, Modele.AFFICHABLE);
			modele.libererEmplacement(numeroEmplacement);
		}

		private function victoire(event : TimerEvent) : void {
			DiffusionSons.jouerSon(modele.score == modele.nbPointsTotal ? LibrairieSons.GAGNE_2 : LibrairieSons.GAGNE_1);
			GestionCalques.afficherCalque(GestionCalques.FINI_AVEC_SCORE, Vector.<String>([scoreStr()]));
		}

		private function scoreStr() : String {
			return modele.score + " / " + modele.nbPointsTotal;
		}

		public function gererDefaite() : void {
			DiffusionSons.arreterMusique();
			jeu.demanderBloquage();
			DiffusionSons.jouerSon(LibrairieSons.PERDU_1);
			timerApparitions.stop();
			timerDisparitions.stop();
			GestionCalques.afficherCalque(GestionCalques.FINI_AVEC_SCORE, Vector.<String>([scoreStr()]));
		}

		public function reinitialiser() : void {
			modele.reset();
		}

		public function desactiver() : void {
			timerApparitions.stop();
			timerDisparitions.stop();
		}

		public function pause() : void {
			timerApparitions.stop();
			timerDisparitions.stop();
			
		}

		public function play() : void {
			timerApparitions.start();
			timerDisparitions.start();
		}
	}
}
