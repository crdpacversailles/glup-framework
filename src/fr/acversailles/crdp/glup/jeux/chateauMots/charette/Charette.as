package fr.acversailles.crdp.glup.jeux.chateauMots.charette {
	import fl.motion.easing.Linear;
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;

	import fr.acversailles.crdp.glup.jeux.chateauMots.CalculeDimensions;
	import fr.acversailles.crdp.glup.jeux.chateaumot.skins.Chariotte;
	import fr.acversailles.crdp.glup.jeux.chateaumot.skins.Cheval;

	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.text.TextField;

	public class Charette extends Chariotte {
		private var _numero : uint;
		private var zoneTexte : TextField;
		private var tweenP : Tween;
		private var pointappa : Point = new Point(0, 0);
		private var P : Point = new Point(0, 0);
		// private var _formatTexteOptimise : TextFormat;
		private var xOriginal : Number;
		private var yOriginal : Number;
		private var scaleXOriginal : Number;
		private var scaleYOriginal : Number;
		private var cheval : MovieClip;

		public function Charette() {
			cacheAsBitmap = true;
			scaleXOriginal = this.scaleX * 0.6;
			scaleYOriginal = this.scaleY * 0.6;
			xOriginal = this.x;
			yOriginal = this.y;
			this.scaleX = scaleXOriginal;
			this.scaleY = scaleYOriginal;
			creerZoneTexte();
			creerCheval();
		}

		private function creerCheval() : void {
			cheval = new Cheval();
			cheval.x = this.x - cheval.width;
			cheval.y = this.y + (this.height / 2);
			addChild(cheval);
		}

		private function creerZoneTexte() : void {
			zoneTexte = new TextField();
			zoneTexte.selectable = false;
			zoneTexte.embedFonts = true;
			zoneTexte.wordWrap = true;
			zoneTexte.visible = true;
			zoneTexte.border = true;
			addChild(zoneTexte);
		}

		public function initP(texte : String, numeroCharette : uint, pointapp : Point) : void {
			CalculeDimensions.analyser(texte, new Point(this.width, this.height));
			P = CalculeDimensions.dimension;
			this.alpha = 1;
			this.pointappa = pointapp;
			this.width = P.x;
			this.x = pointappa.x;
			this.y = pointappa.y;
			_numero = numeroCharette;
			zoneTexte.defaultTextFormat = CalculeDimensions.formatTexteOptimise;
			zoneTexte.text = texte;
			zoneTexte.x = this.width * 0.19;
			zoneTexte.y = this.height * 0.50;
			zoneTexte.textColor = 0xFFFFFF;
			// Move
			mouvement(pointappa);
		}

		private function mouvement(pointappa : Point) : void {
			tweenP = new Tween(this, "x", Linear.easeNone, pointappa.x, pointappa.x - 650, 150, false);
			tweenP.stop();
			tweenP.addEventListener(TweenEvent.MOTION_FINISH, removeCharette);
			tweenP.start();
		}

		private function removeCharette(te : TweenEvent) : void {
			dispatchEvent(new CharetteEvent(CharetteEvent.CHARETTE_DISPARITION));
		}

		public function exploCharette() : void {
			dispatchEvent(new CharetteEvent(CharetteEvent.CHARETTE_EXPLOSION));
		}

		public function reinitialiser() : void {
			this.scaleX = scaleXOriginal;
			this.scaleY = scaleYOriginal;
			this.x = xOriginal;
			this.y = yOriginal;
		}

		public function get num() : uint {
			return _numero;
		}

		public function stopCharette() : void {
			tweenP.stop();
			tweenP.removeEventListener(TweenEvent.MOTION_FINISH, removeCharette);
		}

		public function get charette() : Charette {
			return this;
		}
	}
}
