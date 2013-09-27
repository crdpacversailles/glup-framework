package fr.acversailles.crdp.glup.jeux.bruleMots {
	import fr.acversailles.crdp.glup.framework.controle.SynchronisationEvent;
	import fr.acversailles.crdp.glup.framework.son.LibrairieSons;
	import fr.acversailles.crdp.glup.framework.son.DiffusionSons;

	import flash.events.TimerEvent;
	import flash.utils.Timer;

	import fr.acversailles.crdp.glup.framework.graphismes.CharteCouleurs;
	import fr.acversailles.crdp.glup.framework.graphismes.FormatsTexte;

	import flash.display.GradientType;
	import flash.display.InterpolationMethod;
	import flash.display.Shape;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.BlurFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	/**
	 * @author joachim
	 */
	public class BlocMot extends Sprite {
		private static const VITESSE_RAPIDE : uint = 4;
		private static const VITESSE_LENTE : uint = 1;
		private var texte : String;
		private var zoneTexte : TextField;
		private var _special : Boolean;
		private var supportFeu : Shape;
		private static var fillType : String = GradientType.LINEAR;
		private static var colors : Array = [0xfdff65, 0xf41e1e];
		private static var alphas : Array = [0.9, 0.8];
		private static var ratios : Array = [0x00, 0xFF];
		private static var matr : Matrix = new Matrix();
		private static var spreadMethod : String = SpreadMethod.PAD;
		private var compteur : Number = 0;
		private var positionY : Number;
		private var _enFeu : Boolean;
		private var _arretFeu : Boolean;
		private var timerFeu : Timer;
		private var positionX : Number;
		private var vitesseExtinction : Number;
		private var filtre : GlowFilter;
		private var _enPause : Boolean;
		private var dureeExtinction : int;

		public function BlocMot(texte : String, special : Boolean, dureeExtinction : int) {
			this.dureeExtinction = dureeExtinction;
			_special = special;
			this.texte = texte;
			creerZoneTexte();
			positionY = zoneTexte.textHeight - zoneTexte.getLineMetrics(0).descent;
			positionX = zoneTexte.width - zoneTexte.textWidth;
			matr = new Matrix();
			matr.createGradientBox(50, 50, Math.PI / 2, 10, 10);
			buttonMode = true;
			filtre = new GlowFilter();
		}

		private function creerZoneTexte() : void {
			zoneTexte = new TextField();
			zoneTexte.mouseEnabled = false;
			zoneTexte.multiline = true;
			zoneTexte.embedFonts = true;
			zoneTexte.selectable = false;
			var formatTexte : TextFormat = FormatsTexte.donnerFormat(FormatsTexte.ITEM_DANS_JEU);
			zoneTexte.defaultTextFormat = formatTexte;
			zoneTexte.autoSize = TextFieldAutoSize.LEFT;
			zoneTexte.text = texte;
			zoneTexte.width = zoneTexte.textWidth + 6;
			addChild(zoneTexte);
		}

		public function emphaser(boolean : Boolean) : void {
			if (_enFeu) return;
			colorer(boolean ? CharteCouleurs.ACCENTUATION : CharteCouleurs.TEXTE_GENERAL);
		}

		public function get special() : Boolean {
			return _special;
		}

		public function bruler(avecSon : Boolean = true) : void {
			if (avecSon)
				DiffusionSons.jouerSon(LibrairieSons.FEU_1);
			_enFeu = true;
			_arretFeu = false;
			filters = [filtre] ;
			colorer(0xfdff65);
			compteur = 0;

			if (!timerFeu) {
				timerFeu = new Timer(dureeExtinction, 1);
				timerFeu.addEventListener(TimerEvent.TIMER_COMPLETE, eteindre);
			} else timerFeu.reset();
			timerFeu.start();
			emphaser(false);
			if (!supportFeu) {
				supportFeu = new Shape();
				supportFeu.filters = [new GlowFilter(colors[0], 0.5), new BlurFilter()];
				addChildAt(supportFeu, 0);
			}
			addEventListener(Event.ENTER_FRAME, actualiserFeu);
		}

		private function colorer(couleur : uint) : void {
			var format : TextFormat = zoneTexte.getTextFormat();
			format.color = couleur;
			zoneTexte.setTextFormat(format);
		}

		internal function eteindre(event : TimerEvent = null) : void {
			_arretFeu = true;
			vitesseExtinction = event ? VITESSE_LENTE : VITESSE_RAPIDE;
			colorer(CharteCouleurs.TEXTE_GENERAL);
			dispatchEvent(new SynchronisationEvent(SynchronisationEvent.EXTINCTION));
			filters = [];
		}

		private function actualiserFeu(event : Event) : void {
			if (_enPause) return;
			supportFeu.graphics.clear();
			if (_arretFeu) compteur += vitesseExtinction;
			alphas = [0.9 - compteur / 50, 0.8 - compteur / 50];
			supportFeu.graphics.beginGradientFill(fillType, colors, alphas, ratios, matr, spreadMethod, InterpolationMethod.RGB);
			supportFeu.graphics.moveTo(zoneTexte.textWidth, positionY);
			supportFeu.graphics.lineTo(positionX, positionY);
			var coeff : Number;
			var periode : uint;
			coeff = Math.random() * 15 - compteur / 10 + 10 - compteur / 10;
			periode = Math.random() * 6 + 3;
			for (var i : int = 0; i < zoneTexte.textWidth - positionX; i += 2) {
				if (Math.sin(i / 10) + 1 <= 0.001) {
					coeff = Math.random() * 15 - compteur / 10 + 10 - compteur / 10;
					periode = Math.random() * 6 + 3;
				}
				supportFeu.graphics.lineTo(positionX + i, positionY - (Math.sin(i / periode - Math.PI / 2) + 1) * coeff - zoneTexte.textHeight / 3);
			}
			supportFeu.graphics.endFill();
			if (compteur >= 150) finExtinction();
		}

		private function finExtinction() : void {
			_enFeu = false;
			_arretFeu = false;
			colorer(CharteCouleurs.TEXTE_GENERAL);
			filters = [];
			removeEventListener(Event.ENTER_FRAME, actualiserFeu);
			supportFeu.graphics.clear();
		}

		public function get enFeu() : Boolean {
			return _enFeu;
		}

		public function figer(boolean : Boolean) : void {
			_enPause = boolean;
			boolean ? timerFeu.stop() : timerFeu.start();
		}
	}
}
