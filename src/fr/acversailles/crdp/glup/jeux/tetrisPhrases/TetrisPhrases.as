package fr.acversailles.crdp.glup.jeux.tetrisPhrases {
	import fr.acversailles.crdp.glup.framework.donnees.IContenu;
	import fr.acversailles.crdp.glup.framework.donnees.IOptions;
	import fr.acversailles.crdp.glup.framework.jeu.AbstractJeu;
	import fr.acversailles.crdp.glup.jeux.tetrisPhrases.blocs.PhraseEnBlocs;
	import fr.acversailles.crdp.glup.jeux.tetrisPhrases.controleur.Controleur;
	import fr.acversailles.crdp.glup.jeux.tetrisPhrases.controleur.GestionPhrases;
	import fr.acversailles.crdp.glup.jeux.tetrisPhrases.modele.Modele;

	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @author joachim
	 */
	public class TetrisPhrases extends AbstractJeu {
		private var modele : Modele;
		private var controleur : Controleur;
		private var _saisiesBloquees : Boolean;

		public function TetrisPhrases(options : IOptions, contenu : IContenu) {
			super(options, contenu);
		}

		override public function activer() : void {
			modele = new Modele(contenu, options);
			controleur = new Controleur(modele, this, options);
			controleur.nouveauJeu();
			addEventListener(Event.ENTER_FRAME, verifierPositions);
			addEventListener(MouseEvent.MOUSE_DOWN, gererMouseDown);
		}

		override public function desactiver() : void {
			GestionPhrases.nettoyer();
			controleur.pause();
		}

		private function gererMouseDown(event : MouseEvent) : void {
			if (_saisiesBloquees) return;
			controleur.gerer(event);
		}

		private function verifierPositions(event : Event) : void {
			GestionPhrases.miseAJour();
		}

		public function envoyerPhrase(phrase : PhraseEnBlocs) : Boolean {
			phrase.y = -phrase.height;
			supportJeu.addChild(phrase);
			return GestionPhrases.ajouter(phrase);
		}

		override public function pause() : void {
			GestionPhrases.pause();
			controleur.pause();
		}

		override public function play() : void {
			GestionPhrases.play();
			controleur.play();
		}

		override public function reinitialiser() : void {
			GestionPhrases.nettoyer();
			controleur.nouveauJeu();
		}

		public function aucunePossibilite() : Boolean {
			return GestionPhrases.toutesPhrasesBloquees();
		}

		public function actualiserScore() : void {
			afficherScore(modele.score);
		}

		public function bloquerSaisies(bool : Boolean) : void {
			_saisiesBloquees = bool;
		}

	}
}
