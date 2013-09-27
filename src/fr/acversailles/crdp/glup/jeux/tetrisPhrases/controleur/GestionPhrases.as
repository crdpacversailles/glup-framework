package fr.acversailles.crdp.glup.jeux.tetrisPhrases.controleur {
	import fr.acversailles.crdp.glup.framework.controle.SynchronisationEvent;
	import fr.acversailles.crdp.glup.framework.parametres.PG;
	import fr.acversailles.crdp.glup.jeux.tetrisPhrases.blocs.PhraseEnBlocs;
	import fr.acversailles.crdp.glup.jeux.tetrisPhrases.blocs.TetrisSynchronisationEvent;

	/**
	 * @author joachim
	 */
	public class GestionPhrases {
		private static var phrases : Vector.<PhraseEnBlocs> ;
		private static var _enPause : Boolean;

		public static function ajouter(phrase : PhraseEnBlocs) : Boolean {
			if (!phrases) {
				phrases = new Vector.<PhraseEnBlocs>();
			}
			var espaceDisponible : Number = phrases.length > 0 ? phrases[phrases.length - 1].y : PG.hauteurDispoJeu();
			for (var i : int = phrases.length-1; i >=0; i--) {
				if (phrases[i].disparitionEnCours) espaceDisponible += phrases[i].height;
				else if (phrases[i].etat == PhraseEnBlocs.ERREUR) break;
			}

			phrases.push(phrase);
			phrase.yObjectif = - phrase.height ;
			phrase.addEventListener(TetrisSynchronisationEvent.DISPARITION_PHRASE, gererDisparitionPhrase);
			return phrase.height < espaceDisponible - PG.HAUTEUR_CONSIGNE;
		}

		private static function gererDisparitionPhrase(event : SynchronisationEvent) : void {
			var phrase : PhraseEnBlocs = event.target as PhraseEnBlocs;
			supprimer(phrase);
		}

		private static function supprimer(phrase : PhraseEnBlocs) : void {
			phrases.splice(phrases.indexOf(phrase), 1);
			phrase.parent.removeChild(phrase);
			phrase.removeEventListener(TetrisSynchronisationEvent.DISPARITION_PHRASE, gererDisparitionPhrase);
		}

		public static function miseAJour() : void {
			if (!phrases || _enPause) return;
			phrases.forEach(controlerSituation);
		}

		private static function controlerSituation(phrase : PhraseEnBlocs, index : int, v : Vector.<PhraseEnBlocs>) : void {
			v;
			var positionCible : Number = index == 0 ? PG.hauteurDispoJeu()+PG.HAUTEUR_CONSIGNE-PG.MARGE_INF : phrases[index - 1].y;
			positionCible -= phrase.height;
			if (phrase.yObjectif < positionCible) phrase.yObjectif = positionCible + 1;
		}

		public static function pause() : void {
			_enPause = true;
			for each (var phrase : PhraseEnBlocs in phrases) {
				if (phrase.enDeplacement) phrase.pause();
			}
		}

		public static function play() : void {
			_enPause = false;
			for each (var phrase : PhraseEnBlocs in phrases) {
				if (phrase.enPause) phrase.play();
			}
		}

		public static function nettoyer() : void {
			while (phrases.length > 0) supprimer(phrases[0]);
			phrases = new Vector.<PhraseEnBlocs>();
		}

		public static function toutesPhrasesBloquees() : Boolean {
			var toutTraite : Boolean = true;
			for each (var phrase : PhraseEnBlocs in phrases) {
				toutTraite &&= (phrase.etat == PhraseEnBlocs.ERREUR || phrase.etat == PhraseEnBlocs.VALIDE);
			}
			return toutTraite;
		}
	}
}
