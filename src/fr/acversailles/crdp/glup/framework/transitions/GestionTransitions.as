package fr.acversailles.crdp.glup.framework.transitions {
	import fr.acversailles.crdp.glup.framework.Main;
	import fr.acversailles.crdp.glup.framework.communs.IPanneau;
	import fr.acversailles.crdp.glup.framework.controle.SynchronisationEvent;

	/**
	 * @author joachim
	 */
	public class GestionTransitions {
		private static var _support : Main;

		public static function initialiser(support : Main) : void {
			_support = support;
		}

		public static function transition(ancien : IPanneau, nouveau : IPanneau) : void {
			nouveau.sprite.visible = true;
			nouveau.sprite.parent.setChildIndex(nouveau.sprite, nouveau.sprite.parent.numChildren - 1);
			var masqueCourant : IMasqueTransition = choisirMasque();
			_support.addChild(masqueCourant.sprite);
			masqueCourant.enregistrerAncien(ancien);
			masqueCourant.enregistrerNouveau(nouveau);
			nouveau.sprite.mask = masqueCourant.sprite;
			masqueCourant.afficher();
		}

		private static function choisirMasque() : IMasqueTransition {
			var masque : IMasqueTransition = new MasqueRectangulaire();
			masque.sprite.addEventListener(SynchronisationEvent.FIN_AFFICHAGE_MASQUE, gererFinAffichageMasque);
			return masque;
		}

		private static function gererFinAffichageMasque(event : SynchronisationEvent) : void {
			var masque : IMasqueTransition = event.target as IMasqueTransition;
			if (masque.ancien) masque.ancien.sprite.visible = false;
			masque.nouveau.sprite.mask = null;
			_support.removeChild(masque.sprite);
			masque.sprite.removeEventListener(SynchronisationEvent.FIN_AFFICHAGE_MASQUE, gererFinAffichageMasque);
		}
	}
}
