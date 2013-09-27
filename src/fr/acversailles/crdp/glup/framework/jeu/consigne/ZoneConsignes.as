package fr.acversailles.crdp.glup.framework.jeu.consigne {
	import fr.acversailles.crdp.utils.functions.nettoyerChaineXML;
	import fr.acversailles.crdp.glup.framework.graphismes.FormatsTexte;
	import fr.acversailles.crdp.glup.framework.parametres.PG;

	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.filters.BevelFilter;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	/**
	 * @author joachim
	 */
	public class ZoneConsignes extends Sprite {
		private var zoneTexte : TextField;
		private var consigne : String;
		private var fond : Shape;

		public function ZoneConsignes(consigne : String) {
			this.consigne = nettoyerChaineXML(consigne);
			dessiner();

			creerZoneTexte();
		}

		private function dessiner() : void {
			fond = new Shape();
			addChild(fond);
			var fillType : String = GradientType.LINEAR;
			var colors : Array = [0xc00000, 0x9e0e0e];
			var alphas : Array = [1, 1];
			var ratios : Array = [0, 255 ];
			var matr : Matrix = new Matrix();
			matr.createGradientBox(PG.LARGEUR_SCENE, PG.MARGE_HAUTE + PG.HAUTEUR_CONSIGNE, 0, 0, 0);
			var spreadMethod : String = SpreadMethod.PAD;
			fond.graphics.beginGradientFill(fillType, colors, alphas, ratios, matr, spreadMethod);
			fond.graphics.lineStyle(1, 0);
			fond.graphics.drawRoundRectComplex(PG.LARGEUR_OUTILS+PG.MARGE_DROITE, PG.MARGE_HAUTE, PG.LARGEUR_SCENE-PG.LARGEUR_OUTILS-PG.MARGE_DROITE-PG.MARGE_GAUCHE, PG.HAUTEUR_CONSIGNE , PG.ARRONDI_BORDS_CONSIGNE_JEU, PG.ARRONDI_BORDS_CONSIGNE_JEU,0,0);
			fond.graphics.endFill();
			fond.filters = [new BevelFilter(6, 45,0xe73030, 1, 0xaa0101, 1)];
		}

		private function creerZoneTexte() : void {
			zoneTexte = new TextField();
			zoneTexte.mouseEnabled = false;
			zoneTexte.multiline = true;
			zoneTexte.wordWrap = true;
			zoneTexte.embedFonts = true;
			zoneTexte.selectable = false;
			var formatTexte : TextFormat = FormatsTexte.donnerFormat(FormatsTexte.CONSIGNE_JEU);
			zoneTexte.defaultTextFormat = formatTexte;
			zoneTexte.text = consigne;
			zoneTexte.autoSize = TextFieldAutoSize.LEFT;
			zoneTexte.width = PG.largeurDispoJeu();
			addChild(zoneTexte);
			while (zoneTexte.textHeight > PG.HAUTEUR_CONSIGNE && formatTexte.size > 1) {
				formatTexte.size = uint(formatTexte.size) - 1;
				zoneTexte.setTextFormat(formatTexte);
			}
			zoneTexte.y = PG.MARGE_HAUTE + (PG.HAUTEUR_CONSIGNE - zoneTexte.height) / 2;
			zoneTexte.x = PG.MARGE_GAUCHE + PG.LARGEUR_OUTILS + PG.EPAISSEUR_BORD;
		}
	}
}
