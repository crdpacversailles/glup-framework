package fr.acversailles.crdp.glup.framework.graphismes {
	import fr.acversailles.crdp.glup.framework.parametres.PG;

	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	/**
	 * @author dornbusch
	 */
	public class FormatsTexte {
		public static const ITEM_DANS_JEU : String = "ITEM_DANS_JEU";
		public static const TEXTE_DANS_JEU : String = "TEXTE_DANS_JEU";
		public static const CONSIGNE_JEU : String = "CONSIGNE";
		public static const TITRE_CALQUE : String = "TITRE_CALQUE";
		public static const TEXTE_CALQUE : String = "TEXTE_CALQUE";
		public static const COMMANDE : String = "COMMANDE";
		public static const SCORE : String = "SCORE";
		public static const TITRE_JEU : String = "TITRE_JEU";
		public static const CONSIGNE_ACCUEIL : String = "CONSIGNE_ACCUEIL";
		public static const TEXTE_AIDE : String = "TEXTE_AIDE";
		public static const NUMERO_PAGE_AIDE : String = "NUMERO_PAGE_AIDE";
		public static const SYMBOLE_TEXTE_AIDE : String = "SYMBOLE_TEXTE_AIDE";
		private static var _taillePolicePrincipale : int;
		public static const AVERTISSEMENT : String = "AVERTISSEMENT";
		public static const ITEM_DANS_JEU_SANS_MARGES : String = "ITEM_DANS_JEU_SANS_MARGES";
		public static const ITEM_DANS_JEU_CHARETTE : String = "ITEM_DANS_JEU_CHARETTE";
		public static function donnerFormat(identifiant : String) : TextFormat {
			var format : TextFormat;
			switch(identifiant) {
				case AVERTISSEMENT:
					format = new TextFormat(Polices.POLICE_1, 18, CharteCouleurs.TEXTE_GENERAL, null, null, null, null, null, TextFormatAlign.LEFT, 10, 10);
					break;
				case TITRE_JEU:
					format = new TextFormat(Polices.POLICE_1, 42, CharteCouleurs.TEXTE_1, null, null, null, null, null, TextFormatAlign.CENTER, 10, 10);
					break;
				case ITEM_DANS_JEU:
					format = new TextFormat(Polices.POLICE_2, _taillePolicePrincipale, CharteCouleurs.TEXTE_GENERAL, null, null, null, null, null, TextFormatAlign.CENTER, 10, 10);
					break;
				case ITEM_DANS_JEU_SANS_MARGES:
					format = new TextFormat(Polices.POLICE_2, _taillePolicePrincipale, CharteCouleurs.TEXTE_GENERAL, null, null, null, null, null, TextFormatAlign.CENTER, 0,0);
					break;
				case ITEM_DANS_JEU_CHARETTE :
					format = new TextFormat(Polices.POLICE_2, _taillePolicePrincipale, CharteCouleurs.TEXTE_GENERAL, null, null, null, null, null, TextFormatAlign.LEFT, 0,0);
					break;
				case TEXTE_DANS_JEU:
					format = new TextFormat(Polices.POLICE_2, 32, CharteCouleurs.TEXTE_GENERAL, null, null, null, null, null, TextFormatAlign.CENTER, 3, 3);
					break;
				case CONSIGNE_JEU:
					format = new TextFormat(Polices.POLICE_1, 24, CharteCouleurs.BLANC, null, null, null, null, null, TextFormatAlign.LEFT, 10, 10);
					break;
				case CONSIGNE_ACCUEIL:
					format = new TextFormat(Polices.POLICE_1, 24, CharteCouleurs.TEXTE_1, null, null, null, null, null, TextFormatAlign.CENTER, 10, 10);
					break;
				case SCORE:
					format = new TextFormat(Polices.POLICE_0, 24, CharteCouleurs.TEXTE_GENERAL, null, null, null, null, null, TextFormatAlign.CENTER);
					break;
				case COMMANDE:
					format = new TextFormat(Polices.POLICE_1, 24, CharteCouleurs.TEXTE_COMMANDE, null, null, null, null, null, TextFormatAlign.LEFT, 10, 10);
					break;
				case TITRE_CALQUE:
					format = new TextFormat(Polices.POLICE_1, 36, CharteCouleurs.TEXTE_GENERAL, null, null, null, null, null, TextFormatAlign.CENTER);
					break;
				case TEXTE_CALQUE:
					format = new TextFormat(Polices.POLICE_1, 24, CharteCouleurs.TEXTE_GENERAL, null, null, null, null, null, TextFormatAlign.CENTER);
					break;
				case TEXTE_AIDE:
					format = new TextFormat(Polices.POLICE_1, 24, CharteCouleurs.TEXTE_GENERAL, null, null, null, null, null, TextFormatAlign.LEFT);
					break;
				case SYMBOLE_TEXTE_AIDE:
					format = new TextFormat(Polices.POLICE_4, 38, CharteCouleurs.TEXTE_GENERAL, null, null, null, null, null, TextFormatAlign.LEFT, null, null, null, -5);
					break;
				case NUMERO_PAGE_AIDE:
					format = new TextFormat(Polices.POLICE_1, 24, CharteCouleurs.TEXTE_GENERAL, null, null, null, null, null, TextFormatAlign.LEFT);
					break;
			}
			format.size = Number(format.size) * PG.coeffAire();
			return format;
		}

		static public function set taillePolicePrincipale(taillePolicePrincipale : int) : void {
			_taillePolicePrincipale = taillePolicePrincipale;
		}
	}
}
