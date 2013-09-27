package fr.acversailles.crdp.glup.framework.donnees {
	/**
	 * @author joachim
	 */
	public interface IOptions {
		function parametresSpecifiques(string : String) : String;

		function getAide() : Vector.<String>;

		function get score() : Boolean;

		function get chrono() : Boolean;

		function get musique() : Boolean;
		
		function get decompte() : Boolean;

		function get taillePolice() : uint;

		function get langue() : String;

		function get tempsDepartChrono() : uint;
	}
}
