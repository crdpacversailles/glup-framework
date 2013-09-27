package fr.acversailles.crdp.glup.jeux.chateauMots.tir {
	import fl.motion.easing.Linear;
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;

	import fr.acversailles.crdp.glup.jeux.chateauMots.CalculeTrajectoire;
	import fr.acversailles.crdp.glup.jeux.chateauMots.ChateauMots;
	import fr.acversailles.crdp.glup.jeux.chateaumot.skins.Boule;

	import flash.events.Event;
	import flash.geom.Point;

	public class Projectile extends Boule {
		private var jeu : ChateauMots;
		private var savoirRebond : Boolean;
		private var hauteurProjectile : Number;
		private var origine : Point;
		private var rebond : Point;
		private var impacte : Point;
		private var tweenX : Tween;
		private var tweenY : Tween;
		private var explosion : Explosion;
		private var centre : Point;

		public function Projectile(jeu : ChateauMots, savoirRebond : Boolean, origine : Point, rebond : Point, impacte : Point) {
			this.jeu = jeu;
			this.origine = origine;
			this.savoirRebond = savoirRebond;
			this.rebond = rebond;
			this.impacte = impacte;
			this.cacheAsBitmap = true;
			explosion = new Explosion(jeu);

			gererTir();
		}

		private function gererTir() : void {
			this.scaleX = this.scaleX * 0.1;
			this.scaleY = this.scaleY * 0.1;
			hauteurProjectile = this.getBounds(this).height;
			centre = Point.interpolate(this.getBounds(this).bottomRight, this.getBounds(this).topLeft, 0.5);
			// rebond.y = rebond.y - centre.y;
			// rebond.x = rebond.x - centre.x;
			jeu.ajoutSprite(this);

			switch (true) {
				case (savoirRebond) :
					mouvementRebond(origine, rebond);
					break;
				default :
					mouvement(origine, impacte);
					break;
			}
		}

		private function mouvementRebond(origine : Point, rebond : Point) : void {
			switch (CalculeTrajectoire.savoirBord) {
				case 0 :
					tweenY = new Tween(this, "y", Linear.easeNone, origine.y, rebond.y, 50, false);
					break;
				case 1 :
					tweenY = new Tween(this, "y", Linear.easeNone, origine.y, rebond.y, 50, false);
					break;
			}

			tweenY.stop();
			tweenX = new Tween(this, "x", Linear.easeNone, origine.x, rebond.x, 50, false);
			tweenX.stop();
			this.addEventListener(Event.ENTER_FRAME, collision);
			tweenY.addEventListener(TweenEvent.MOTION_START, debutMouvementEvent);
			tweenX.addEventListener(TweenEvent.MOTION_FINISH, finMouvementEvent);
			tweenX.start();
			tweenY.start();
		}

		private function debutMouvementEvent(te : TweenEvent) : void {
			tweenX = new Tween(this, "scaleX", Linear.easeNone, 0.1, 0.8, 50, false);
			tweenY = new Tween(this, "scaleY", Linear.easeNone, 0.1, 0.8, 50, false);
		}

		private function finMouvementEvent(te : TweenEvent) : void {
			var temp : Point = new Point(0, 0);
			temp.x = rebond.x + centre.x;
			temp.y = rebond.y + centre.y;
			explosion.ajoutExplosion(temp);
			mouvement(rebond, impacte);
		}

		private function mouvement(rebond : Point, impacte : Point) : void {
			tweenX = new Tween(this, "x", Linear.easeNone, rebond.x, impacte.x, 50, false);
			tweenY = new Tween(this, "y", Linear.easeNone, rebond.y, impacte.y, 50, false);
			tweenX.stop();
			tweenY.stop();
			if (savoirRebond != true) {
				tweenX.addEventListener(TweenEvent.MOTION_START, debutMouvementEvent);
			}
			tweenX.addEventListener(TweenEvent.MOTION_FINISH, resetProjectileFromTe);
			this.addEventListener(Event.ENTER_FRAME, collision);
			tweenY.start();
			tweenX.start();
		}

		private function collision(e : Event) : void {
			jeu.collision(this);
		}

		public function resetProjectileFromTe(te : TweenEvent) : void {
			stopProjectile();
			removeProjectile();
		}

		public function resetProjectile() : void {
			tweenX.removeEventListener(TweenEvent.MOTION_FINISH, resetProjectileFromTe);
			stopProjectile();
			removeProjectile();
		}

		public function stopProjectile() : void {
			tweenX.stop();
			tweenY.stop();
			removeEventListener(Event.ENTER_FRAME, collision);
		}

		public function removeProjectile() : void {
			if (this.parent != null) {
				jeu.retirerProj();
				jeu.removeSprite(this);
			}
		}

		public function get hauteurProj() : Number {
			return hauteurProjectile;
		}
	}
}