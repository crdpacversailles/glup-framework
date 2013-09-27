package fr.acversailles.crdp.glup.framework.donnees {
	/**
	 * @author joachim
	 */
	public class Options implements IOptions {
		private var optionsXML : XML;
		private var crdp : Namespace;

		public function Options(optionsXML : XML) {
			this.optionsXML = optionsXML;
			this.optionsXML.ignoreWhitespace = true;
			crdp = new Namespace("http://www.crdp.ac-versailles.fr/glup/2012");
		}

		public function parametresSpecifiques(cle : String) : String {
			return optionsXML.crdp::parametres.crdp::specifiques.crdp::[cle];
		}

		public function getAide() : Vector.<String> {
			var aide : Vector.<String> = new Vector.<String>() ;
			for each (var paragraphe : String in optionsXML.crdp::mode_emploi.crdp::paragraphe) {
				aide.push(paragraphe);
			}
			return aide;
		}

		public function get score() : Boolean {
			return optionsXML.crdp::parametres.crdp::generaux.crdp::score == "oui";
		}

		public function get taillePolice() : uint {
			return parseInt(optionsXML.crdp::parametres.crdp::generaux.crdp::taille_police);
		}

		public function get chrono() : Boolean {
			return String(optionsXML.crdp::parametres.crdp::generaux.crdp::chrono).match(/oui/) != null;
		}

		public function get musique() : Boolean {
			return String(optionsXML.crdp::parametres.crdp::generaux.crdp::musique).match(/oui/) != null;
		}

		public function get decompte() : Boolean {
			return String(optionsXML.crdp::parametres.crdp::generaux.crdp::afficher_decompte).match(/oui/) != null;
		}

		public function get langue() : String {
			return String(optionsXML.crdp::parametres.crdp::generaux.crdp::langue);
		}

		public function get tempsDepartChrono() : uint {
			return uint(optionsXML.crdp::parametres.crdp::generaux.crdp::duree_chrono);
		}
	}
}
