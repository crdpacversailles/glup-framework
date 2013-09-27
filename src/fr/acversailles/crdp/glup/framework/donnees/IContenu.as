package fr.acversailles.crdp.glup.framework.donnees {
	/**
	 * @author joachim
	 */
	public interface IContenu {
		
		function getNomJeu() :String;
		
		function getContenuEnonces() : Vector.<String>;
		
		function getEnonces() : Vector.<IEnonce>;

		function getConsigne() : String;
	}
}
