package fr.acversailles.crdp.glup.framework.jeu {
	import fr.acversailles.crdp.glup.framework.communs.AbstractPanneau;
	import fr.acversailles.crdp.glup.framework.controle.SynchronisationEvent;
	import fr.acversailles.crdp.glup.framework.donnees.IContenu;
	import fr.acversailles.crdp.glup.framework.donnees.IOptions;
	import fr.acversailles.crdp.glup.framework.graphismes.CharteCouleurs;
	import fr.acversailles.crdp.glup.framework.icones.FondJeu;
	import fr.acversailles.crdp.glup.framework.jeu.alerte.PanneauAlerte;
	import fr.acversailles.crdp.glup.framework.jeu.consigne.ZoneConsignes;
	import fr.acversailles.crdp.glup.framework.parametres.PG;
	import fr.acversailles.crdp.glup.framework.son.DiffusionSons;
	import fr.acversailles.crdp.utils.avertirClasseAbstraite;
	import fr.acversailles.crdp.utils.functions.centrer;

	import flash.display.GradientType;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;

	/**
	 * @author joachim
	 */
	public class AbstractJeu extends AbstractPanneau implements IJeu {
		/**
		 * Support positionné pour placer les différents éléments du jeu. Ce support 
		 */
		protected var supportJeu : Sprite;
		private var cacheSupport : Sprite;
		private var zoneConsignes : ZoneConsignes;
		private var alerte : PanneauAlerte;
		private var iconeFond : Sprite;

		/**
		 * Classe abstraite implémentant les propriétés communes à tous les jeux
		 * @param options Les options du jeu, objet qui encapsule le fichier xml d'option
		 * @param contenu Le contenu du jeu, objet qui encapsule le fichier xml de contenu
		 */
		public function AbstractJeu(options : IOptions, contenu : IContenu) {
			super(options, contenu);
			addEventListener(Event.ADDED_TO_STAGE, construire);
			DiffusionSons.autorisationMusique = options.musique;
		}

		override protected function determinerCouleurFond() : void {
			couleurFond = CharteCouleurs.FOND_GENERAL;
		}

		private function construire(event : Event) : void {
			mettreSupport();
			mettreZoneConsigne();
			ajouterIcone();
			mettreCacheSupport();
			// mettreCacheConsigne();
			mettreAlerte();
		}

		private function ajouterIcone() : void {
			iconeFond = new FondJeu();
			var coeff : Number = Math.min(PG.largeurDispoJeu() / iconeFond.width, PG.hauteurDispoJeu() / iconeFond.height);
			coeff *= PG.PROPORTION_ICONE_FOND_JEU;
			iconeFond.scaleX = iconeFond.scaleY = coeff;
			addChildAt(iconeFond, 0);
			centrer(iconeFond, PG.largeurDispoJeu(), PG.hauteurDispoJeu() - PG.HAUTEUR_CONSIGNE);
			iconeFond.x += PG.MARGE_GAUCHE + PG.LARGEUR_OUTILS;
			iconeFond.y += zoneConsignes.getBounds(this).bottom;
			iconeFond.alpha = 0.5;
		}

		private function mettreAlerte() : void {
			alerte = new PanneauAlerte();
			addChild(alerte);
		}

		private function mettreZoneConsigne() : void {
			zoneConsignes = new ZoneConsignes(contenu.getConsigne());
			addChild(zoneConsignes);
			zoneConsignes.x = 0;
			zoneConsignes.y = 0;
		}

		private function mettreCacheSupport() : void {
			cacheSupport = new Sprite();
			addChild(cacheSupport);
			cacheSupport.x = PG.MARGE_GAUCHE + PG.LARGEUR_OUTILS + PG.EPAISSEUR_BORD;
			cacheSupport.y = PG.MARGE_HAUTE + PG.EPAISSEUR_BORD;
			cacheSupport.graphics.beginFill(0x000000);
			cacheSupport.graphics.drawRoundRect(0, 0, PG.largeurDispoJeu(), PG.hauteurDispoJeu() + 1, PG.ARRONDI_BORDS_CADRE);
			cacheSupport.graphics.endFill();
			supportJeu.mask = cacheSupport;
		}

		private function mettreSupport() : void {
			supportJeu = new Sprite();
			addChild(supportJeu);
			supportJeu.x = PG.MARGE_GAUCHE + PG.LARGEUR_OUTILS + PG.EPAISSEUR_BORD;
			supportJeu.y = PG.MARGE_HAUTE_SUPPORT_JEU + PG.EPAISSEUR_BORD;
		}

		override protected function dessiner() : void {
			var fillType : String = GradientType.LINEAR;
			var colors : Array = [0xFFC314, 0xFFDF46, 0xFFB700];
			var alphas : Array = [1, 1, 1];
			var ratios : Array = [0, 80, 255];
			var matr : Matrix = new Matrix();
			var largeur : Number = PG.LARGEUR_SCENE - PG.MARGE_DROITE - (PG.MARGE_GAUCHE + PG.LARGEUR_OUTILS);
			var hauteur : Number = PG.HAUTEUR_SCENE - PG.MARGE_INF - PG.MARGE_HAUTE - PG.HAUTEUR_CONSIGNE;
			var tx : Number = PG.MARGE_GAUCHE + PG.LARGEUR_OUTILS;
			var ty : Number = PG.MARGE_HAUTE + PG.HAUTEUR_CONSIGNE;
			matr.createGradientBox(largeur, hauteur, Math.PI / 2, tx, ty);
			var spreadMethod : String = SpreadMethod.PAD;
			graphics.beginGradientFill(fillType, colors, alphas, ratios, matr, spreadMethod);
			graphics.lineStyle(0, 0, 0);
			graphics.drawRect(tx, ty, largeur, hauteur);
			graphics.endFill();
		}

		/**
		 * Fonction abstraite appelée automatiquement lorsque le joueur relance le jeu après une pause
		 * A implémenter obligatoirement dans les jeux concrets
		 */
		public function play() : void {
			avertirClasseAbstraite();
		}

		/**
		 * Fonction abstraite appelée automatiquement lorsque le joueur appuie sur le bouton pause
		 * A implémenter obligatoirement dans les jeux concrets
		 */
		public function pause() : void {
			avertirClasseAbstraite();
		}

		/**
		 * Fonction abstraite appelée automatiquement lorsque le joueur appuie sur le bouton réinitialiser
		 * A implémenter obligatoirement dans les jeux concrets
		 */
		public function reinitialiser() : void {
			avertirClasseAbstraite();
		}

		/**
		 * Fonction abstraite appelée automatiquement lorsque le chrono se termine
		 * A implémenter si besoin dans les jeux concrets
		 */
		public function gererFinChrono() : void {
			// on n'est pas obligé d'en faire qqc
		}
		/**
		 * Bloque l'interface : le jeu et la barre d'outils ne reçoivent plus d'évènements de souris
		 * A appeler au gré des besoins dans les jeux concrets : la fonction n'est pas appelée automatiquement
		 */
		public function demanderBloquage() : void {
			dispatchEvent(new SynchronisationEvent(SynchronisationEvent.DEMANDE_BLOCAGE));
		}

		protected function afficherScore(score : int) : void {
			dispatchEvent(new SynchronisationEvent(SynchronisationEvent.AFFICHAGE_SCORE, score));
		}

		public function get nomJeu() : String {
			return contenu.getNomJeu();
		}

		/**
		 * Lance le compte à rebours. 
		 * A appeler au gré des besoins dans les jeux concrets : la fonction n'est pas appelée automatiquement
		 */
		public function demarrerChrono() : void {
			dispatchEvent(new SynchronisationEvent(SynchronisationEvent.DEMARRAGE_CHRONO));
		}

		/**
		 * Suspend le compte à rebours. 
		 * A appeler au gré des besoins dans les jeux concrets : la fonction n'est pas appelée automatiquement
		 */
		public function suspendreChrono() : void {
			dispatchEvent(new SynchronisationEvent(SynchronisationEvent.SUSPENSION_CHRONO));
		}

		/**
		 * Reprend le compte à rebours. 
		 * A appeler au gré des besoins dans les jeux concrets : la fonction n'est pas appelée automatiquement
		 */
		public function reprendreChrono() : void {
			dispatchEvent(new SynchronisationEvent(SynchronisationEvent.REPRISE_CHRONO));
		}

		/**
		 * Arrête le compte à rebours. 
		 * A appeler au gré des besoins dans les jeux concrets : la fonction n'est pas appelée automatiquement
		 */
		public function arreterchrono() : void {
			dispatchEvent(new SynchronisationEvent(SynchronisationEvent.ARRET_CHRONO));
		}

		/**
		 * Lance un message dans une bulle qui disparaît au clic 
		 * A appeler au gré des besoins dans les jeux concrets : la fonction n'est pas appelée automatiquement
		 * @param message La chaîne à afficher dans la bulle
		 */
		public function alerteFurtive(message : String) : void {
			setChildIndex(alerte, numChildren - 1);
			alerte.afficherAlerte(message);
		}
	}
}
