package fr.acversailles.crdp.glup.jeux.tetrisPhrases.blocs {
	import fr.acversailles.crdp.glup.framework.graphismes.CharteCouleurs;
	import fr.acversailles.crdp.glup.framework.graphismes.FormatsTexte;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	/**
	 * @author joachim
	 */
	public class Bloc extends Sprite {
		private static const COULEUR_SPECIALE : uint = CharteCouleurs.FOND_GENERAL;
		private static const EPAISSEUR_FAIBLE : int = 0;
		private static const EPAISSEUR_FORTE : int = 3;
		private static const NB_CLIGNOTEMENTS : int = 10;
		private var texte : String;
		private var _special : Boolean;
		private var zoneTexte : TextField;
		private var couleurBloc : uint;
		private var couleurEncre : uint;
		private var couleurBord : uint;
		private var _phrase : PhraseEnBlocs;
		private var epaisseurTrait : Number;
		private var _etat : uint;
		private var couleurEncreOrigine : uint;
		private var couleurBlocOrigine : uint;
		private var _numeroLigne : uint;
		private var compteurClignotements : int;
		private var _neutralise : Boolean;

		public function Bloc(texte : String, special : Boolean, couleurBloc : uint, couleurEncre : uint, phrase : PhraseEnBlocs, neutralise : Boolean) {
			_neutralise = neutralise;
			_phrase = phrase;
			this.couleurEncre = this.couleurEncreOrigine = couleurEncre;
			this.couleurBord = CharteCouleurs.FAUX;
			this.couleurBloc = this.couleurBlocOrigine = couleurBloc;
			_special = special;
			this.texte = texte;
			epaisseurTrait = EPAISSEUR_FAIBLE;
			creerZoneTexte();
			dessinerFond();
			if (!neutralise)
				ecouter();
			buttonMode = !neutralise;
		}

		private function ecouter() : void {
			addEventListener(MouseEvent.MOUSE_OVER, gererSurvol);
			addEventListener(MouseEvent.MOUSE_OUT, gererSurvol);
		}

		private function gererSurvol(event : MouseEvent) : void {
			if (_etat != PhraseEnBlocs.INITIAL) epaisseurTrait = EPAISSEUR_FAIBLE;
			else epaisseurTrait = event.type == MouseEvent.MOUSE_OVER ? EPAISSEUR_FORTE : EPAISSEUR_FAIBLE;
			dessinerFond();
		}

		internal function dessinerFond(couleurSpeciale : Boolean = false) : void {
			graphics.clear();
			if (neutralise) {
				graphics.beginFill(CharteCouleurs.VRAI);
			}
			else if (_etat == PhraseEnBlocs.ERREUR) {
				graphics.beginFill(CharteCouleurs.INERTE);
			} else
				graphics.beginFill(couleurSpeciale ? COULEUR_SPECIALE : couleurBloc);
			graphics.lineStyle(epaisseurTrait, couleurBord, _etat == PhraseEnBlocs.ERREUR ? 0 : 1);
			graphics.drawRect(epaisseurTrait*0.5, epaisseurTrait*0.5, zoneTexte.width-epaisseurTrait, zoneTexte.height-epaisseurTrait);
			graphics.endFill();

		}

		private function creerZoneTexte() : void {
			zoneTexte = new TextField();
			zoneTexte.mouseEnabled = false;
			zoneTexte.multiline = false;
			zoneTexte.wordWrap = false;
			zoneTexte.embedFonts = true;
			zoneTexte.selectable = false;
			var formatTexte : TextFormat = FormatsTexte.donnerFormat(FormatsTexte.ITEM_DANS_JEU);
			zoneTexte.defaultTextFormat = formatTexte;
			actualiserCouleurTexte();
			zoneTexte.text = texte +(_neutralise?"=":"");
			zoneTexte.autoSize = TextFieldAutoSize.LEFT;
			addChild(zoneTexte);
			actualiserCouleurTexte();
		}

		private function actualiserCouleurTexte() : void {
			var format : TextFormat = zoneTexte.getTextFormat();
			format.color = couleurEncre;
			if (_etat == PhraseEnBlocs.ERREUR) format.bold = true;
			zoneTexte.setTextFormat(format);
		}

		public function get special() : Boolean {
			return _special;
		}

		public function get phrase() : PhraseEnBlocs {
			return _phrase;
		}

		public function get etat() : uint {
			return _etat;
		}

		public function set etat(etat : uint) : void {
			_etat = etat;
			switch(_etat) {
				case PhraseEnBlocs.VALIDE:
					couleurBloc = CharteCouleurs.VRAI;
					couleurEncre = CharteCouleurs.TEXTE_GENERAL;
					buttonMode = false;
					epaisseurTrait = EPAISSEUR_FAIBLE;
					clignoter();
					break;
				case PhraseEnBlocs.ERREUR:
					couleurBord = couleurBloc = CharteCouleurs.TEXTE_INERTE;
					couleurEncre = CharteCouleurs.TEXTE_INERTE;
					buttonMode = false;
					epaisseurTrait = EPAISSEUR_FAIBLE;
					break;
			}
			actualiserCouleurTexte();
			dessinerFond();
		}

		private function clignoter() : void {
			compteurClignotements = 0;
			addEventListener(Event.ENTER_FRAME, toggleClignotement);
		}

		private function toggleClignotement(event : Event) : void {
			compteurClignotements++;
			dessinerFond(compteurClignotements % 2 == 1);
			if (compteurClignotements == NB_CLIGNOTEMENTS)
				removeEventListener(Event.ENTER_FRAME, toggleClignotement);
		}

		public function agrandir(nbPoints : uint) : void {
			zoneTexte.autoSize = TextFieldAutoSize.NONE;
			zoneTexte.width += nbPoints;
			dessinerFond();
		}

		public function set numeroLigne(numeroLigne : uint) : void {
			_numeroLigne = numeroLigne;
		}

		public function get numeroLigne() : uint {
			return _numeroLigne;
		}

		public function get neutralise() : Boolean {
			return _neutralise;
		}
	}
}
