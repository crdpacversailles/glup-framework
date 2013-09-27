package fr.acversailles.crdp.glup.framework.jeu {
	import fr.acversailles.crdp.glup.framework.communs.IPanneau;

	/**
	 * Interface générale des jeux 
	 * @author joachim
	 */
	public interface IJeu extends IPanneau {
		function get nomJeu() : String;

		/**
		 * Fonction appelée par le container lorsque le joueur relance le jeu après une pause
		 */
		function play() : void;

		/**
		 * Fonction appelée  par le container  lorsque le joueur appuie sur le bouton pause
		 */
		function pause() : void;

		/**
		 * Fonction appelée  par le container  lorsque le joueur appuie sur le bouton réinitialiser
		 */
		function reinitialiser() : void;

		/**
		 * Fonction abstraite appelée  par le container  lorsque le chrono se termine
		 */
		function gererFinChrono() : void;
		/**
		 * Lance un message dans une bulle qui disparaît au clic 
		 * A appeler au gré des besoins dans les jeux concrets : la fonction n'est pas appelée automatiquement
		 * @param message La chaîne à afficher dans la bulle
		 */
		function alerteFurtive(message : String) : void;
	}
}
