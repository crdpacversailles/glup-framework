package fr.acversailles.crdp.glup.framework.donnees {
	/**
	 * @author joachim
	 */
	public class Analyseurs {
		public static const ACCOLADES : RegExp = /\[[^\]]+\]/g;
		private static const CARACTERE_PROVISOIRE : String = "#";		private static const CARACTERE_PROVISOIRE_SANS_ESPACE_APRES : RegExp = /#([^\s])/g;
		private static const CARACTERE_PROVISOIRE_SANS_ESPACE_AVANT : RegExp = /([^\s])#/g;
		private static var special : Boolean;

		public static function analyserSegmentsSoulignes(chaine : String) : Phrase {
			chaine = nettoyer(chaine);
			var phrase : Phrase = new Phrase();
			var resultat : Array = chaine.match(Analyseurs.ACCOLADES);
			var soulignes : Vector.<SegmentPhrase> = new Vector.<SegmentPhrase>();
			for each (var souligne:String in resultat) {
				soulignes.push(new SegmentPhrase(souligne.replace(/[\[\]]/g, ""), true));
			}
			chaine = chaine.replace(Analyseurs.ACCOLADES, CARACTERE_PROVISOIRE);
			chaine = chaine.replace(CARACTERE_PROVISOIRE_SANS_ESPACE_APRES, CARACTERE_PROVISOIRE+" $1");
			chaine = chaine.replace(CARACTERE_PROVISOIRE_SANS_ESPACE_AVANT, "$1 "+CARACTERE_PROVISOIRE);			var decoupage : Array = chaine.split(/\s+/);
			for each (var segment : String in decoupage) {
				special = segment == CARACTERE_PROVISOIRE;
				phrase.ajouterBloc(special ? soulignes.shift() : new SegmentPhrase(segment, false));
			}
			return phrase;
		}

		private static function nettoyer(chaine : String) : String {
			chaine = chaine.replace(/\s+/g, " ");
			chaine = chaine.replace(/^\s/g, "");
			chaine = chaine.replace(/\s$/g, "");
			chaine = chaine.replace(/§§/g, "$");
			return chaine;
		}
	}
}
