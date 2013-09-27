package fr.acversailles.crdp.glup.framework.donnees {
	/**
	 * @author joachim
	 */
	public class SegmentPhrase {
		private var _contenu : String;
		private var _special : Boolean;

		public function SegmentPhrase(contenu : String, special : Boolean) {
			_special = special;
			_contenu = contenu;
		}

		public function get contenu() : String {
			return _contenu.replace(/_/g, " ");
		}

		public function get special() : Boolean {
			return _special;
		}

	}
}
