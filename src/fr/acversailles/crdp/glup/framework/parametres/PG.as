package fr.acversailles.crdp.glup.framework.parametres {
	/**
	 * @author joachim
	 */
	public class PG {
		public static const LARGEUR_SCENE : Number = parseFloat(CONFIG::largeur);
		public static const HAUTEUR_SCENE : Number = parseFloat(CONFIG::hauteur);
		public static const HAUTEUR_MODELE : Number = 600;
		public static const LARGEUR_MODELE : Number = 800;
		
		public static const EPAISSEUR_BORD : Number = 0.0 * (PG.HAUTEUR_SCENE + PG.LARGEUR_SCENE) / (PG.HAUTEUR_MODELE + PG.LARGEUR_MODELE);
		public static const EPAISSEUR_BORD_CHRONO : Number = 4.0 * (PG.HAUTEUR_SCENE + PG.LARGEUR_SCENE) / (PG.HAUTEUR_MODELE + PG.LARGEUR_MODELE);
		
		public static const MARGE_SUP_COMMANDES_ACCUEIL : Number = 0.1 * HAUTEUR_SCENE;
		public static const EPAISSEUR_BORD_COMMANDES_ACCUEIL : Number = 15.0 * (PG.HAUTEUR_SCENE + PG.LARGEUR_SCENE) / (PG.HAUTEUR_MODELE + PG.LARGEUR_MODELE);
		public static const PADDING_CADRE_COMMANDE_ACCUEIL : Number = 30.0 * (PG.HAUTEUR_SCENE + PG.LARGEUR_SCENE) / (PG.HAUTEUR_MODELE + PG.LARGEUR_MODELE);
		
		public static const MARGE_HAUTE_SUPPORT_JEU : Number = MARGE_HAUTE + HAUTEUR_CONSIGNE;
		
		public static const MARGE_HAUTE : Number = 0.033 * HAUTEUR_SCENE;
		public static const MARGE_DROITE : Number = 0.025 * LARGEUR_SCENE;
		public static const MARGE_GAUCHE : Number = 0.025 * LARGEUR_SCENE;
		public static const MARGE_INF : Number = 0.033 * HAUTEUR_SCENE;
		
		public static const HAUTEUR_CONSIGNE : Number = 0.066 * HAUTEUR_SCENE;
		
		public static const LARGEUR_OUTILS : Number = 0.070 * LARGEUR_SCENE;
		public static const RAYON_BOUTONS_OUTILS : Number = 0.033 * HAUTEUR_SCENE;
		
		public static const MARGE_V_ENTRE_OUTILS : Number = RAYON_BOUTONS_OUTILS / 2;
		public static const REDUCTION_ICONE_BOUTON_OUTIL : Number = 0.6;
		
		public static const LARGEUR_CALQUES : Number = 0.40 * LARGEUR_SCENE;
		public static const MARGES_LATERALES_CALQUE : Number = 0.025 * LARGEUR_SCENE;
		public static const MARGE_GAUCHE_BAS_CALQUE : Number = 0.05 * LARGEUR_SCENE;
		public static const MARGE_SUP_CALQUE : Number = 0.033 * HAUTEUR_SCENE;
		public static const EPAISSEUR_BORD_CALQUE : Number = 3.0 * (PG.HAUTEUR_SCENE + PG.LARGEUR_SCENE) / (PG.HAUTEUR_MODELE + PG.LARGEUR_MODELE);
		public static const MARGE_INF_CALQUE : Number = 0.033 * HAUTEUR_SCENE;
		public static const MARGE_INF_TITRE_CALQUE : Number = 0.017 * HAUTEUR_SCENE;
		public static const HAUTEUR_LIENS_COMMANDES : Number = 0.066 * HAUTEUR_SCENE;
		public static const MARGE_DROITE_ICONE_LIEN_COMMANDE : Number = 0.0125 * LARGEUR_SCENE;
		
		public static const MARGE_SUP_COMMANDES : Number = 0.017 * HAUTEUR_SCENE;
		public static const MARGE_ENTRE_COMMANDES_ACCUEIL : Number = 0.017 * HAUTEUR_SCENE;
		
		public static const REDUCTION_ICONE_LIEN_COMMANDE : Number = 0.75;
		public static const MARGE_GAUCHE_ICONE_LIEN_COMMANDE : Number = 0.0125 * LARGEUR_SCENE;
		public static const MARGE_SUP_ZONE_SCORE : Number = 0.025 * LARGEUR_SCENE;

		public static const MARGE_SUP_TITRE_JEU : Number = 0;
		public static const MARGE_SUP_CONSIGNE_JEU : Number = 0.04 * HAUTEUR_SCENE;
		public static const ARRONDI_BORDS_CONSIGNE_JEU : Number=15 * (PG.HAUTEUR_SCENE + PG.LARGEUR_SCENE) / (PG.HAUTEUR_MODELE + PG.LARGEUR_MODELE);
		public static const MARGES_LATERALES_CONSIGNE_ACCUEIL : Number = 0.0375 * HAUTEUR_SCENE;
		public static const HAUTEUR_MAX_ZONE_CONSIGNE_Accueil : Number = 0.2 * HAUTEUR_SCENE;
		public static const MARGE_DROITE_ICONE_CRDP : Number = 0.0125 * LARGEUR_SCENE;
		public static const MARGE_INF_ICONE_CRDP : Number = 0.0125 * LARGEUR_SCENE;
		public static const LARGEUR_LOGO_CRDP_ACCUEIL : Number = 0.15 * LARGEUR_SCENE;
		public static const HAUTEUR_LOGO_GLUP_ACCUEIL : Number = 0.1 * LARGEUR_SCENE;
		public static const MARGE_SUP_LOGO_GLUP : Number= 0.01 * HAUTEUR_SCENE;
		
		public static const MARGE_SUP_AIDE_ACCUEIL : Number = 0;
		public static const MARGE_INF_AIDE_ACCUEIL : Number = 0;
		public static const MARGE_V_ENTRE_PARAGRAPHES_AIDE : Number = 0;
		public static const PADDING_AIDE : Number = 0.01875 * LARGEUR_SCENE;
		public static const ESPACE_SUP_AIDE : Number = 0.058 * HAUTEUR_SCENE;
		public static const MARGE_ENTRE_BOUTONS_AIDE : Number = 0.0125 * LARGEUR_SCENE;
		public static const REDUCTION_BOUTON_AIDES : Number = 0.75;
		
		public static const ARRONDI_BORDS_CADRE : Number = 20 * (PG.HAUTEUR_SCENE + PG.LARGEUR_SCENE) / (PG.HAUTEUR_MODELE + PG.LARGEUR_MODELE);
		public static const ARRONDI_BORDS_CALQUES : Number = 10 * (PG.HAUTEUR_SCENE + PG.LARGEUR_SCENE) / (PG.HAUTEUR_MODELE + PG.LARGEUR_MODELE);
		public static const MARGES_LATERALES_AVERTISSEMENT : Number = 0.0125 * LARGEUR_SCENE;
		public static const PADDING_V_ZONE_TITRE : Number =0.025 * HAUTEUR_SCENE;
		public static const PADDING_H_ZONE_TITRE : Number = 0.025 * LARGEUR_SCENE;
		public static const LARGEUR_ALERTE : Number=0.15 * LARGEUR_SCENE;
		public static const ARRONDI_BORDS_ALERTE : Number = 5 * (PG.HAUTEUR_SCENE + PG.LARGEUR_SCENE) / (PG.HAUTEUR_MODELE + PG.LARGEUR_MODELE);
		public static const HAUTEUR_ZONE_SCORE : Number = 0.15 * HAUTEUR_SCENE;
		
		public static const MARGE_INF_CHRONO : Number= 0.017 * HAUTEUR_SCENE;
		public static const MARGE_SUP_CHRONO : Number = 0.017 * HAUTEUR_SCENE;
		public static const Y_BORD_INF_CORNICHE : Number = 0.89 * HAUTEUR_SCENE;
		public static const Y_BORD_SUP_CORNICHE : Number = 0.45 * HAUTEUR_SCENE;
		public static const PROPORTION_ICONE_FOND_JEU : Number = 0.9;
		public static const EPAISSEUR_BORD_AIDE : Number = 5 * (PG.HAUTEUR_SCENE + PG.LARGEUR_SCENE) / (PG.HAUTEUR_MODELE + PG.LARGEUR_MODELE);
		public static const ARRONDI_BORDS_AIDE : Number= 10 * (PG.HAUTEUR_SCENE + PG.LARGEUR_SCENE) / (PG.HAUTEUR_MODELE + PG.LARGEUR_MODELE);
		
		public static function largeurDispoJeu() : Number {
			return LARGEUR_SCENE - EPAISSEUR_BORD * 2 - MARGE_GAUCHE - LARGEUR_OUTILS - MARGE_DROITE;
		}

		public static function coeffAire() : Number {
			return (PG.HAUTEUR_SCENE + PG.LARGEUR_SCENE) / (PG.HAUTEUR_MODELE + PG.LARGEUR_MODELE);
		}

		public static function hauteurDispoJeu() : Number {
			return HAUTEUR_SCENE - EPAISSEUR_BORD * 2 - MARGE_HAUTE - MARGE_INF;
		}
	}
}
