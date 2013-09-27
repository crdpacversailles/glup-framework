package fr.acversailles.crdp.glup.framework.jeu.chrono {
	import fr.acversailles.crdp.glup.framework.controle.SynchronisationEvent;
	import fr.acversailles.crdp.glup.framework.graphismes.CharteCouleurs;
	import fr.acversailles.crdp.glup.framework.parametres.PG;
	import fr.acversailles.crdp.glup.framework.son.DiffusionSons;
	import fr.acversailles.crdp.glup.framework.son.LibrairieSons;

	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.utils.Timer;

	/**
	 * @author joachim
	 */
	public class BarreChrono extends Sprite {
		private var nbDigits : uint;
		private var temps : int;
		private var tempsDepart : uint;
		private var timer : Timer;
		private var hauteur : Number;
		private var barre : Shape;
		private var cacheBarre : Shape;

		public function BarreChrono(tempsDepart : uint, hauteur : Number) {
			this.hauteur = hauteur;
			this.tempsDepart = tempsDepart;
			this.nbDigits = tempsDepart.toString().length;
			creerTimer();
			creerBarreEtCache();
			dessinerFond();
		}

		private function creerTimer() : void {
			timer = new Timer(1000, tempsDepart);
			timer.addEventListener(TimerEvent.TIMER, miseAJour);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, gererFinTemps);
		}

		private function gererFinTemps(event : TimerEvent) : void {
			timer.stop();
			dispatchEvent(new SynchronisationEvent(SynchronisationEvent.FIN_CHRONO));
		}

		private function miseAJour(event : TimerEvent) : void {
			afficherTemps(tempsDepart - timer.currentCount);
			DiffusionSons.jouerSon(LibrairieSons.TIC_1);
		}

		public function demarrer() : void {
			timer.reset();
			miseAJour(null);
			timer.start();
		}

		public function arreter() : void {
			timer.stop();
		}

		private function creerBarreEtCache() : void {
			barre = new Shape();
			var fillType : String = GradientType.LINEAR;
			var colors : Array = [0x52e300, 0xf0cf13, 0xff810f, 0xff0000];
			var alphas : Array = [1, 1, 1, 1];
			var ratios : Array = [0, 82, 164,255 ];
			var matr : Matrix = new Matrix();
			matr.createGradientBox(PG.RAYON_BOUTONS_OUTILS * 2, hauteur, Math.PI / 2, 0, 0);
			var spreadMethod : String = SpreadMethod.PAD;
			barre.graphics.beginGradientFill(fillType, colors, alphas, ratios, matr, spreadMethod);
			barre.graphics.lineStyle(0, 0, 0);
			barre.graphics.drawRect(0, 0, PG.RAYON_BOUTONS_OUTILS - PG.EPAISSEUR_BORD_CHRONO, hauteur - PG.EPAISSEUR_BORD_CHRONO);
			barre.x = PG.EPAISSEUR_BORD_CHRONO / 2 ;
			barre.y = PG.EPAISSEUR_BORD_CHRONO / 2;
			barre.graphics.endFill();
			addChild(barre);
			cacheBarre = new Shape();
			cacheBarre.graphics.beginFill(0x000000);
			cacheBarre.graphics.lineStyle(0, 0, 0);
			cacheBarre.graphics.drawRect(0, 0, barre.width, barre.height);
			cacheBarre.graphics.endFill();
			addChild(cacheBarre);
			cacheBarre.x = PG.EPAISSEUR_BORD_CHRONO / 2;
			positionnerCacheBarre();
			barre.mask=cacheBarre;
			
			}

		private function positionnerCacheBarre() : void {
			cacheBarre.y = barre. y + barre.height - cacheBarre.height;
			
			
		}

		private function dessinerFond() : void {
			graphics.clear();
			graphics.lineStyle(PG.EPAISSEUR_BORD_CHRONO, CharteCouleurs.BLANC);
			graphics.beginFill(CharteCouleurs.BLANC);
			graphics.drawRect(0, 0, PG.RAYON_BOUTONS_OUTILS, hauteur);
			graphics.endFill();
		}

		public function afficherTemps(temps : int) : void {
			this.temps = temps;
			cacheBarre.scaleY = temps/tempsDepart;
			positionnerCacheBarre();
		}

		public function reprendre() : void {
			timer.start();
		}

		public function suspendre() : void {
			timer.stop();
		}
	}
}
