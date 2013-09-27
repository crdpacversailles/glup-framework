package fr.acversailles.crdp.glup.framework.jeu.outils {
	import fr.acversailles.crdp.glup.framework.graphismes.CharteCouleurs;
	import fr.acversailles.crdp.glup.framework.icones.FondBoutonInactif;
	import fr.acversailles.crdp.glup.framework.icones.FondBoutonNormal;
	import fr.acversailles.crdp.glup.framework.icones.FondBoutonSurvol;
	import fr.acversailles.crdp.glup.framework.parametres.PG;
	import fr.acversailles.crdp.utils.functions.centrer;
	import fr.acversailles.crdp.utils.graphiques.InteractiveSprite;

	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;

	/**
	 * @author joachim
	 */
	public class BoutonOutil extends InteractiveSprite implements ISupportCommande {
		private static const PROPORTION : Number=0.9;
		private var icone1 : Sprite;
		private var deuxEtats : Boolean;
		private var icone2 : Sprite;
		private var _etatIcone : uint;
		private var _idCommande : String;
		private var fondSurvol : Bitmap;
		private var fondNormal : Bitmap;
		private var coloration : ColorTransform;
		private var couleurIcone : uint;
		private var coeff : Number;
		private var fondInactif : FondBoutonInactif;

		public function BoutonOutil(id : String, icone1 : Sprite, icone2 : Sprite = null, etatInitial : uint = 0) {
			_idCommande = id;
			mouseChildren = false;
			this.deuxEtats = deuxEtats;
			this.icone1 = icone1;
			this.icone2 = icone2;
			dessinerFond();
			ajouter(icone1);
			if (icone2) ajouter(icone2);
			super();

			
			
			etatIcone = etatInitial;
		}

		private function ajouter(icone : Sprite) : void {
			addChild(icone);
			dimensionner(icone);
			centrerIcone(icone);
			colorier();
		}

		private function colorier() : void {
			coloration = new ColorTransform();
			
		}

		override protected function actualiserApparence(redessiner : Boolean) : void {
			redessiner=redessiner;
			switch(_etat) {
				case UP:
					fondNormal.visible=true;
					fondSurvol.visible=false;
					fondInactif.visible=false;
					couleurIcone= CharteCouleurs.ICONE_BOUTON_UP;
					alpha=1;
					redimensionner(1);
					break;
				case HOVER:
					fondNormal.visible=false;
					fondInactif.visible=false;
					fondSurvol.visible=true;
					couleurIcone= CharteCouleurs.BLANC;
					alpha=1;
					redimensionner(1);
					break;
				case DOWN:
					fondNormal.visible=false;
					fondInactif.visible=false;
					fondSurvol.visible=true;
					couleurIcone= CharteCouleurs.BLANC;
					alpha=1;
					redimensionner(PROPORTION);
					break;
				case SELECTED:
					fondNormal.visible=false;
					fondSurvol.visible=true;
					fondInactif.visible=false;
					alpha=1;
					couleurIcone= CharteCouleurs.FOND_FAIBLE;
					redimensionner(1);
					break;
				case DISABLED:
					fondNormal.visible=false;
					fondSurvol.visible=false;
					fondInactif.visible=true;
					couleurIcone= CharteCouleurs.TEXTE_INERTE;
					redimensionner(1);
					alpha=0.5;
					break;
			}
			coloration.color=couleurIcone;
			icone1.transform.colorTransform = coloration;
			if(icone2) icone2.transform.colorTransform = coloration;
		}

		private function redimensionner(proportion : Number) : void {
			fondInactif.width = fondInactif.height =fondNormal.width=fondSurvol.width=fondNormal.height= fondSurvol.height=proportion*2 * PG.RAYON_BOUTONS_OUTILS;
			fondInactif.x = fondInactif.y =fondNormal.x = fondSurvol.x = fondNormal.y = fondSurvol.y = (1-proportion) * PG.RAYON_BOUTONS_OUTILS;
		}

		private function dessinerFond() : void {
			fondNormal = new FondBoutonNormal();
			fondSurvol = new FondBoutonSurvol();
			fondInactif = new FondBoutonInactif();
			redimensionner(1);
			addChild(fondNormal);
			addChild(fondSurvol);
			addChild(fondInactif);
		}


		private	function dimensionner(icone : Sprite) : void {
			coeff = PG.RAYON_BOUTONS_OUTILS * 2 * PG.REDUCTION_ICONE_BOUTON_OUTIL ;
			coeff /= Math.max(icone.width, icone.height);
			icone.width *= coeff;
			icone.height *= coeff;
		}

		private	function centrerIcone(icone : Sprite) : void {
			centrer(icone, PG.RAYON_BOUTONS_OUTILS * 2 , PG.RAYON_BOUTONS_OUTILS * 2 );
		}

		public function get etatIcone() : uint {
			return _etatIcone;
		}

		public function set etatIcone(etatIcone : uint) : void {
			_etatIcone = etatIcone;
			icone1.visible = etatIcone == 0;
			if (icone2)
				icone2.visible = etatIcone != 0;
		}

		public function get idCommande() : String {
			return _idCommande;
		}
	}
}

