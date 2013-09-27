package fr.acversailles.crdp.glup.jeux.chateauMots {
	import fr.acversailles.crdp.glup.framework.graphismes.FormatsTexte;

	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class CalculeDimensions {
		private static const LARGEUR_MAX : Number = 1.30;
		private static var zoneTexte : TextField;
		private static var _enonce : String;
		private static var _dimension : Point;
		private static var _dimensionsCharetteMin : Point;
		private static var _dimensionsCharetteMax : Point;
		private static var _formatTexteOptimise : TextFormat;

		public static function analyser(enonces : String, dimensionsCharette : Point) : void {
			_enonce = enonces;
			_dimensionsCharetteMin = dimensionsCharette;
			_dimensionsCharetteMax = dimensionsCharette;
			_dimension = new Point(_dimensionsCharetteMin.x, _dimensionsCharetteMax.y);
			_dimensionsCharetteMax.x = _dimensionsCharetteMax.x * LARGEUR_MAX;
			
			_formatTexteOptimise = FormatsTexte.donnerFormat(FormatsTexte.ITEM_DANS_JEU_CHARETTE);
			creerZoneTexte();
			rechercheDeLaConfiguration();
		}

		private static function rechercheDeLaConfiguration() : void {
			_dimension = new Point();
			calculerDimensions(_enonce);
		}

		private static function calculerDimensions(e : String) : void {
			var mot : String = e;
			zoneTexte.defaultTextFormat = _formatTexteOptimise;
			zoneTexte.setTextFormat(_formatTexteOptimise);
			zoneTexte.text = mot;
			zoneTexte.width=_dimensionsCharetteMin.x;
			while (zoneTexte.height > _dimensionsCharetteMax.y) {


				if (zoneTexte.width < _dimensionsCharetteMax.x) {
					zoneTexte.width=zoneTexte.width+1;
				}

				if (zoneTexte.width >= _dimensionsCharetteMax.x) {
					reduirePolice();
					zoneTexte.setTextFormat(_formatTexteOptimise);
				}
			}
			_dimension.x = zoneTexte.width;
			trace('_dimension: ' + (_dimension));
		}
		
		private static function reduirePolice() : void {
			CalculeDimensions._formatTexteOptimise.size = uint(CalculeDimensions._formatTexteOptimise.size) - 1;
		}

		private static function creerZoneTexte() : void {
			zoneTexte = new TextField();
			zoneTexte.multiline = false;
			zoneTexte.embedFonts = true;
			zoneTexte.wordWrap = true;
			zoneTexte.autoSize = TextFieldAutoSize.LEFT;
		}

		static public function get dimension() : Point {
			return _dimension;
		}

		static public function get formatTexteOptimise() : TextFormat {
			return _formatTexteOptimise;
		}
	}
}
