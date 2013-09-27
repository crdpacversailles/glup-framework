package fr.acversailles.crdp.glup.framework.communs.accueil {
	import fr.acversailles.crdp.glup.framework.communs.AbstractPanneau;
	import fr.acversailles.crdp.glup.framework.controle.ControleurGeneral;
	import fr.acversailles.crdp.glup.framework.donnees.IContenu;
	import fr.acversailles.crdp.glup.framework.donnees.IOptions;
	import fr.acversailles.crdp.glup.framework.graphismes.CharteCouleurs;
	import fr.acversailles.crdp.glup.framework.graphismes.FormatsTexte;
	import fr.acversailles.crdp.glup.framework.icones.IconeInstructions;
	import fr.acversailles.crdp.glup.framework.icones.IconeJouer;
	import fr.acversailles.crdp.glup.framework.icones.IconeLogoCRDP;
	import fr.acversailles.crdp.glup.framework.icones.IconeLogoGLUP;
	import fr.acversailles.crdp.glup.framework.jeu.outils.LienCommande;
	import fr.acversailles.crdp.glup.framework.parametres.PG;
	import fr.acversailles.crdp.utils.functions.centrer;
	import fr.acversailles.crdp.utils.functions.nettoyerChaineXML;
	import fr.acversailles.crdp.utils.functions.tr;

	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	/**
	 * @author joachim
	 */
	public class Accueil extends AbstractPanneau {
		private var nbCommandes : uint;
		private var nomJeu : String;
		private var zoneNomJeu : TextField;
		private var zoneConsigne : TextField;
		private var logoCRDP : IconeLogoCRDP;
		private var aide : AffichageAide;
	//	private var zoneLogo : TextField;
	//	private var zoneAvertissement : TextField;
		private var logoGlup : IconeLogoGLUP;

		public function Accueil(nomJeu : String, options : IOptions, contenu : IContenu) {
			this.nomJeu = nettoyerChaineXML(nomJeu);
			super(options, contenu);
			mettreLogos();
			mettreZoneNomJeu();
			mettreZoneConsigne();
			
			//mettreZoneAvertissement();
			ajouterCommandes();
			creerAide();
		}

//		private function mettreZoneAvertissement() : void {
//			zoneAvertissement = new TextField();
//			zoneAvertissement.mouseEnabled = false;
//			zoneAvertissement.multiline = false;
//			zoneAvertissement.wordWrap = true;
//			zoneAvertissement.embedFonts = true;
//			zoneAvertissement.selectable = false;
//			var formatTexte : TextFormat = FormatsTexte.donnerFormat(FormatsTexte.AVERTISSEMENT);
//			zoneAvertissement.defaultTextFormat = formatTexte;
//			zoneAvertissement.text = tr("AVERTISSEMENT");
//			zoneAvertissement.autoSize= TextFieldAutoSize.LEFT;
//			addChild(zoneAvertissement);
//			zoneAvertissement.y = zoneLogo.y;
//			zoneAvertissement.x = zoneLogo.getBounds(this).right+ PG.MARGES_LATERALES_AVERTISSEMENT;
//			zoneAvertissement.width = logoCRDP.x - PG.MARGES_LATERALES_AVERTISSEMENT - zoneAvertissement.x;
//		}

		private function creerAide() : void {
			var hauteurDispo : Number = PG.HAUTEUR_SCENE - PG.EPAISSEUR_BORD * 2 - PG.MARGE_HAUTE - PG.MARGE_INF - zoneConsigne.getBounds(this).bottom - PG.MARGE_SUP_AIDE_ACCUEIL - PG.MARGE_INF_AIDE_ACCUEIL ;
			var largeurDispo : Number = zoneConsigne.width;
			aide = new AffichageAide(options.getAide(), largeurDispo, hauteurDispo);
			aide.x = zoneConsigne.x + 1;
			aide.y = zoneConsigne.getBounds(this).bottom + PG.MARGE_SUP_AIDE_ACCUEIL;
			addChild(aide);
			// mettre sur la scène avant enregistrer y pour permettre mettre masque
			aide.enregistrerY();

			aide.visible = false;
		}

		private function ajouterCommandes() : void {
			ajouterCommande(new LienCommande(ControleurGeneral.JOUER, new IconeJouer(), tr("JOUER")));
			ajouterCommande(new LienCommande(ControleurGeneral.AIDE, new IconeInstructions(), tr("INSTRUCTIONS")));
			
		}

		override protected function determinerCouleurFond() : void {
			couleurFond = CharteCouleurs.BLANC;
		}

		private function mettreLogos() : void {
			logoCRDP = new IconeLogoCRDP();
			logoCRDP.width = PG.LARGEUR_LOGO_CRDP_ACCUEIL;
			logoCRDP.scaleY = logoCRDP.scaleX;
			addChild(logoCRDP);
			logoCRDP.x = PG.LARGEUR_SCENE - PG.EPAISSEUR_BORD - PG.MARGE_DROITE - PG.MARGE_DROITE_ICONE_CRDP - logoCRDP.width;
			logoCRDP.y = PG.HAUTEUR_SCENE - PG.EPAISSEUR_BORD - PG.MARGE_INF - PG.MARGE_INF_ICONE_CRDP - logoCRDP.height;
			
			logoGlup = new IconeLogoGLUP();
			logoGlup.height = PG.HAUTEUR_LOGO_GLUP_ACCUEIL;
			logoGlup.scaleX=logoGlup.scaleY;
			centrer(logoGlup, PG.largeurDispoJeu());
			logoGlup.x += PG.MARGE_GAUCHE +PG.LARGEUR_OUTILS;
			logoGlup.y = PG.MARGE_HAUTE + PG.MARGE_SUP_LOGO_GLUP;
			
			addChild(logoGlup);
		}

		private function mettreZoneNomJeu() : void {
			zoneNomJeu = new TextField();
			zoneNomJeu.mouseEnabled = false;
			zoneNomJeu.multiline = true;
			zoneNomJeu.wordWrap = true;
			zoneNomJeu.embedFonts = true;
			zoneNomJeu.selectable = false;
			var formatTexte : TextFormat = FormatsTexte.donnerFormat(FormatsTexte.TITRE_JEU);
			zoneNomJeu.defaultTextFormat = formatTexte;
			zoneNomJeu.text = nomJeu;
			zoneNomJeu.width = PG.largeurDispoJeu();
			addChild(zoneNomJeu);
			while (zoneNomJeu.numLines > 2) {
				formatTexte.size = uint(formatTexte.size) - 1;
				zoneNomJeu.setTextFormat(formatTexte);
			}
			zoneNomJeu.height=zoneNomJeu.textHeight+5;
			zoneNomJeu.y = logoGlup.getBounds(this).bottom + PG.MARGE_SUP_TITRE_JEU;
			zoneNomJeu.x = PG.MARGE_GAUCHE + PG.LARGEUR_OUTILS + PG.EPAISSEUR_BORD;
		}

		private function mettreZoneConsigne() : void {
			zoneConsigne = new TextField();
			zoneConsigne.mouseEnabled = false;
			zoneConsigne.multiline = true;
			zoneConsigne.wordWrap = true;
			zoneConsigne.embedFonts = true;
			zoneConsigne.selectable = false;
			var formatTexte : TextFormat = FormatsTexte.donnerFormat(FormatsTexte.CONSIGNE_ACCUEIL);
			zoneConsigne.defaultTextFormat = formatTexte;
			zoneConsigne.text = nettoyerChaineXML(contenu.getConsigne());
			zoneConsigne.background = true;

			zoneConsigne.autoSize = TextFieldAutoSize.RIGHT;
			zoneConsigne.width = PG.largeurDispoJeu() - 2*PG.MARGES_LATERALES_CONSIGNE_ACCUEIL;
			addChild(zoneConsigne);
			zoneConsigne.y = zoneNomJeu.y + zoneNomJeu.textHeight + PG.MARGE_SUP_CONSIGNE_JEU;
			while (zoneConsigne.height > PG.HAUTEUR_MAX_ZONE_CONSIGNE_Accueil) {
				formatTexte.size = Number(formatTexte.size) - 1;
				zoneConsigne.setTextFormat(formatTexte);
			}
			zoneConsigne.x += PG.MARGE_GAUCHE + PG.LARGEUR_OUTILS + PG.EPAISSEUR_BORD+PG.MARGES_LATERALES_CONSIGNE_ACCUEIL;
		}

		protected function ajouterCommande(lienCommande : LienCommande) : void {
			addChild(lienCommande);
			
			lienCommande.y = zoneConsigne.getBounds(this).bottom + PG.MARGE_SUP_COMMANDES_ACCUEIL + (PG.MARGE_ENTRE_COMMANDES_ACCUEIL + lienCommande.height) * nbCommandes;
			nbCommandes++;
			graphics.clear();
			dessiner();
			graphics.lineStyle(PG.EPAISSEUR_BORD_COMMANDES_ACCUEIL, CharteCouleurs.BORD_FAIBLE);
			repositionnerLienCommandes();
			var xCadre : Number = lienCommande.x - PG.PADDING_CADRE_COMMANDE_ACCUEIL ;
			var yCadre : Number = zoneConsigne.getBounds(this).bottom + PG.MARGE_SUP_COMMANDES_ACCUEIL - PG.PADDING_CADRE_COMMANDE_ACCUEIL;
			var largeurCadre : Number = PG.PADDING_CADRE_COMMANDE_ACCUEIL*2 + lienCommande.width;
			var hauteurCadre : Number = PG.PADDING_CADRE_COMMANDE_ACCUEIL*2 + (PG.MARGE_ENTRE_COMMANDES_ACCUEIL + lienCommande.height) * nbCommandes;
			graphics.drawRoundRect(xCadre, yCadre, largeurCadre, hauteurCadre, PG.EPAISSEUR_BORD_COMMANDES_ACCUEIL);
			
		}

		private function repositionnerLienCommandes() : void {
			for (var i : int = 0; i < numChildren; i++) {
				if (getChildAt(i) is LienCommande) {
					var lienCommande : LienCommande = getChildAt(i) as LienCommande;
					lienCommande.x = (PG.largeurDispoJeu()-LienCommande.largeurMaxZoneTexte)/2;
					lienCommande.x += PG.MARGE_GAUCHE + PG.LARGEUR_OUTILS + PG.EPAISSEUR_BORD;
				}
			}
		}

		override public function activer() : void {
			// rien
		}

		override public function desactiver() : void {
			// rien
		}

		public function afficherAide() : void {
			aide.afficher(true);
		}

		public function masquerAide() : void {
			aide.afficher(false);
		}
	}
}
