package fr.acversailles.crdp.glup.jeux.chateauMots.tir {
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import fl.transitions.easing.Regular;

	import fr.acversailles.crdp.glup.jeux.chateauMots.ChateauMots;

	import flash.display.Sprite;
	import flash.geom.Point;
	

	public class Explosion extends Sprite {
		private var TweenJ : Tween, TweenL : Tween;
		private var rondImpacte : Sprite;
		private var jeu : ChateauMots;
		private var i : Number = 0;

		public function Explosion(jeu : ChateauMots) {
			this.jeu = jeu;
		}

		public function ajoutExplosion(cibleCarre : Point) : void {
			
			i=0;
			rondImpacte = new Sprite();
			rondImpacte.graphics.beginFill(0xff0fff);
			rondImpacte.graphics.drawCircle(0, 0, 5);
			rondImpacte.graphics.endFill();
			//jeu.ajoutSprite(rondImpacte);

			rondImpacte.x = cibleCarre.x;
			rondImpacte.y = cibleCarre.y;
			TweenJ = new Tween(rondImpacte, "scaleX", Regular.easeOut, 1, 15, 7, false);
			TweenJ.stop();
			TweenL = new Tween(rondImpacte, "scaleY", Regular.easeOut, 1, 15, 7, false);
			TweenL.stop();
			
			TweenL.addEventListener(TweenEvent.MOTION_FINISH, finExplosion);
			TweenJ.addEventListener(TweenEvent.MOTION_FINISH, finExplosion);
			
			TweenJ.start();
			TweenL.start();
		}

		public function finExplosion(te : TweenEvent) : void {
			te.target.yoyo();
			te.target.addEventListener(TweenEvent.MOTION_FINISH, removeExplosion);
		}

		public function removeExplosion(te : TweenEvent) : void {
			i++;
			te.target.removeEventListener(TweenEvent.MOTION_FINISH, removeExplosion);
			if (i==1){
				//jeu.removeSprite(rondImpacte);
			}
			
		}
	}
}
