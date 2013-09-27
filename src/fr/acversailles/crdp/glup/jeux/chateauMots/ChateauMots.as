package fr.acversailles.crdp.glup.jeux.chateauMots {
	import fr.acversailles.crdp.glup.framework.donnees.IContenu;
	import fr.acversailles.crdp.glup.framework.donnees.IOptions;
	import fr.acversailles.crdp.glup.framework.jeu.AbstractJeu;
	import fr.acversailles.crdp.glup.framework.parametres.PG;
	import fr.acversailles.crdp.glup.jeux.chateauMots.charette.Charette;
	import fr.acversailles.crdp.glup.jeux.chateauMots.charette.CharetteEvent;
	import fr.acversailles.crdp.glup.jeux.chateauMots.controleur.Controleur;
	import fr.acversailles.crdp.glup.jeux.chateauMots.loadSprite.LoadMage;
	import fr.acversailles.crdp.glup.jeux.chateauMots.modele.Modele;
	import fr.acversailles.crdp.glup.jeux.chateauMots.modele.ModeleEvent;
	import fr.acversailles.crdp.glup.jeux.chateauMots.tir.Projectile;
	import fr.acversailles.crdp.glup.jeux.chateaumot.skins.Chateau;
	import fr.acversailles.crdp.glup.jeux.chateaumot.skins.FondChateau;

	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class ChateauMots extends AbstractJeu {
		private const AJOUT : uint = 0;
		private const RETRAIT : uint = 1;
		private var supportClique : Sprite;
		private var modele : Modele;
		private var controleur : Controleur;
		private var posMage : Point;
		private var centre : Point;
		private var charettes : Vector.<Charette>;
		private var projectiles : Number = 1;
		private var pointappa : Point;

		public function ChateauMots(options : IOptions, contenu : IContenu) {
			super(options, contenu);
			modele = new Modele(options, contenu);
			controleur = new Controleur(modele, this, options);
			modele.addEventListener(ModeleEvent.SCORE_CHANGE, gererScore);
		}

		private function graphismeStatique() : void {
			var fondchateau : Sprite = new FondChateau();
			var chateau : Sprite = new Chateau();
			var mage : Bitmap = new LoadMage();

			supportClique = new Sprite;
			supportClique.graphics.beginFill(0xFFFFFF, 0);
			supportClique.graphics.drawRect(0, PG.HAUTEUR_CONSIGNE + PG.MARGE_HAUTE, PG.largeurDispoJeu(), PG.hauteurDispoJeu());
			supportClique.graphics.endFill();

			fondchateau.y = 60;
			fondchateau.x = 0;

			chateau.y = (PG.hauteurDispoJeu() / 2);
			chateau.x = chateau.x - 20;
			chateau.scaleX = chateau.scaleX * 0.40;
			chateau.scaleY = chateau.scaleY * 0.40;

			posMage = new Point(PG.largeurDispoJeu() * 0.20, 60 + (PG.hauteurDispoJeu() / 2));
			centre = Point.interpolate(mage.getBounds(mage).bottomRight, mage.getBounds(mage).topLeft, 0.5);
			mage.x = posMage.x - centre.x;
			mage.y = (posMage.y) - centre.y;
			fondchateau.addChild(chateau);
			fondchateau.addChild(mage);
			supportClique.addChild(fondchateau);
		}

		override public function activer() : void {
			graphismeStatique();
			charettes = new Vector.<Charette>();
			supportClique.addEventListener(MouseEvent.CLICK, gererClique);
			supportJeu.addChild(supportClique);
			// modele.init();
			controleur.activer();
		}

		public function gererClique(me : MouseEvent) : void {
			var cible : Point = new Point(me.localX, me.localY);
			conversionCoordonnees(me.target as DisplayObject, cible, supportClique);
			controleur.gererClique(posMage, cible);
		}

		public function gererScore(event : ModeleEvent) : void {
			trace(modele.score);
		}

		private function conversionCoordonnees(target : DisplayObject, cible : Point, supportClique : Sprite) : void {
			while (target != supportClique && target.parent) {
				cible.offset(target.x, target.y);
				target = target.parent;
			}
		}

		public function ajoutCharette() : void {
			var charette : Charette = PoolCharette.donnerCharette();
			pointApparitionCharette(charette);
			charette.initP(modele.donnerEnonce(modele.nombreEnoncer), modele.nombreEnoncer, pointappa);
			modele.ChangeNbCharetteAffiches(AJOUT);
			charettes.push(charette);
			charette.addEventListener(CharetteEvent.CHARETTE_EXPLOSION, gererExplosionCharette);
			charette.addEventListener(CharetteEvent.CHARETTE_DISPARITION, gererDisparitionCharette);
			ajoutSprite(charette);
		}

		public function pointApparitionCharette(charette : Charette) : void {
			pointappa = new Point(0, 0);
			pointappa.x = PG.largeurDispoJeu();
			pointappa.y = ((Math.random() * ((PG.hauteurDispoJeu() - charette.height) - (PG.hauteurDispoJeu() * 0.1))) + PG.hauteurDispoJeu() * 0.1);
			if (collisionCharette(charette)) {
				charette.stopCharette();
				dispatchEvent(new CharetteEvent(CharetteEvent.CHARETTE_DISPARITION));
				ajoutCharette();
			}
		}

		public function gererExplosionCharette(event : CharetteEvent) : void {
			var charette : Charette = (event.target as Charette);
			charettes.shift();
			modele.ChangeNbCharetteAffiches(RETRAIT);
			modele.retirerVisible(charette.num);
			charette.alpha = 0;
			PoolCharette.rendre(charette);
		}

		public function gererDisparitionCharette(event : CharetteEvent) : void {
			var charette : Charette = (event.target as Charette);
			charettes.shift();
			modele.ChangeNbCharetteAffiches(RETRAIT);
			modele.retirerVisible(charette.num);
			charette.alpha = 0;
			PoolCharette.rendre(charette);
		}

		public function collision(proj : Projectile) : void {
			var i : Number = 0;
			for (i = 0; i < charettes.length; i++) {
				if (modele.getvisible(charettes[i].num) == 1) {
					if (charettes[i].hitTestObject(proj)) {
						trace(modele.donnerEnonce(charettes[i].num));
						impacte(charettes[i]);
						proj.resetProjectile();
						break;
					}
				}
			}
		}

		public function collisionCharette(char : Charette) : Boolean {
			var i : Number = 0;
			for (i = 0; i < charettes.length; i++) {
				if (modele.getvisible(charettes[i].num) == 1) {
					if (char.hitTestObject(charettes[i])) {
						return true;
						break;
					}
				}
			}
			return false;
		}

		public function retirerProj() : void {
			projectiles--;
		}

		public function impacte(charette : Charette) : void {
			charette.stopCharette();
			charette.exploCharette();
		}

		public function creeProjectile(origine : Point, cible : Point) : void {
			
			if (projectiles < 4) {
				CalculeTrajectoire.trajectoire(origine, cible);
				new Projectile(this, CalculeTrajectoire.savoirRebond, origine, CalculeTrajectoire.posRebond, CalculeTrajectoire.posImpacte);
				projectiles++;
			} else {
				alerteFurtive("Out of mana !");
			}
		}

		public function ajoutSprite(object : Sprite) : void {
			supportClique.addChild(object);
		}

		public function removeSprite(object : Sprite) : void {
			supportClique.removeChild(object);
		}

		override public function play() : void {
			controleur.play();
		}

		override public function pause() : void {
			controleur.pause();
		}

		override public function reinitialiser() : void {
			controleur.reinitialiser();
		}
	}
}
