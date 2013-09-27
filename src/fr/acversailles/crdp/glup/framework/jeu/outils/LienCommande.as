package fr.acversailles.crdp.glup.framework.jeu.outils {
	import fr.acversailles.crdp.glup.framework.graphismes.CharteCouleurs;
	import fr.acversailles.crdp.glup.framework.graphismes.FormatsTexte;
	import fr.acversailles.crdp.glup.framework.parametres.PG;
	import fr.acversailles.crdp.utils.functions.centrer;
	import fr.acversailles.crdp.utils.graphiques.InteractiveSprite;

	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	/**
	 * @author joachim
	 */
	public class LienCommande extends InteractiveSprite implements ISupportCommande {
		private var icone1 : Sprite;
		private var couleurIcone : uint;
		private var _idCommande : String;
		private var texte : String;
		private var zoneTexte : TextField;
		public static var largeurMaxZoneTexte:Number=0;

		public function LienCommande(id : String, icone : Sprite, texte : String) {
			this.texte = texte;
			_idCommande = id;
			mouseChildren = false;
			this.icone1 = icone;
			ajouter(icone);
			creerZoneTexte();
			actualiserApparence(true);
		}

		private function creerZoneTexte() : void {
			zoneTexte = new TextField();
			zoneTexte.mouseEnabled = false;
			zoneTexte.multiline = false;
			zoneTexte.wordWrap = false;
			zoneTexte.embedFonts = true;
			zoneTexte.selectable = false;
			var formatTexte : TextFormat = FormatsTexte.donnerFormat(FormatsTexte.COMMANDE);
			zoneTexte.defaultTextFormat = formatTexte;
			zoneTexte.text = texte;
			zoneTexte.autoSize = TextFieldAutoSize.LEFT;
			addChild(zoneTexte);
			centrer(zoneTexte, 0, PG.HAUTEUR_LIENS_COMMANDES);
			zoneTexte.x = icone1.getBounds(this).right + PG.MARGE_DROITE_ICONE_LIEN_COMMANDE;
			var mesureLargeur:Number = icone1.getBounds(this).right + PG.MARGE_DROITE_ICONE_LIEN_COMMANDE + zoneTexte.width;
			largeurMaxZoneTexte=Math.max(mesureLargeur, largeurMaxZoneTexte);
		}

		private function ajouter(icone : Sprite):void {
			dimensionner(icone);
			centrerIcone(icone);
			icone.x = PG.MARGE_GAUCHE_ICONE_LIEN_COMMANDE;
			addChild(icone);
		}

		override protected function actualiserApparence(redessiner : Boolean) : void {
			switch(_etat) {
				case UP:
					couleurIcone = CharteCouleurs.TEXTE_COMMANDE;
					break;
				case HOVER:
					couleurIcone = CharteCouleurs.ACCENTUATION;
					break;
				case DOWN:
					couleurIcone = CharteCouleurs.TEXTE_GENERAL;
					break;
				case SELECTED:
					couleurIcone = CharteCouleurs.FOND_GENERAL;
					break;
				case DISABLED:
					couleurIcone = CharteCouleurs.FOND_FAIBLE;
					break;
			}
			if (redessiner) {
			//	recolorierIcone(icone1);
				recolorierTexte();
			}
		}

		private function recolorierTexte() : void {
			var format : TextFormat = zoneTexte.getTextFormat();
			format.color=couleurIcone;
			zoneTexte.setTextFormat(format);
		}



//		private function recolorierIcone(icone : Sprite) : void {
//			var ct : ColorTransform = new ColorTransform();
//			ct.color = couleurIcone;
//			if (icone )
//				icone.transform.colorTransform = ct;
//		}

		private	function dimensionner(icone : Sprite) : void {
			var coeff : Number = PG.HAUTEUR_LIENS_COMMANDES * PG.REDUCTION_ICONE_LIEN_COMMANDE;
			coeff /= Math.max(icone.width, icone.height);
			icone.width *= coeff;
			icone.height *= coeff;
		}

		private	function centrerIcone(icone : Sprite) : void {
			centrer(icone, 0, PG.HAUTEUR_LIENS_COMMANDES);
		}

		public function get idCommande() : String {
			return _idCommande;
		}
	}
}

