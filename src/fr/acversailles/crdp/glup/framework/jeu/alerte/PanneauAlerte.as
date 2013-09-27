package fr.acversailles.crdp.glup.framework.jeu.alerte {
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import fl.transitions.easing.Regular;

	import fr.acversailles.crdp.glup.framework.graphismes.CharteCouleurs;
	import fr.acversailles.crdp.glup.framework.graphismes.FormatsTexte;
	import fr.acversailles.crdp.glup.framework.parametres.PG;

	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.filters.BlurFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Timer;

	/**
	 * @author joachim
	 */
	public class PanneauAlerte extends Sprite {
		private var zoneTexte : TextField;
		private var tweenApparition : Tween;
		private var fond : Shape;
		private var delaiDisparition : Timer;

		public function PanneauAlerte() {
			creerZoneTexte();
			creerFond();
			creerTweenApparition();
			visible=false;
			mouseEnabled=false;
		}

		private function creerFond() : void {
			fond=new Shape();
			fond.filters=[new  BlurFilter(PG.PADDING_V_ZONE_TITRE*4, PG.PADDING_V_ZONE_TITRE*4, 1)];
			addChildAt(fond,0);
		}

		private function creerTweenApparition() : void {
			tweenApparition = new Tween(this, "alpha", Regular.easeOut, 0, 1, 12);
			tweenApparition.stop();
			tweenApparition.addEventListener(TweenEvent.MOTION_FINISH, armerTimerDisparition);
			delaiDisparition = new Timer(500, 1);
			delaiDisparition.addEventListener(TimerEvent.TIMER_COMPLETE, disparaitre);
		}

		private function armerTimerDisparition(event : TweenEvent) : void {
			delaiDisparition.start();
		}

		private function disparaitre(event : TimerEvent) : void {
			tweenApparition.begin=alpha;
			tweenApparition.finish=0;
			tweenApparition.start();
		}

		private function creerZoneTexte() : void {
			zoneTexte = new TextField();
			zoneTexte.mouseEnabled = false;
			zoneTexte.multiline = false;
			zoneTexte.wordWrap = false;
			zoneTexte.embedFonts = true;
			zoneTexte.selectable = false;
			var formatTexte : TextFormat = FormatsTexte.donnerFormat(FormatsTexte.TEXTE_CALQUE);
			zoneTexte.defaultTextFormat = formatTexte;
			zoneTexte.autoSize = TextFieldAutoSize.LEFT;
			addChild(zoneTexte);
			zoneTexte.y = PG.PADDING_V_ZONE_TITRE;
			zoneTexte.x = PG.PADDING_H_ZONE_TITRE;
		}

		private function dessiner() : void {
			fond.graphics.clear();
			fond.graphics.beginFill(CharteCouleurs.FOND_FAIBLE);
			fond.graphics.lineStyle(0, 0, 0);
			fond.graphics.drawRoundRect(0, 0, zoneTexte.width + 2 * PG.PADDING_V_ZONE_TITRE, zoneTexte.height + 2 * PG.PADDING_V_ZONE_TITRE, PG.ARRONDI_BORDS_ALERTE);
			fond.graphics.endFill();
		}

		public function afficherAlerte(texte : String):void {
			visible = true;
			delaiDisparition.stop();
			zoneTexte.text = texte;
			dessiner();
			x = parent.mouseX ;
			y = parent.mouseY-height;
			tweenApparition.begin=alpha;
			tweenApparition.finish=1;
			tweenApparition.start();
		}
	}
}
