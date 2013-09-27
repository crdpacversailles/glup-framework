package fr.acversailles.crdp.glup.jeux.tetrisPhrases.modele {
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
		private var _score : uint;
		private var _nbPointsTotal : uint;

		public function Modele(contenu : IContenu, options : IOptions) {
			this.options = options;
			this.contenu = contenu;
			curseurPhrases = 0;
		}

		public function nouveauJeu() : void {
			var phrasesStr : Vector.<String> = contenu.getContenuEnonces();
			_nbPointsTotal = 0;
			curseurPhrases = 0;
			phrases = new Vector.<Phrase>();
			var nouvellePhrase : Phrase;
			for each (var phraseStr : String in phrasesStr) {
				nouvellePhrase = Analyseurs.analyserSegmentsSoulignes(phraseStr);
				phrases.push(nouvellePhrase);
				_nbPointsTotal += 1;
			}
			melanger(Vector.<*>(phrases));
		}

		public function getPhraseSuivante() : Phrase {
			var phrase : Phrase = phrases[curseurPhrases];
			curseurPhrases++;
			return phrase;
		}

		public function get nbPointsTotal() : uint {
			return _nbPointsTotal;
		}

		public function get score() : uint {
			return _score;
		}

		public function set score(score : uint) : void {
			_score = score;
		}

		public function resteDesPhrases() : Boolean {
			return curseurPhrases < _nbPointsTotal;
		}
	}
}
