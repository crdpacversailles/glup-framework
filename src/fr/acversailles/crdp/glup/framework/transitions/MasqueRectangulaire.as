package fr.acversailles.crdp.glup.framework.transitions {
	import fr.acversailles.crdp.glup.framework.communs.IPanneau;
	import fr.acversailles.crdp.glup.framework.controle.SynchronisationEvent;
	import fr.acversailles.crdp.glup.framework.parametres.PG;

	import flash.events.Event;
	import flash.display.Sprite;

	/**
	 * @author joachim
	 */
	public class MasqueRectangulaire extends Sprite implements IMasqueTransition {
		private static const VITESSE_OUVERTURE : Number = 0.05;
		private var dimension : Number;
		private var _ancien : IPanneau;
		private var _nouveau : IPanneau;

		public function MasqueRectangulaire() {
		}

		public function get sprite() : Sprite {
			return this;
		}

		public function afficher() : void {
			dimension = 0.2;
			addEventListener(Event.ENTER_FRAME, agrandirCercle);
		}

		private function agrandirCercle(event : Event) : void {
			dimension += VITESSE_OUVERTURE;
			graphics.beginFill(0x000000);
			var largeur:Number  = PG.LARGEUR_SCENE*dimension;
			var hauteur:Number  = PG.HAUTEUR_SCENE*dimension;
			graphics.drawRect(PG.LARGEUR_SCENE /2 - largeur/2, PG.HAUTEUR_SCENE / 2 - hauteur/2, largeur, hauteur);
			if (dimension >= 1) {
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
