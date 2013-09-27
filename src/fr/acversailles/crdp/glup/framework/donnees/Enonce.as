package fr.acversailles.crdp.glup.framework.donnees {
	import fr.acversailles.crdp.glup.framework.donnees.IEnonce;

	/**
	 * @author joachim
	 */
	public class Enonce implements IEnonce {
		private var _contenu : String;
		private var _statut : Boolean;

		public function Enonce(contenu : String, statut : Boolean) {
			_statut = statut;
			_contenu = contenu;
		}

		public function get contenu() : String {
			return _contenu;
		}

		public function get statut() : Boolean {
			return _statut;
		}
	}
}
