package fr.acversailles.crdp.glup.framework.communs {
	import fr.acversailles.crdp.utils.interfaces.ISprite;

	/**
	 * @author joachim
	 */
	public interface IPanneau extends ISprite {
		function activer() : void;

		function desactiver() : void;
	}
}
