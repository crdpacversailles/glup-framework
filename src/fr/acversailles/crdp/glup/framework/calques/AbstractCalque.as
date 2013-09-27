package fr.acversailles.crdp.glup.framework.calques {
	import fr.acversailles.crdp.glup.framework.graphismes.FormatsTexte;
	import fr.acversailles.crdp.glup.framework.jeu.outils.LienCommande;
	import fr.acversailles.crdp.glup.framework.parametres.PG;
	import fr.acversailles.crdp.utils.avertirClasseAbstraite;

	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	/**
	 * @author joachim
	 */
	public class AbstractCalque extends Sprite implements ICalque {
		private var zoneTitre : TextField;
		protected var titre : String;
		protected var texte : String;
		private var zoneTexte : TextField;
		protected var textesSupplementaire : Vector.<String>;
		

		public function AbstractCalque(textesSupplementaire : Vector.<String>) {
			this.textesSupplementaire = textesSupplementaire;
			determinerTextes();
			creerZoneTitre();
			creerZoneTexte();
			ajouterCommandes();
		}

		protected function ajouterCommandes() : void {
			avertirClasseAbstraite();
		}

		private function creerZoneTitre() : void {
			zoneTitre = new TextField();
			zoneTitre.mouseEnabled = false;
			zoneTitre.multiline = false;
			zoneTitre.wordWrap = false;
			zoneTitre.embedFonts = true;
			zoneTitre.selectable = false;
			var formatTexte : TextFormat = FormatsTexte.donnerFormat(FormatsTexte.TITRE_CALQUE);
			zoneTitre.defaultTextFormat = formatTexte;
			zoneTitre.text = titre;
			zoneTitre.width = PG.LARGEUR_CALQUES - PG.MARGES_LATERALES_CALQUE *2;
			zoneTitre.height = zoneTitre.textHeight + 5;
			addChild(zoneTitre);
			zoneTitre.y = 0;//PG.MARGE_SUP_CALQUE;
			zoneTitre.x = PG.MARGES_LATERALES_CALQUE;
		}

		private function creerZoneTexte() : void {
			zoneTexte = new TextField();
			zoneTexte.mouseEnabled = false;
			zoneTexte.multiline = true;
			zoneTexte.wordWrap = true;
			zoneTexte.embedFonts = true;
			zoneTexte.selectable = false;
			var formatTexte : TextFormat = FormatsTexte.donnerFormat(FormatsTexte.TEXTE_CALQUE);
			zoneTexte.defaultTextFormat = formatTexte;
			zoneTexte.text = texte;
			zoneTexte.autoSize = TextFieldAutoSize.LEFT;
			zoneTexte.width = PG.LARGEUR_CALQUES - 2 * PG.MARGES_LATERALES_CALQUE - PG.MARGE_GAUCHE_BAS_CALQUE;
			addChild(zoneTexte);
			zoneTexte.y = PG.MARGE_INF_TITRE_CALQUE + zoneTitre.getBounds(this).bottom;
			zoneTexte.x = PG.MARGE_GAUCHE_BAS_CALQUE + PG.MARGES_LATERALES_CALQUE;
		}

		protected function determinerTextes() : void {
			avertirClasseAbstraite();
		}

		public function get sprite() : Sprite {
			return this;
		}

		protected function ajouterCommande(lienCommande : LienCommande) : void {
			addChild(lienCommande);
			lienCommande.x = PG.MARGE_GAUCHE_BAS_CALQUE;
			lienCommande.y = height + PG.MARGE_SUP_COMMANDES;
			ajusterZonesTexte();
		}

		private function ajusterZonesTexte() : void {
			//on les remet à leur largeur de base
			zoneTexte.width = PG.LARGEUR_CALQUES - 2 * PG.MARGES_LATERALES_CALQUE - PG.MARGE_GAUCHE_BAS_CALQUE;
			zoneTitre.width = PG.LARGEUR_CALQUES - 2 * PG.MARGES_LATERALES_CALQUE;
			//on les ajuste sur les commandes
			zoneTexte.width = width - 2 * PG.MARGES_LATERALES_CALQUE;
			zoneTitre.width = zoneTexte.width + PG.MARGE_GAUCHE_BAS_CALQUE;
		}

		public function getHauteurTitre() : Number {
			return zoneTitre.textHeight;
		}
	}
}
