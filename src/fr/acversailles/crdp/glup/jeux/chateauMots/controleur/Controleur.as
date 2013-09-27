package fr.acversailles.crdp.glup.jeux.chateauMots.controleur {
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import fr.acversailles.crdp.glup.framework.donnees.IOptions;
	import fr.acversailles.crdp.glup.jeux.chateauMots.ChateauMots;
	import fr.acversailles.crdp.glup.jeux.chateauMots.modele.Modele;

	import flash.geom.Point;

	public class Controleur {
		private var timerApparitions : Timer;
		private var modele : Modele;
		private var jeu : ChateauMots;
		private var options : IOptions;


		public function Controleur(modele : Modele, jeu : ChateauMots, options : IOptions) {
			this.modele = modele;
			this.options = options;
			this.jeu = jeu;
			timerApparitions = new Timer(2000);
			timerApparitions.addEventListener(TimerEvent.TIMER, gererApparitionsCharettes);
		}

		public function activer() : void {
			timerApparitions.start();
		}

		public function gererClique(origine : Point, cible : Point) : void {
			jeu.creeProjectile(origine, cible);
		}

		public function	gererApparitionsCharettes(te : TimerEvent) : void {
			if (modele.NbCharetteAffiches > 4 ) {
				return;
			}
			modele.changerNombreEnoncer();
			jeu.ajoutCharette();
		}
		
		public function pause() : void {
		}

		public function play() : void {
		}

		public function reinitialiser() : void {
			//jeu.pause();
		}
	}
}
