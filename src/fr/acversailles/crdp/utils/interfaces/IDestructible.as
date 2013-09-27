package fr.acversailles.crdp.utils.interfaces {

	/**
	 * @private
	 */
	public interface IDestructible {
		function detruire() : void;

		function creerListeDestructibles() : void;

		function effacerListeDestructible() : void;

		function get destructible() : IDestructible;

		function get listeDestructible() : Array;

		function ajouterListeDestructible(nouveau : IDestructible) : void;
	}
}
