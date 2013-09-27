package fr.acversailles.crdp.glup.jeux.popMots {
	import fr.acversailles.crdp.glup.framework.donnees.IContenu;
	import fr.acversailles.crdp.glup.framework.donnees.IOptions;
	import fr.acversailles.crdp.glup.framework.jeu.AbstractJeu;
	import fr.acversailles.crdp.glup.framework.parametres.PG;
	import fr.acversailles.crdp.glup.framework.son.DiffusionSons;
	import fr.acversailles.crdp.glup.framework.son.LibrairieSons;
	import fr.acversailles.crdp.glup.jeux.popMots.ballons.BallonAvecTexte;
	import fr.acversailles.crdp.glup.jeux.popMots.ballons.BallonEvent;
	import fr.acversailles.crdp.glup.jeux.popMots.controleur.Controleur;
	import fr.acversailles.crdp.glup.jeux.popMots.modele.Modele;
	import fr.acversailles.crdp.glup.jeux.popMots.modele.PopMotsModeleEvent;
	import fr.acversailles.crdp.glup.jeux.popMots.skins.Emplacement;
	import fr.acversailles.crdp.utils.functions.tr;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	/**
	 * @author joachim
	 */
	public class PopMots extends AbstractJeu {
		private static const PARTIE_INOCCUPEE_HAUTE : Number = 0.45;
		private static const PARTIE_INOCCUPEE_BASSE : Number = 0.05;
		private static const PROFONDEUR : int = 300;
		private var modele : Modele;
		private var controleur : Controleur;
		private var emplacements : Vector.<Point>;
		private var initialise : Boolean;
		private var supportEmplacements : Sprite;
		private var supportBallons : Sprite;
		private var profondeurs : Vector.<Number>;

		public function PopMots(options : IOptions, contenu : IContenu) {
			super(options, contenu);
			modele = new Modele(options, contenu);
			controleur = new Controleur(modele, this, options);
			modele.addEventListener(PopMotsModeleEvent.BONNE_REPONSE, gererReponse);
			modele.addEventListener(PopMotsModeleEvent.MAUVAISE_REPONSE, gererReponse);
			initialise = false;
		}

		private function gererReponse(event : PopMotsModeleEvent) : void {
			var statutReponse : Boolean = event.type == PopMotsModeleEvent.BONNE_REPONSE;
			var numero : uint = event.numero;
			getBallon(numero).exploser(statutReponse);
			afficherScore(modele.getScore());
			if (statutReponse) {
				DiffusionSons.jouerSon(LibrairieSons.PLOP_1);
				if (options.decompte && modele.getNbEnoncesRestants() > 0)
					alerteFurtive(tr("ENCORE") + " " + (modele.getNbEnoncesRestants()));
			} else
				DiffusionSons.jouerSon(LibrairieSons.ERREUR_2);
		}

		private function configurationGraphique() : void {
			CalculateurDimensions.analyser(contenu.getEnonces(), new Point(PG.largeurDispoJeu() * 1.2, PG.hauteurDispoJeu() * (1 - PARTIE_INOCCUPEE_BASSE - PARTIE_INOCCUPEE_HAUTE) - PG.HAUTEUR_CONSIGNE));
			positionnerEmplacements();
			modele.renseignerNbEmplacements(emplacements.length);
		}

		private function positionnerEmplacements() : void {
			emplacements = new Vector.<Point>();
			profondeurs = new Vector.<Number>();
			var espaceV : Number = PG.hauteurDispoJeu() * (1 - PARTIE_INOCCUPEE_BASSE - PARTIE_INOCCUPEE_HAUTE) / CalculateurDimensions.configuration[0];
			var espaceH : Number = PG.largeurDispoJeu() / (CalculateurDimensions.configuration[1] + 1);
			var espaceZ : Number = PROFONDEUR / CalculateurDimensions.configuration[0];
			var posH : Number, posV : Number, posZ : Number;
			var nbPointsHoriz : uint;
			var emplacement : Emplacement;
			for (var i : int = 0; i <= CalculateurDimensions.configuration[0]; i++) {
				nbPointsHoriz = CalculateurDimensions.configuration[1] - i % 2;
				for (var j : int = 0; j <= nbPointsHoriz; j++) {
					if (i % 2 == 0) posH = espaceH / 2 + j * espaceH;
					else posH = espaceH * (j + 1);
					posV = espaceV * (i) + PG.hauteurDispoJeu() * (PARTIE_INOCCUPEE_HAUTE) ;
					posZ = PROFONDEUR - i * espaceZ;
					emplacement = new Emplacement();
					supportEmplacements.addChild(emplacement);
					emplacement.x = posH;
					emplacement.y = posV;
					emplacement.z = posZ;
					emplacement.scaleX = emplacement.scaleY = PG.coeffAire() / 2;

					emplacements.push(new Point(posH, posV));
					profondeurs.push(posZ);
				}
			}
		}

		override public function activer() : void {
			if (!initialise) {
				supportEmplacements = new Sprite();
				supportBallons = new Sprite();
				supportBallons.addEventListener(MouseEvent.CLICK, gererClicSupportBallon);
				supportJeu.addChild(supportEmplacements);
				supportJeu.addChild(supportBallons);
				configurationGraphique();
				initialise = true;
			}
			reinitialiser();
			controleur.activer();
			jouerMusique();
		}

		private function gererClicSupportBallon(event : MouseEvent) : void {
			if (!(event.target is BallonAvecTexte))
				return;
			var ballon : BallonAvecTexte = event.target as BallonAvecTexte;
			controleur.signalerClicBallon(ballon.numero);
		}

		public function ajouterBallon(numEnonce : uint, numEmplacement : uint) : void {
			var ball : BallonAvecTexte = PoolBallons.donnerBallon();
			ball.initialiserAvec(modele.getEnonceStr(numEnonce), numEnonce, numEmplacement);
			ball.z = profondeurs[numEmplacement];
			ball.x = emplacements[numEmplacement].x;
			ball.y = emplacements[numEmplacement].y;
			supportBallons.addChildAt(ball, determinerNumeroCalque(numEmplacement));
			ball.addEventListener(BallonEvent.CREVAISON, gererCrevaison);
			ball.addEventListener(BallonEvent.FIN_EXPLOSION_GAGNE, gererFinExplosion);
			ball.addEventListener(BallonEvent.FIN_DISPARITION, gererFinDisparition);
		}

		private function determinerNumeroCalque(numEmplacement : uint) : int {
			for (var i : int = 0; i < supportBallons.numChildren; i++) {
				var ball : BallonAvecTexte = (supportBallons.getChildAt(i) as BallonAvecTexte);
				if (ball.numeroEmplacement >= numEmplacement)
					return supportBallons.getChildIndex(ball);
			}
			return i;
		}

		private function gererCrevaison(event : BallonEvent) : void {
			var ball : BallonAvecTexte = (event.target as BallonAvecTexte);

			controleur.signalerClicBallon(ball.numero);
		}

		private function gererFinExplosion(event : BallonEvent) : void {
			var ball : BallonAvecTexte = (event.target as BallonAvecTexte);
			supportBallons.removeChild(ball);
			PoolBallons.rendre(ball);
			controleur.signalerDisparitionParExplosion(ball.numeroEmplacement);
		}

		private function gererFinDisparition(event : BallonEvent) : void {
			var ball : BallonAvecTexte = (event.target as BallonAvecTexte);
			supportBallons.removeChild(ball);
			PoolBallons.rendre(ball);
			controleur.signalerDisparitionSpontanee(ball.numero, ball.numeroEmplacement);
		}

		override public function desactiver() : void {
			controleur.desactiver();
			enleverBallons();
			DiffusionSons.arreterMusique();
		}

		override public function pause() : void {
			controleur.pause();
			DiffusionSons.arreterMusique();
		}

		override public function play() : void {
			controleur.play();
			jouerMusique();
		}

		override public function reinitialiser() : void {
			jouerMusique();
			enleverBallons();
			controleur.reinitialiser();

			afficherScore(modele.getScore());
			controleur.activer();
			demarrerChrono();
		}

		private function jouerMusique() : void {
			DiffusionSons.jouerMusique(LibrairieSons.MUSIQUE_1);
		}

		private function enleverBallons() : void {
			while (supportBallons.numChildren > 0) {
				var ball : BallonAvecTexte = (supportBallons.getChildAt(0) as BallonAvecTexte);
				supportBallons.removeChild(ball);
				PoolBallons.rendre(ball);
			}
		}

		override public function gererFinChrono() : void {
			controleur.gererDefaite();
		}

		public function faireDisparaitreBallon(numBallon : int) : void {
			getBallon(numBallon).amorcerDisparition();
		}

		private function getBallon(numBallon : int) : BallonAvecTexte {
			var objet : DisplayObject;
			for (var i : int = 0; i < supportBallons.numChildren; i++) {
				objet = supportBallons.getChildAt(i);
				if (!(objet is BallonAvecTexte))
					continue;
				if ((objet as BallonAvecTexte).numero == numBallon)
					return (objet as BallonAvecTexte);
			}
			return null;
		}
	}
}
