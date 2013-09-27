package fr.acversailles.crdp.glup.framework.communs.accueil {
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import fl.transitions.easing.Strong;

	import fr.acversailles.crdp.glup.framework.controle.ControleurGeneral;
	import fr.acversailles.crdp.glup.framework.graphismes.CharteCouleurs;
	import fr.acversailles.crdp.glup.framework.graphismes.FormatsTexte;
	import fr.acversailles.crdp.glup.framework.icones.IconeAvancer;
	import fr.acversailles.crdp.glup.framework.icones.IconeFermer;
	import fr.acversailles.crdp.glup.framework.icones.IconeReculer;
	import fr.acversailles.crdp.glup.framework.jeu.outils.BoutonOutil;
	import fr.acversailles.crdp.glup.framework.parametres.PG;
	import fr.acversailles.crdp.utils.functions.nettoyerChaineXML;

	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	/**
	 * @author joachim
	 */
	public class AffichageAide extends Sprite {
		private static const SELECTION_SYMBOLES : String = "CDEFGHIJKLMNOPQRSTUX";
		private static const DUREE_APPARITION : uint = 16;
		private var aides : Vector.<Vector.<TextField>>;
		private var hauteurDispo : Number;
		private var largeurDispo : Number;
		private var curseurY : int;
		private var boutonAvancer : BoutonOutil;
		private var boutonReculer : BoutonOutil;
		private var boutonFermer : BoutonOutil;
		private var numeroPage : int;
		private var zonePage : TextField;
		private var tweenApparition : Tween;
		private var positionY : Number;
		private var masque : Shape;

		public function AffichageAide(contenu : Vector.<String>, largeurDispo : Number, hauteurDispo : Number) {
			this.largeurDispo = largeurDispo;
			this.hauteurDispo = hauteurDispo;
			aides = new Vector.<Vector.<TextField>>();
			aides.push(new Vector.<TextField>());
			curseurY = PG.PADDING_AIDE + PG.ESPACE_SUP_AIDE;
			for each (var paragraphe : String in contenu) {
				creerParagraphe(nettoyerChaineXML(paragraphe));
			}

			dessinerFond();
			mettreBoutons();
			mettreZonePage();
			numeroPage = 0;
			actualiserAffichagePages();
			creerTweenApparition();
		}

		private function creerTweenApparition() : void {
			tweenApparition = new Tween(this, "y", Strong.easeOut, 0, 1, DUREE_APPARITION);
			tweenApparition.stop();
		}

		private function mettreZonePage() : void {
			zonePage = new TextField();
			zonePage.mouseEnabled = false;
			zonePage.multiline = false;
			zonePage.wordWrap = false;
			zonePage.embedFonts = true;
			zonePage.selectable = false;
			var formatTexte : TextFormat = FormatsTexte.donnerFormat(FormatsTexte.NUMERO_PAGE_AIDE);
			zonePage.defaultTextFormat = formatTexte;
			zonePage.text = "0 / 0";
			zonePage.autoSize = TextFieldAutoSize.LEFT;
			addChild(zonePage);
			zonePage.y = PG.PADDING_AIDE;
			zonePage.x = boutonAvancer.x - PG.MARGE_ENTRE_BOUTONS_AIDE - zonePage.width;
			// on le place après
			boutonReculer.x = zonePage.x - PG.MARGE_ENTRE_BOUTONS_AIDE - boutonReculer.width;
		}

		private function mettreBoutons() : void {
			boutonFermer = new BoutonOutil(ControleurGeneral.FERMER_AIDE, new IconeFermer(), null, 0);
			boutonAvancer = new BoutonOutil(ControleurGeneral.SUITE_AIDE, new IconeAvancer(), null, 0);
			boutonReculer = new BoutonOutil(ControleurGeneral.PRECEDENT_AIDE, new IconeReculer(), null, 0);
			addChild(boutonFermer);
			addChild(boutonAvancer);
			addChild(boutonReculer);
			boutonAvancer.y = boutonFermer.y = boutonReculer.y = PG.PADDING_AIDE;
			boutonFermer.x = largeurDispo - PG.PADDING_AIDE - boutonFermer.width;
			boutonAvancer.x = boutonFermer.x - PG.MARGE_ENTRE_BOUTONS_AIDE - boutonAvancer.width;

			addEventListener(MouseEvent.CLICK, gererClic);
		}

		private function gererClic(event : MouseEvent) : void {
			if (event.target == boutonAvancer && numeroPage < aides.length - 1)
				numeroPage++;
			else if (event.target == boutonReculer && numeroPage > 0)
				numeroPage--;
			else return;
			actualiserAffichagePages();
		}

		private function actualiserAffichagePages() : void {
			for (var i : int = 0; i < aides.length; i++) {
				for each (var aide : TextField in aides[i]) {
					aide.visible = i == numeroPage;
				}
			}
			miseAJourBoutons();
			mizeAJourZonePages();
		}

		private function mizeAJourZonePages() : void {
			zonePage.text = (numeroPage + 1) + " / " + (aides.length);
		}

		private function miseAJourBoutons() : void {
			numeroPage > 0 ? boutonReculer.activer() : boutonReculer.desactiver();
			numeroPage < aides.length - 1 ? boutonAvancer.activer() : boutonAvancer.desactiver();
		}

		private function dessinerFond() : void {
			graphics.clear();
			graphics.beginFill(CharteCouleurs.ACCENTUATION);
			graphics.lineStyle(PG.EPAISSEUR_BORD_AIDE, CharteCouleurs.TEXTE_1, 1, true);
			graphics.drawRoundRectComplex(0, 0, largeurDispo, hauteurDispo,0, 0, PG.ARRONDI_BORDS_AIDE, PG.ARRONDI_BORDS_AIDE);
			graphics.endFill();
			graphics.lineStyle(PG.EPAISSEUR_BORD_AIDE, CharteCouleurs.ACCENTUATION, 1, true);
			graphics.moveTo(0, 0);
			graphics.lineTo(largeurDispo, 0);
			
			filters=[new DropShadowFilter()];
		}

		private function creerParagraphe(paragrapheStr : String) : void {
			var nouvelleZone : TextField = creerZoneTexte(paragrapheStr);

			if (curseurY + nouvelleZone.height + PG.MARGE_V_ENTRE_PARAGRAPHES_AIDE + 2 * PG.PADDING_AIDE > hauteurDispo) {
				curseurY = PG.PADDING_AIDE + PG.ESPACE_SUP_AIDE;
				aides.push(new Vector.<TextField>());
			}
			nouvelleZone.y = curseurY;
			nouvelleZone.x = PG.PADDING_AIDE;
			curseurY += nouvelleZone.height + PG.MARGE_V_ENTRE_PARAGRAPHES_AIDE;
			aides[aides.length - 1].push(nouvelleZone);
		}

		private function creerZoneTexte(texte : String) : TextField {
			var zoneTexte : TextField = new TextField();
			zoneTexte.mouseEnabled = false;
			zoneTexte.multiline = true;
			zoneTexte.wordWrap = true;
			zoneTexte.embedFonts = true;
			zoneTexte.selectable = false;
			var formatTexte : TextFormat = FormatsTexte.donnerFormat(FormatsTexte.TEXTE_AIDE);
			zoneTexte.defaultTextFormat = formatTexte;
			var caractereAuHasard : String = SELECTION_SYMBOLES.charAt(uint(Math.random() * SELECTION_SYMBOLES.length));
			zoneTexte.text = caractereAuHasard + " " + texte;
			zoneTexte.setTextFormat(FormatsTexte.donnerFormat(FormatsTexte.SYMBOLE_TEXTE_AIDE), 0, 1);
			zoneTexte.autoSize = TextFieldAutoSize.LEFT;
			zoneTexte.width = PG.largeurDispoJeu() - 2 * PG.MARGES_LATERALES_CONSIGNE_ACCUEIL - 2 * PG.PADDING_AIDE;
			addChild(zoneTexte);
			return zoneTexte;
		}

		public function afficher(boolean : Boolean) : void {
			visible = true;
			numeroPage = 0;
			actualiserAffichagePages();
			tweenApparition.begin = boolean ? positionY - hauteurDispo : positionY;
			tweenApparition.finish = boolean ? positionY : positionY - hauteurDispo;
			tweenApparition.start();
			if(!boolean)
				tweenApparition.addEventListener(TweenEvent.MOTION_FINISH, masquer);
		}

		private function masquer(event : TweenEvent) : void {
			tweenApparition.removeEventListener(TweenEvent.MOTION_FINISH, masquer);
			visible=false;
		}

		public function enregistrerY() : void {
			positionY = y;
			mettreMasque();
		}

		private function mettreMasque() : void {
			masque = new Shape();
			masque.graphics.beginFill(0x000000);
			masque.graphics.drawRect(0, 0, largeurDispo, hauteurDispo);
			masque.graphics.endFill();
			masque.x = x;
			masque.y = y;
			parent.addChild(masque);
			mask = masque;
		}
	}
}
