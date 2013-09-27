package fr.acversailles.crdp.glup.jeux.popMots {
	import fr.acversailles.crdp.glup.framework.donnees.IEnonce;
	import fr.acversailles.crdp.glup.framework.graphismes.FormatsTexte;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class CalculateurDimensions {
		private static var _dimensions : Vector.<Point>;
		private static var zoneTexte : TextField;
		private static var _enonces : Vector.<IEnonce>;
		private static const CONFIGURATION_MAX_V : uint = 10;
		private static const CONFIGURATION_MAX_H : uint = 9;
		private static const PROP_TEXTE_H : Number = 132 / 180;
		private static const PROP_TEXTE_V : Number = 109 / 200;
		private static var _configuration : Array;
		private static var _dimensionMax : Point;
		private static var _dimensionsJeu : Point;
		private static var _formatTexteOptimise : TextFormat;

		public static function analyser(enonces : Vector.<IEnonce>, dimensionsJeu : Point) : void {
			_dimensionsJeu = dimensionsJeu;
			_enonces = enonces;
			_dimensions = new Vector.<Point>;
			_dimensionMax = new Point(0, 0);
			_formatTexteOptimise = FormatsTexte.donnerFormat(FormatsTexte.ITEM_DANS_JEU_SANS_MARGES);
			creerZoneTexte();
			rechercheDeLaConfiguration();
		}

		private static function rechercheDeLaConfiguration() : void {
			var premierTour:Boolean = true;
			do {
				_dimensionMax = new Point();
				for each (var e : IEnonce in _enonces) {
					calculerDimensions(e);
				}
				_configuration = [CONFIGURATION_MAX_V, CONFIGURATION_MAX_H];
				while (configurationTropSerree() && _configuration[1] > 0) {
					_configuration[0] = _configuration[0] - 1;
					_configuration[1] = _configuration[1] - 1;
				}
				if (!premierTour)
					reduirePolice();
				premierTour = false;
			} while (_configuration[1] == 0);
		}

		private static function reduirePolice() : void {
			CalculateurDimensions._formatTexteOptimise.size = uint(CalculateurDimensions._formatTexteOptimise.size) - 1;
		}

		private static function configurationTropSerree() : Boolean {
			return _dimensionMax.x / PROP_TEXTE_H * _configuration[0] > CalculateurDimensions._dimensionsJeu.x || _dimensionMax.y / PROP_TEXTE_V * _configuration[1] > CalculateurDimensions._dimensionsJeu.y ;
		}

		private static function calculerDimensions(e : IEnonce) : void {
			var motLePlusLong : String = plusLongMot(e.contenu);
			zoneTexte.defaultTextFormat = _formatTexteOptimise;
			zoneTexte.setTextFormat(_formatTexteOptimise);
			zoneTexte.wordWrap = false;
			var largeurMin : Number = determinerLargeur(motLePlusLong);
			zoneTexte.wordWrap = true;

			zoneTexte.text = e.contenu;

			zoneTexte.width = largeurMin;

			while (zoneTexte.width < zoneTexte.textHeight) {
				zoneTexte.width++;
			}
			var dimensionZT : Point = new Point(zoneTexte.width, zoneTexte.height);
			_dimensionMax.x = Math.max(dimensionZT.x, _dimensionMax.x);
			_dimensionMax.y = Math.max(dimensionZT.y, _dimensionMax.y);
			_dimensions.push(dimensionZT);
		}

		private static function determinerLargeur(motLePlusLong : String) : Number {
			zoneTexte.text = motLePlusLong;
			return zoneTexte.width;
		}

		private static function plusLongMot(contenu : String) : String {
			var mots : Array = contenu.split(" ");
			var motLePlusLong : String;
			var longueurMax : uint = 0;
			for each (var mot : String in mots) {
				if (mot.length > longueurMax) {
					motLePlusLong = mot;
					longueurMax = mot.length;
				}
			}
			return motLePlusLong;
		}

		private static function creerZoneTexte() : void {
			zoneTexte = new TextField();
			zoneTexte.multiline = true;
			zoneTexte.embedFonts = true;
			zoneTexte.wordWrap = true;
			zoneTexte.defaultTextFormat = _formatTexteOptimise;
			zoneTexte.autoSize = TextFieldAutoSize.LEFT;
		}

		static public function get dimensions() : Vector.<Point> {
			return _dimensions;
		}

		static public function get configuration() : Array {
			return _configuration;
		}

		static public function get dimensionMax() : Point {
			return _dimensionMax;
		}

		static public function get formatTexteOptimise() : TextFormat {
			return _formatTexteOptimise;
		}
	}
}
