package fr.acversailles.crdp.glup.jeux.popMots.ballons {
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import fl.transitions.easing.Regular;
	import fl.transitions.easing.Strong;

	import fr.acversailles.crdp.glup.jeux.popMots.CalculateurDimensions;
	import fr.acversailles.crdp.glup.jeux.popMots.skins.DessinBallon;
	import fr.acversailles.crdp.glup.jeux.popMots.skins.ExplosionGagne;
	import fr.acversailles.crdp.glup.jeux.popMots.skins.ExplosionPerd;
	import fr.acversailles.crdp.utils.functions.assert;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.ColorTransform;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	/**
	 * @author Joachim
	 */
	public class BallonAvecTexte extends Sprite {
		private static const PADDING : Number = 1.2;
		private static const COULEURS : Array = ["0xee0000", "0x379ad3", "0xfa6f12", "0x828a97", "0x8aaf45", "0xdee652", "0xf3cb2e", "0x00790c", "0xa337ff"];
		private var zoneTexte : TextField;
		private var _numero : uint;
		private var _numeroEmplacement : uint;
		private var couleur : Number;
		private var dessin : DessinBallon;
		private var apparitionX : Tween;
		private var apparitionY : Tween;
		private var disparitionX : Tween;
		private var disparitionY : Tween;
		private var explosionGagne : ExplosionGagne;
		private var explosionPerd : ExplosionPerd;
		private static var pointeurCouleurs : int;
		private var largeurOriginale : Number;
		private var hauteurOriginale : Number;
		private var xOriginal : Number;
		private var yOriginal : Number;

		public function BallonAvecTexte() {
			buttonMode = true;
			mouseChildren = false;
			dessin = new DessinBallon();
			xOriginal = dessin.x;
			yOriginal = dessin.y;
			largeurOriginale = dessin.width;
			hauteurOriginale = dessin.height;
			creerZoneTexte();
			afficherContenu(true);
			creerExplosions();
		}

		private function afficherContenu(boolean : Boolean) : void {
			if (boolean) {
				if (!contains(dessin))
					addChild(dessin);
				if (!contains(zoneTexte))
					addChild(zoneTexte);
			} else {
				assert(contains(dessin), "Retrait du dessin qui n'est pas là");
				assert(contains(zoneTexte), "Retrait de la zone texte qui n'est pas là");
				removeChild(zoneTexte);
				removeChild(dessin);
			}
		}

		private function creerExplosions() : void {
			explosionGagne = new ExplosionGagne();
			explosionGagne.stop();
			explosionGagne
				.addEventListener(Event.ENTER_FRAME, ecouterExplosion);
			explosionPerd = new ExplosionPerd();
			explosionPerd.stop();
			explosionPerd
				.addEventListener(Event.ENTER_FRAME, ecouterExplosion);
		}

		private function ecouterExplosion(event : Event) : void {
			var explosion : MovieClip = (event.target as MovieClip);
			if (explosion.currentLabel == "fin_explosion") {
				removeChild(explosion);
				explosion.gotoAndStop("debut_explosion");
				signalerFinExplosion();
			}
		}

		private function creerZoneTexte() : void {
			zoneTexte = new TextField();
			zoneTexte.multiline = true;
			zoneTexte.embedFonts = true;
			zoneTexte.wordWrap = true;
			zoneTexte.defaultTextFormat = CalculateurDimensions.formatTexteOptimise;
			zoneTexte.autoSize = TextFieldAutoSize.LEFT;
		}

		public function exploser(gagne : Boolean) : void {
			if (disparitionX) {
				disparitionX.stop();
				disparitionX.removeEventListener(TweenEvent.MOTION_FINISH, signalerDisparitionSpontanee);
			}
			if (disparitionY) disparitionY.stop();
			var explosion : MovieClip = gagne ? explosionGagne : explosionPerd;
			addChild(explosion);
			explosion.x = dessin.getBounds(this).left + dessin.width / 2;
			explosion.y = dessin.getBounds(this).top + dessin.height / 2;
			afficherContenu(false);
			explosion.gotoAndPlay("debut_explosion");
		}

		public function initialiserAvec(texte : String, numeroBallon : uint, numeroEmplacement : uint) : void {
			afficherContenu(true);
			_numeroEmplacement = numeroEmplacement;
			_numero = numeroBallon;
			zoneTexte.text = texte;
			zoneTexte.width = CalculateurDimensions.dimensionMax.x + 4;
			zoneTexte.height = CalculateurDimensions.dimensionMax.y + 4;

			var coefH : Number = zoneTexte.width / (dessin.width);
			var coefV : Number = zoneTexte.height / (dessin.height);
			dessin.height *= Math.max(coefH, coefV) * PADDING;
			dessin.width *= Math.max(coefH, coefV) * PADDING;
			zoneTexte.x = -zoneTexte.width / 2;
			zoneTexte.y = dessin.x - dessin.height + (dessin.height * 0.9 - zoneTexte.textHeight) / 2;
			pointeurCouleurs = (pointeurCouleurs + 1) % COULEURS.length;
			couleur = COULEURS[pointeurCouleurs];

			colorierFond();

			deployer();
		}

		private function deployer() : void {
			scaleZ = 1;
			creerOuReinitialiserTweensApparition();
		}

		private function replier() : void {
			creerOuReinitialiserTweensDisparition();
			disparitionX.addEventListener(TweenEvent.MOTION_FINISH, signalerDisparitionSpontanee);
		}

		private function creerOuReinitialiserTweensApparition() : void {
			if (apparitionX) {
				apparitionX.stop();
				apparitionX.position = 0;
				apparitionX.start();
			} else
				apparitionX = new Tween(this, "scaleX", Regular.easeOut, 0, 1, 8);
			if (apparitionY) {
				apparitionY.stop();
				apparitionY.position = 0;
				apparitionY.start();
			} else
				apparitionY = new Tween(this, "scaleY", Regular.easeOut, 0, 1, 8);
		}

		private function creerOuReinitialiserTweensDisparition() : void {
			if (disparitionX) {
				disparitionX.stop();
				disparitionX.position = 1;
				disparitionX.start();
			} else
				disparitionX = new Tween(this, "scaleX", Strong.easeOut, 1, 0, 12);
			if (disparitionY) {
				disparitionY.stop();
				disparitionY.position = 1;
				disparitionY.start();
			} else
				disparitionY = new Tween(this, "scaleY", Strong.easeOut, 1, 0, 12);
		}


		private function signalerDisparitionSpontanee(event : TweenEvent) : void {
			if (contains(explosionGagne))
				return;
			disparitionX.removeEventListener(TweenEvent.MOTION_FINISH, signalerDisparitionSpontanee);
			dispatchEvent(new BallonEvent(BallonEvent.FIN_DISPARITION));
		}

		private function signalerFinExplosion() : void {
			dispatchEvent(new BallonEvent(BallonEvent.FIN_EXPLOSION_GAGNE));
		}

		private function colorierFond() : void {
			var ct : ColorTransform = dessin.fond.transform.colorTransform;
			ct.color = couleur;
			dessin.fond.transform.colorTransform = ct;
		}

		public function get numero() : uint {
			return _numero;
		}

		public function get numeroEmplacement() : uint {
			return _numeroEmplacement;
		}

		public function amorcerDisparition() : void {
			replier();
		}

		public function reinitialiser() : void {
			afficherContenu(true);
			scaleX = scaleY = scaleZ = 1;
			dessin.scaleX = dessin.scaleY = dessin.scaleZ = 1;
			dessin.x = xOriginal;
			dessin.y = yOriginal;
			dessin.height = hauteurOriginale;
			dessin.width = largeurOriginale;

			zoneTexte.scaleX = zoneTexte.scaleY = zoneTexte.scaleZ = 1;
			if (disparitionX) {
				disparitionX.stop();
			}
			if (disparitionY) {
				disparitionY.stop();
			}
			if (apparitionX) {
				apparitionX.stop();
			}
			if (apparitionY) {
				apparitionY.stop();
			}
		}
	}
}
