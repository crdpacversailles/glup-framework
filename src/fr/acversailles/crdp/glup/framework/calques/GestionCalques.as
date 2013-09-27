package fr.acversailles.crdp.glup.framework.calques {
	import fr.acversailles.crdp.glup.framework.Main;
	import fr.acversailles.crdp.glup.framework.graphismes.CharteCouleurs;
	import fr.acversailles.crdp.glup.framework.jeu.outils.LienCommande;
	import fr.acversailles.crdp.glup.framework.parametres.PG;
	import fr.acversailles.crdp.utils.avertirReferenceSceneNecessaire;
	import fr.acversailles.crdp.utils.functions.centrer;

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;

	/**
	 * @author joachim
	 */
	public class GestionCalques {
		public static const FINI_AVEC_SCORE : String = "FINI_AVEC_SCORE";
		public static const DEFAITE_AVEC_SCORE : String = "DEFAITE_AVEC_SCORE";
		public static const VICTOIRE_AVEC_SCORE : String = "VICTOIRE_AVEC_SCORE";
		public static const DEFAITE_SANS_SCORE : String = "DEFAITE_SANS_SCORE";
		public static const VICTOIRE_SANS_SCORE : String = "VICTOIRE_SANS_SCORE";
		public static const PAUSE : String = "PAUSE";
		private static var _support : Main;
		private static var supportCalque : Sprite;
		private static var calqueCourant : ICalque;
		

		public static function afficherCalque(cle : String, textesSupplementaires : Vector.<String> = null, calque : ICalque = null) : void {
			if (!_support) avertirReferenceSceneNecessaire();
			_support.activerInterface(false);
			if (!calque) calque = determinerCalque(cle, textesSupplementaires);
			calqueCourant=calque;
			GestionCalques._support.addChild(supportCalque);
			supportCalque.addChild(calque.sprite);
			dessinerFond();
			centrer(supportCalque, PG.largeurDispoJeu(), PG.hauteurDispoJeu());
			supportCalque.x += PG.MARGE_GAUCHE + PG.LARGEUR_OUTILS;
			supportCalque.y += PG.MARGE_HAUTE + PG.HAUTEUR_CONSIGNE;
		}

		private static function dessinerFond() : void {
			supportCalque.graphics.clear();
			supportCalque.graphics.beginFill(CharteCouleurs.FOND_FAIBLE);
			supportCalque.graphics.lineStyle(0, CharteCouleurs.TEXTE_1, 0, true);
			var largeurFondCalque : Number = supportCalque.width + 2 * PG.MARGES_LATERALES_CALQUE;
			var hauteurFondCalque : Number=supportCalque.height + PG.MARGE_INF_CALQUE + PG.MARGE_SUP_CALQUE;
			supportCalque.graphics.drawRoundRect(0, 0, largeurFondCalque, hauteurFondCalque, PG.ARRONDI_BORDS_CALQUES);
			supportCalque.graphics.endFill();
			supportCalque.graphics.beginFill(CharteCouleurs.BLANC);
			supportCalque.graphics.lineStyle(0, CharteCouleurs.TEXTE_1, 0, true);
			supportCalque.graphics.drawRoundRect(PG.EPAISSEUR_BORD_CALQUE, PG.EPAISSEUR_BORD_CALQUE, largeurFondCalque - 2 * PG.EPAISSEUR_BORD_CALQUE, calqueCourant.getHauteurTitre(), PG.ARRONDI_BORDS_CALQUES);
			supportCalque.graphics.endFill();
			supportCalque.graphics.beginFill(CharteCouleurs.BLANC);
			supportCalque.graphics.drawRoundRect( PG.MARGE_GAUCHE_BAS_CALQUE, PG.EPAISSEUR_BORD_CALQUE,largeurFondCalque - PG.EPAISSEUR_BORD_CALQUE - PG.MARGE_GAUCHE_BAS_CALQUE, hauteurFondCalque-2*PG.EPAISSEUR_BORD_CALQUE, PG.ARRONDI_BORDS_CALQUES);
			supportCalque.graphics.endFill();
		}

		private static function determinerCalque(cle : String, textesSupplementaires : Vector.<String>) : ICalque {
			var calque : ICalque;
			switch(cle) {
				case DEFAITE_AVEC_SCORE:
					calque = new CalqueDefaiteAvecScore(textesSupplementaires);
					break;
				case FINI_AVEC_SCORE:
					calque = new CalqueFiniAvecScore(textesSupplementaires);
					break;
				case DEFAITE_SANS_SCORE:
					calque = new CalqueDefaiteSansScore();
					break;
				case VICTOIRE_AVEC_SCORE:
					calque = new CalqueVictoireAvecScore(textesSupplementaires);
					break;
				case VICTOIRE_SANS_SCORE:
					calque = new CalqueVictoireSansScore();
					break;
				case PAUSE:
					calque = new CalquePause(textesSupplementaires);
					break;
			}
			return calque;
		}

		public static function initialiser(support : Main) : void {
			_support = support;
			creerSupportCalques();
		}

		private static function creerSupportCalques() : void {
			supportCalque = new Sprite();
			activerMouseDown(true);
			supportCalque.buttonMode = true;
			supportCalque.filters = [new DropShadowFilter(2)];
		}

		private static function activerMouseDown(boolean : Boolean) : void {
			if (boolean) supportCalque.addEventListener(MouseEvent.MOUSE_DOWN, gererMouseDown);
			else supportCalque.removeEventListener(MouseEvent.MOUSE_DOWN, gererMouseDown);
		}

		private static function gererMouseDown(event : MouseEvent) : void {
			if (event.target is LienCommande) return;
			supportCalque.startDrag();
			activerMouseUp(true);
		}

		private static function activerMouseUp(boolean : Boolean) : void {
			if (boolean) _support.addEventListener(MouseEvent.MOUSE_UP, gererMouseUp, false, 0, true);
			else _support.removeEventListener(MouseEvent.MOUSE_UP, gererMouseDown);
		}

		private static function gererMouseUp(event : MouseEvent) : void {
			supportCalque.stopDrag();
			activerMouseUp(false);
			activerMouseDown(true);
		}

		public static function masquerCalque() : void {
			if (!_support || !supportCalque) avertirReferenceSceneNecessaire();
			while (supportCalque.numChildren > 0) supportCalque.removeChildAt(0);
			if (_support.contains(supportCalque))
				_support.removeChild(supportCalque);
			_support.activerInterface(true);
		}
	}
}
