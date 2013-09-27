package fr.acversailles.crdp.glup.framework.transitions {
	import fr.acversailles.crdp.glup.framework.communs.IPanneau;
	import fr.acversailles.crdp.utils.interfaces.ISprite;

	/**
	 * @author joachim
	 */
	public interface IMasqueTransition extends ISprite {
		function afficher() : void;

		function enregistrerAncien(ancien : IPanneau) : void;

		function enregistrerNouveau(nouveau : IPanneau) : void;

		function get ancien() : IPanneau ;

		function get nouveau() : IPanneau ;
	}
}
