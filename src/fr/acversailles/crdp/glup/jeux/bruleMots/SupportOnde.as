package fr.acversailles.crdp.glup.jeux.bruleMots {
	import fr.acversailles.crdp.glup.framework.parametres.PG;
	import fr.acversailles.crdp.glup.framework.graphismes.CharteCouleurs;

	import flash.events.Event;
	import flash.geom.Point;
	import flash.display.Shape;

	/**
	 * @author joachim
	 */
	public class SupportOnde extends Shape {
		private static const PAS : int = 75;
		private var milieu : Point;
		private var rayon : int;
		private var rayonMax : Number;

		public function SupportOnde() {
			rayonMax = Math.sqrt(PG.hauteurDispoJeu() * PG.hauteurDispoJeu() + PG.largeurDispoJeu() * PG.largeurDispoJeu()) * 4;
		}

		public function declencherEffet(milieu : Point) : void {
			this.milieu = milieu;
			rayon = 0;
			addEventListener(Event.ENTER_FRAME, agrandirCercle);
		}

		private function agrandirCercle(event : Event) : void {
			rayon += PAS;
			graphics.clear();
			graphics.lineStyle(10, CharteCouleurs.TEXTE_CLAIR, 0.3);
			graphics.drawCircle(milieu.x, milieu.y, rayon * 4 / 5);
			graphics.drawCircle(milieu.x, milieu.y, rayon * 3 / 4);
			graphics.drawCircle(milieu.x, milieu.y, rayon);
			if (rayon > rayonMax) arreterEffet();
		}

		private function arreterEffet() : void {
			graphics.clear();
			removeEventListener(Event.ENTER_FRAME, agrandirCercle);
		}
	}
}
