package fr.acversailles.crdp.glup.framework.donnees {
	/**
	 * @author joachim
	 */
	public class Contenu implements IContenu {
		private var contenuXML : XML;
		private var crdp : Namespace;

		public function Contenu(contenuXML : XML) {
			this.contenuXML = contenuXML;
			this.contenuXML.ignoreWhitespace = true;
			crdp = new Namespace("http://www.crdp.ac-versailles.fr/glup/2012");
		}

		public function getConsigne() : String {
			return contenuXML.crdp::consigne;
		}

		public function getNomJeu() : String {
			return contenuXML.crdp::nom_jeu;
		}

		public function getContenuEnonces() : Vector.<String> {
			var enonces : Vector.<String> = new Vector.<String>();
			for each (var enonce : String in contenuXML.crdp::enonces.crdp::enonce) {
				enonces.push(enonce);
			}
			return enonces;
		}

		public function getEnonces() : Vector.<IEnonce> {
			var enonces : Vector.<IEnonce> = new Vector.<IEnonce>();
			//TODO élucder le problème des namespaces qui ne correspondent pas : xmlns:crdp	"http://www.crdp.ac-versailles.fr/glup/2012"	ou sans /glup/2012
			
			for each (var enonce : XML in contenuXML.crdp::enonces.crdp::enonce) {
				if(enonce.toString().match(/^\s*$/))
					continue;
				enonces.push(new Enonce(enonce, enonce.@statut=="true"));
			}
			return enonces;
		}
	}
}
