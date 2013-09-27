package fr.acversailles.crdp.glup.framework.transitions {
	import fr.acversailles.crdp.glup.framework.communs.IPanneau;
	import fr.acversailles.crdp.glup.framework.controle.SynchronisationEvent;
	import fr.acversailles.crdp.glup.framework.parametres.PG;

	import flash.events.Event;
	import flash.display.Sprite;

	/**
	 * @author joachim
	 */
	public class MasqueCirculaire extends Sprite implements IMasqueTransition {
		private static const VITESSE_OUVERTURE : int = 24;
		private var rayon : int;
		private var _ancien : IPanneau;
		private var _nouveau : IPanneau;

		public function MasqueCirculaire() {
		}

		public function get sprite() : Sprite {
			return this;
		}

		public function afficher() : void {
			rayon = 0;
			addEventListener(Event.ENTER_FRAME, agrandirCercle);
		}

		private function agrandirCercle(event : Event) : void {
			rayon += VITESSE_OUVERTURE;
			graphics.beginFill(0x000000);
			graphics.drawCircle(PG.LARGEUR_SCENE / 2, PG.HAUTEUR_SCENE / 2, rayon);
			if (rayon >= PG.LARGEUR_SCENE / 2) {
				removeEventListener(Event.ENTER_FRAME, agrandirCercle);
				dispatchEvent(new SynchronisationEvent(SynchronisationEvent.FIN_AFFICHAGE_MASQUE));
			}
		}

		public function enregistrerAncien(ancien : IPanneau) : void {
			_ancien = ancien;
		}

		public function enregistrerNouveau(nouveau : IPanneau) : void {
			_nouveau = nouveau;
		}

		public function get ancien() : IPanneau {
			return _ancien;
		}

		public function get nouveau() : IPanneau {
			return _nouveau;
		}
	}
}
