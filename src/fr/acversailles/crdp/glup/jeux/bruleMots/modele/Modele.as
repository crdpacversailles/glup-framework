package fr.acversailles.crdp.glup.jeux.bruleMots.modele {
	import fr.acversailles.crdp.glup.framework.donnees.Analyseurs;
	import fr.acversailles.crdp.glup.framework.donnees.IContenu;
	import fr.acversailles.crdp.glup.framework.donnees.IOptions;
	import fr.acversailles.crdp.glup.framework.donnees.Phrase;
	import fr.acversailles.crdp.utils.melanger;

	/**
	 * @author joachim
	 */
	public class Modele {
		private var contenu : IContenu;
		private var options : IOptions;
		private var phrases : Vector.<Phrase>;
		private var curseurPhrases : int;
		private var _nbMotsATrouver : uint;

		public function Modele(contenu : IContenu, options : IOptions) {
			this.options = options;
			this.contenu = contenu;
			curseurPhrases = 0;
		}

		public function nouveauJeu() : void {
			var phrasesStr : Vector.<String> = contenu.getContenuEnonces();
			curseurPhrases = 0;
			_nbMotsATrouver = 0;
			phrases = new Vector.<Phrase>();
			var nouvellePhrase : Phrase;
			for each (var phraseStr : String in phrasesStr) {
				nouvellePhrase = Analyseurs.analyserSegmentsSoulignes(phraseStr);
				phrases.push(nouvellePhrase);
			}
			if(options.parametresSpecifiques("melanger_phrases")=="oui")
				melanger(Vector.<*>(phrases));
			
		}

		public function getPhraseSuivante() : Phrase {
			var phrase : Phrase = phrases[curseurPhrases];
			curseurPhrases++;
			return phrase;
		}

		public function resteDesPhrases() : Boolean {
			return curseurPhrases < phrases.length;
		}

		public function get nbMotsATrouver() : uint {
			return _nbMotsATrouver;
		}

		public function set nbMotsATrouver(nbMotsATrouver : uint) : void {
			_nbMotsATrouver = nbMotsATrouver;
		}
	}
}
