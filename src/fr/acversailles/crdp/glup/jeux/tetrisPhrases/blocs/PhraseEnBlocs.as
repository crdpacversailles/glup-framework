package fr.acversailles.crdp.glup.jeux.tetrisPhrases.blocs {
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import fl.transitions.easing.Bounce;

	import fr.acversailles.crdp.glup.framework.controle.SynchronisationEvent;
	import fr.acversailles.crdp.glup.framework.parametres.PG;

	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * @author joachim
	 */
	public class PhraseEnBlocs extends Sprite {
		private static const VITESSE_CHUTE : Number = 0.05;
		private static const PROBA_ESPACEMENT : Number = 0;
		private static const NB_MAX_CLIGNOTEMENTS : int = 10;
		public static const INITIAL : uint = 0;
		public static const VALIDE : uint = 1;
		public static const ERREUR : uint = 2;
		private static const NB_FRAMES_CROISSANCE : Number = 8;
		private  var vitesseCroissance : uint;
		private var largeur : uint;
		private var curseur : Number;
		private var ligneCourante : int;
		private var blocs : Vector.<Bloc> ;
		private var _yObjectif : Number;
		private var tween : Tween;
		private var compteurClignotements : int;
		private var _etat : uint;
		private var blocEnCoursDeCroissance : Bloc;
		private var _enPause : Boolean;
		private var _disparitionEnCours : Boolean;

		public function PhraseEnBlocs(largeur : uint) {
			this.largeur = largeur;
			curseur = 0;
			ligneCourante = 0;
			_yObjectif = 0;
			blocs = new Vector.<Bloc>();
			_etat = INITIAL;
			creerTween();
			cacheAsBitmap = true;
		}

		private function creerTween() : void {
			tween = new Tween(this, "y", Bounce.easeOut, 0, 0, 1);
			tween.addEventListener(TweenEvent.MOTION_FINISH, calerPosition);
			tween.addEventListener(TweenEvent.MOTION_FINISH, gererArrivee);
			tween.stop();
		}

		private function gererArrivee(event : TweenEvent) : void {
			tween.removeEventListener(TweenEvent.MOTION_FINISH, gererArrivee);
			dispatchEvent(new SynchronisationEvent(TetrisSynchronisationEvent.ARRIVEE_PHRASE));
		}

		private function calerPosition(event : TweenEvent) : void {
			y = _yObjectif;
		}

		public function ajouterBloc(bloc : Bloc, espacementMax : Number) : void {
			var espacement : int = Math.random() * espacementMax;
			if (Math.random() < PROBA_ESPACEMENT || blocs.length == 0) curseur += espacement;
			if (curseur + bloc.width > largeur) {
				curseur = espacement;
				ligneCourante++;
			}
			bloc.x = curseur;
			bloc.y = ligneCourante * bloc.height;
			bloc.numeroLigne = ligneCourante;
			addChild(bloc);
			blocs.push(bloc);
			curseur += bloc.width ;
		}

		public function get yObjectif() : Number {
			return _yObjectif;
		}

		public function get enDeplacement() : Boolean {
			return tween.isPlaying;
		}

		public function set yObjectif(yObjectif : Number) : void {
			if (etat == PhraseEnBlocs.ERREUR) return;
			_yObjectif = yObjectif;
			tween.begin = y;
			tween.finish = _yObjectif;
			tween.duration = 1 + Math.abs(yObjectif - y) * VITESSE_CHUTE / PG.HAUTEUR_SCENE * PG.HAUTEUR_MODELE;
			tween.start();
		}

		public function testConnexite() : Boolean {
			var couverture : Vector.<Bloc> = new Vector.<Bloc>();
			var couverturePrecedente : Vector.<Bloc> = new Vector.<Bloc>();
			couverture.push(blocs[0]);
			do {
				couverturePrecedente = recopier(couverture);
				for each (var blocTeste : Bloc in couverture) {
					for each (var bloc : Bloc in blocs) {
						if (contiguite(blocTeste, bloc) && couverture.indexOf(bloc) == -1)
							couverture.push(bloc);
					}
				}
			} while (couverture.length < blocs.length && couverture.length != couverturePrecedente.length);
			return couverture.length == blocs.length;
		}

		private function contiguite(bloc1 : Bloc, bloc2 : Bloc) : Boolean {
			var contigu : Boolean = false;
			contigu ||= bloc2.getBounds(bloc2.parent).right >= bloc1.x - 1 && bloc2.y == bloc1.y;
			contigu ||= bloc2.x <= bloc1.getBounds(bloc1.parent).right + 1 && bloc2.y == bloc1.y;

			return false;
		}

		private function recopier(couverture : Vector.<Bloc>) : Vector.<Bloc> {
			var copieCouverture : Vector.<Bloc> = new Vector.<Bloc>;
			for each (var bloc : Bloc in couverture) {
				copieCouverture.push(bloc);
			}
			return copieCouverture;
		}

		public function declencherDisparition() : void {
			compteurClignotements = 0;
			_disparitionEnCours = true;
			addEventListener(Event.ENTER_FRAME, toggleCouleurFond);
		}

		private function toggleCouleurFond(event : Event) : void {
			compteurClignotements++;
			if (compteurClignotements == NB_MAX_CLIGNOTEMENTS) signalerDisparition();
			else colorierBlocs(compteurClignotements % 2 == 1);
		}

		private function signalerDisparition() : void {
			dispatchEvent(new SynchronisationEvent(TetrisSynchronisationEvent.DISPARITION_PHRASE));
		}

		private function colorierBlocs(boolean : Boolean) : void {
			for each (var bloc : Bloc in blocs) {
				bloc.dessinerFond(boolean);
			}
		}

		public function get etat() : uint {
			actualiserEtat();
			return _etat;
		}

		private function actualiserEtat() : void {
			if (blocs.some(errone)) _etat = ERREUR;
			else if (blocs.some(blocSpecialNonSelectionne)) _etat = INITIAL;
			else _etat = VALIDE;
		}

		private function errone(bloc : Bloc, i : int, v : Vector.<Bloc>) : Boolean {
			return bloc.etat == PhraseEnBlocs.ERREUR;
			i;
			v;
		}

		private function blocSpecialNonSelectionne(bloc : Bloc, i : int, v : Vector.<Bloc>) : Boolean {
			return bloc.etat == PhraseEnBlocs.INITIAL && bloc.special;
			i;
			v;
		}

		public function gererChoixErrone(bloc : Bloc) : void {
			mettreTousBlocsEnErreur();
			agrandirProgressivementBloc(bloc);
		}

		private function mettreTousBlocsEnErreur() : void {
			for each (var bloc : Bloc in blocs) {
				bloc.etat = PhraseEnBlocs.ERREUR;
			}
		}

		private function agrandirProgressivementBloc(bloc : Bloc) : void {
			blocEnCoursDeCroissance = bloc;
			vitesseCroissance = Math.max(1, placeRestantSurLigne() / NB_FRAMES_CROISSANCE);
			addEventListener(Event.ENTER_FRAME, agrandirSiPossible);
		}

		private function agrandirSiPossible(event : Event) : void {
			if (placeRestantSurLigne() > 0) {
				blocEnCoursDeCroissance.agrandir(Math.min(vitesseCroissance, placeRestantSurLigne()));
				repercuterChangement();
				recadrer();
			} else arreterAgrandirProgressivement();
		}

		private function recadrer() : void {
			while (debordementLigne())
				deplacerLigneVersLaGauche();
		}

		private function deplacerLigneVersLaGauche() : void {
			blocs.forEach(deplacerBlocVersLaGauche);
		}

		private function deplacerBlocVersLaGauche(bloc : Bloc, i : int, v : Vector.<Bloc>) : void {
			if (bloc.numeroLigne == blocEnCoursDeCroissance.numeroLigne) bloc.x--;
			i;
			v;
		}

		private function debordementLigne() : Boolean {
			return blocs.some(debordeDeLaligne);
		}

		private function debordeDeLaligne(bloc : Bloc, i : int, v : Vector.<Bloc>) : Boolean {
			return bloc.numeroLigne == blocEnCoursDeCroissance.numeroLigne && bloc.getBounds(this).right > PG.largeurDispoJeu();
			i;
			v;
		}

		private function repercuterChangement() : void {
			for (var i : int = blocs.indexOf(blocEnCoursDeCroissance); i < blocs.length - 1; i++) {
				if (blocs[i + 1].numeroLigne != blocEnCoursDeCroissance.numeroLigne) break;
				while (blocs[i + 1].x < blocs[i].getBounds(this).right)
					blocs[i + 1].x++;
			}
		}

		private function arreterAgrandirProgressivement() : void {
			removeEventListener(Event.ENTER_FRAME, agrandirSiPossible);
			blocEnCoursDeCroissance = null;
		}

		private function placeRestantSurLigne() : Number {
			var largeur : Number = 0;
			for each (var bloc : Bloc in blocs) {
				if (bloc.numeroLigne == blocEnCoursDeCroissance.numeroLigne) largeur += bloc.width;
			}
			return PG.largeurDispoJeu() - largeur;
		}

		public function pause() : void {
			tween.stop();
			_enPause = true;
		}

		public function get enPause() : Boolean {
			return _enPause;
		}

		public function play() : void {
			tween.resume();
			_enPause = false;
		}

		public function get disparitionEnCours() : Boolean {
			return _disparitionEnCours;
		}
	}
}
