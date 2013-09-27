package fr.acversailles.crdp.glup.jeux.tetrisPhrases.controleur {
	import fr.acversailles.crdp.glup.framework.calques.GestionCalques;
	import fr.acversailles.crdp.glup.framework.donnees.IOptions;
	import fr.acversailles.crdp.glup.framework.parametres.PG;
	import fr.acversailles.crdp.glup.framework.son.DiffusionSons;
	import fr.acversailles.crdp.glup.framework.son.LibrairieSons;
	import fr.acversailles.crdp.glup.jeux.tetrisPhrases.TetrisPhrases;
	import fr.acversailles.crdp.glup.jeux.tetrisPhrases.blocs.Bloc;
	import fr.acversailles.crdp.glup.jeux.tetrisPhrases.blocs.CreateurBlocs;
	import fr.acversailles.crdp.glup.jeux.tetrisPhrases.blocs.PhraseEnBlocs;
	import fr.acversailles.crdp.glup.jeux.tetrisPhrases.modele.Modele;

	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/**
	 * @author joachim
	 */
	public class Controleur {
		private static const DELAI_MINIMUM : uint = 1000;
		private var modele : Modele;
		private var jeu : TetrisPhrases;
		private var timerPhrases : Timer;
		private var timerVictoire : Timer;
		private var options : IOptions;
		private var delaiMin : uint;
		private var delaiMax : uint;
		private var _enPause : Boolean;
		private var neutraliserPremier : Boolean;

		public function Controleur(modele : Modele, jeu : TetrisPhrases, options : IOptions) {
			this.options = options;
			this.jeu = jeu;
			this.modele = modele;
			delaiMin = parseInt(options.parametresSpecifiques("intervalle_min"))*1000;
			delaiMax = parseInt(options.parametresSpecifiques("intervalle_max"))*1000;
			neutraliserPremier = options.parametresSpecifiques("neutraliser_premier")!=null && options.parametresSpecifiques("neutraliser_premier")=="oui";
			creerTimers();
		}

		private function creerTimers() : void {
			timerPhrases = new Timer(1, 1);
			timerVictoire = new Timer(500, 1);
			timerPhrases.addEventListener(TimerEvent.TIMER, envoyerPhrase);
			timerVictoire.addEventListener(TimerEvent.TIMER, victoire);
		}

		private function victoire(event : TimerEvent) : void {
			jeu.demanderBloquage();
			DiffusionSons.jouerSon(modele.score == modele.nbPointsTotal ? LibrairieSons.GAGNE_2 : LibrairieSons.GAGNE_1);
			timerPhrases.stop();
			GestionCalques.afficherCalque(GestionCalques.VICTOIRE_AVEC_SCORE, Vector.<String>([scoreStr()]));
		}

		private function envoyerPhrase(event : TimerEvent) : void {
			var placeSuffisante : Boolean = jeu.envoyerPhrase(CreateurBlocs.creerPhraseEnBlocs(modele.getPhraseSuivante(), parseInt(options.parametresSpecifiques("espacement_max_mots")), PG.largeurDispoJeu(), neutraliserPremier));
			if (placeSuffisante) {
				DiffusionSons.jouerSon(LibrairieSons.CHUTE);
				if (modele.resteDesPhrases()) {
					delaiAleatoire();
					rearmerMecanisme();
				}
			} else {
				gererDefaite();
			}
		}

		private function delaiAleatoire() : void {
			timerPhrases.delay = delaiMin + uint(Math.random() * (delaiMax - delaiMin));
		}

		public function nouveauJeu() : void {
			// on force la pause
			_enPause = false;
			modele.score = 0;
			modele.nouveauJeu();
			rearmerMecanisme(true);
			jeu.actualiserScore();
			jeu.bloquerSaisies(false);
		}

		private function rearmerMecanisme(sansDelai : Boolean = false) : void {
			timerPhrases.reset();
			if (sansDelai) timerPhrases.delay = DELAI_MINIMUM;
			timerPhrases.start();
		}

		public function gerer(event : MouseEvent) : void {
			if (_enPause) return;
			if (event.type == MouseEvent.MOUSE_DOWN) {
				if (event.target is Bloc)
					gererChoixBloc(event.target as Bloc);
			}
		}

		private function gererChoixBloc(bloc : Bloc) : void {
			if (bloc.phrase.etat == PhraseEnBlocs.ERREUR) return;
			if (bloc.neutralise) return;
			if (bloc.special) gererChoixCorrect(bloc);
			else gererChoixIncorrect(bloc);
			if (jeu.aucunePossibilite() && ! modele.resteDesPhrases())
				{
					timerVictoire.start();
				}
		}

		private function gererChoixIncorrect(bloc : Bloc) : void {
			DiffusionSons.jouerSon(LibrairieSons.ERREUR_1);
			bloc.etat = PhraseEnBlocs.ERREUR;
			bloc.phrase.gererChoixErrone(bloc);
		}

		private function gererChoixCorrect(bloc : Bloc) : void {
			// on ne peut pas le cliquer plusieurs fois
			if (bloc.etat == PhraseEnBlocs.VALIDE) return;
				bloc.etat = PhraseEnBlocs.VALIDE;
			
			
			if (bloc.phrase.etat == PhraseEnBlocs.VALIDE) {
				bloc.phrase.declencherDisparition();
				modele.score++;
				jeu.actualiserScore();
				DiffusionSons.jouerSon(LibrairieSons.BONNE_REPONSE_1);
			} else {
				DiffusionSons.jouerSon(LibrairieSons.PLOP_1);
			}
		}

		public function pause() : void {
			_enPause = true;
			timerPhrases.stop();
		}

		public function play() : void {
			_enPause = false;
			timerPhrases.start();
		}

		public function signalerArriveePhrase(phrase : PhraseEnBlocs) : void {
			if (phrase.y < 0) gererDefaite();
		}

		private function gererDefaite() : void {
			jeu.bloquerSaisies(true);
			jeu.demanderBloquage();
			DiffusionSons.jouerSon(LibrairieSons.PERDU_1);
			timerPhrases.stop();
			GestionCalques.afficherCalque(GestionCalques.DEFAITE_AVEC_SCORE, Vector.<String>([scoreStr()]));
		}

		private function scoreStr() : String {
			return modele.score + " / " + modele.nbPointsTotal;
		}
	}
}
