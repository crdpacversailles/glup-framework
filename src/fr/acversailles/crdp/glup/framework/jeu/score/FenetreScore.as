package fr.acversailles.crdp.glup.framework.jeu.score {
	import fr.acversailles.crdp.glup.framework.graphismes.FormatsTexte;
	import fr.acversailles.crdp.glup.framework.icones.FondBoutonNormal;
	import fr.acversailles.crdp.glup.framework.parametres.PG;
	import fr.acversailles.crdp.utils.functions.centrer;

	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Timer;

	/**
	 * @author joachim
	 */
	public class FenetreScore extends Sprite {
		private static const NB_CLIGNOTEMENTS : uint = 3;
		private var zoneTexte : TextField;
		private var nbDigits : uint;
		private var score : int;
		private var timerClignotement : Timer;
		private var fondNormal : FondBoutonNormal;

		public function FenetreScore(nbDigits : uint) {
			this.nbDigits = nbDigits;
			dessinerFond();
			creerZoneTexte();			
			creerTimerClignotement();
		}

		private function creerTimerClignotement() : void {
			timerClignotement = new Timer(150, NB_CLIGNOTEMENTS * 2);
			timerClignotement.addEventListener(TimerEvent.TIMER, toggleCouleurFond);
		}

		private function toggleCouleurFond(event : TimerEvent) : void {
			fondNormal.visible=timerClignotement.currentCount % 2 == 0;
		}

		private function creerZoneTexte() : void {
			zoneTexte = new TextField();
			zoneTexte.mouseEnabled = false;
			zoneTexte.multiline = false;
			zoneTexte.wordWrap = false;
			zoneTexte.embedFonts = true;
			zoneTexte.selectable = false;
			zoneTexte.width = 2 * PG.RAYON_BOUTONS_OUTILS;
			var formatTexte : TextFormat = FormatsTexte.donnerFormat(FormatsTexte.SCORE);
			zoneTexte.defaultTextFormat = formatTexte;
			zoneTexte.text = normaliser(0);
			zoneTexte.autoSize = TextFieldAutoSize.LEFT;
			while (zoneTexte.textWidth > PG.RAYON_BOUTONS_OUTILS * 2)
				reduirePolice();
			addChild(zoneTexte);
			centrer(zoneTexte, PG.RAYON_BOUTONS_OUTILS * 2, PG.RAYON_BOUTONS_OUTILS * 2);
		}

		private function reduirePolice() : void {
			var format : TextFormat = zoneTexte.getTextFormat();
			format.size = Number(format.size) - 1;
			zoneTexte.setTextFormat(format);
		}

		private function dessinerFond() : void {
			fondNormal = new FondBoutonNormal();
			fondNormal.width = fondNormal.height = 2 * PG.RAYON_BOUTONS_OUTILS;
			addChild(fondNormal);
		}

		private function normaliser(nombre : int) : String {
			var nombreStr : String = Math.abs(nombre).toString();
			var nbDigitsModifie : uint = nbDigits ;
			if (nombre < 0) nbDigitsModifie--;

			while (nombreStr.length < nbDigitsModifie) nombreStr = "0" + nombreStr;
			if (nombre < 0) nombreStr = "-" + nombreStr;
			return nombreStr;
		}

		public function afficherScore(score : int) : void {
			if (this.score != score) clignoter();
			this.score = score;
			zoneTexte.text = normaliser(score);
		}

		private function clignoter() : void {
			timerClignotement.reset();
			timerClignotement.start();
		}
	}
}
