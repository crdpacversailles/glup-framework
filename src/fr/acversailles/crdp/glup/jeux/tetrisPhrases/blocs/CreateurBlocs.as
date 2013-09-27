package fr.acversailles.crdp.glup.jeux.tetrisPhrases.blocs {
	import fr.acversailles.crdp.glup.framework.donnees.Phrase;
	import fr.acversailles.crdp.glup.framework.donnees.SegmentPhrase;
	import fr.acversailles.crdp.glup.framework.graphismes.CharteCouleurs;

	/**
	 * @author joachim
	 */
	public class CreateurBlocs {
		private static var numeroCouleur : uint = 0;
		private static const NB_COULEURS : uint = 2;
		private static var couleurBlocs : uint;
		private static var couleurEncreBlocs : uint;

		public static function creerPhraseEnBlocs(phrase : Phrase, espacementMax : uint, largeur : uint, neutraliserPremier:Boolean=false) : PhraseEnBlocs {
			determinerCouleur();
			var phraseEnBlocs : PhraseEnBlocs = new PhraseEnBlocs(largeur);
			var bloc : Bloc;
			var premier:Boolean=true;
			for each (var segment : SegmentPhrase in phrase.segments) {
				bloc = new Bloc(segment.contenu, segment.special, couleurBlocs, couleurEncreBlocs, phraseEnBlocs, premier && neutraliserPremier);
				phraseEnBlocs.ajouterBloc(bloc, espacementMax);
				premier=false;
			}
			return phraseEnBlocs;
		}

		private static function determinerCouleur() : void {
			numeroCouleur++;
			numeroCouleur = numeroCouleur % NB_COULEURS;
			switch(numeroCouleur) {
				case 0:
					couleurBlocs = CharteCouleurs.BLANC;
					couleurEncreBlocs = CharteCouleurs.ACCENTUATION;
					break;
				case 1:
					couleurBlocs = CharteCouleurs.ACCENTUATION;
					couleurEncreBlocs = CharteCouleurs.BLANC;
					break;
			}
		}
	}
}
