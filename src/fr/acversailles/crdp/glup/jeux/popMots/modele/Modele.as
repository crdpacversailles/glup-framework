package fr.acversailles.crdp.glup.jeux.popMots.modele {
	import fr.acversailles.crdp.glup.framework.donnees.IContenu;
	import fr.acversailles.crdp.glup.framework.donnees.IEnonce;
	import fr.acversailles.crdp.glup.framework.donnees.IOptions;

	import flash.events.Event;
	import flash.events.EventDispatcher;

	/**
	 * @author joachim
	 */
	public class Modele extends EventDispatcher {
		public static const AFFICHABLE : uint = 0;
		public static const AFFICHE : uint = 1;
		public static const COCHE : uint = 2;
		public static const EN_COURS_RETRAIT : uint = 3;
		private var contenu : IContenu;
		private var enonces : Vector.<String>;
		private var statuts : Vector.<Boolean> ;
		private var etats : Vector.<uint> ;
		private var nbEmplacements : uint = 0;
		private var emplacementsOccupes : Vector.<Boolean>;
		private var options : IOptions;
		private var dernierNumeroAffiche : int;
		private var _score : uint;
		private var _gagne : Boolean;
		private var _nbPointsTotal : uint;

		public function Modele(options : IOptions, contenu : IContenu) {
			this.options = options;
			this.contenu = contenu;
			super();
			creerTableaux();
			initialiserTableaux();
			_gagne = false;
			_score = 0;
		}

		private function initialiserTableaux() : void {
			statuts = new Vector.<Boolean>();
			etats = new Vector.<uint>();
			_nbPointsTotal = 0;
			for each (var enonce : IEnonce in contenu.getEnonces()) {
				statuts.push(enonce.statut);
				if (enonce.statut)
					_nbPointsTotal++;
				etats.push(AFFICHABLE);
			}
		}

		private function creerTableaux() : void {
			enonces = new Vector.<String>();
			for each (var enonce : IEnonce in contenu.getEnonces()) {
				enonces.push(enonce.contenu);
			}
		}

		public function renseignerNbEmplacements(nbEmplacements : uint) : void {
			this.nbEmplacements = nbEmplacements;
			emplacementsOccupes = new Vector.<Boolean>(nbEmplacements);
			initialiserEmplacements();
		}

		private function initialiserEmplacements() : void {
			for (var i : int = 0; i < emplacementsOccupes.length; i++) {
				emplacementsOccupes[i] = false;
			}
		}

		public function donnerNumeroBallonAffichable() : int {
			if (aucunBallonAffichable()) return -1;
			var numeroChoisi : uint = 0;
			do {
				numeroChoisi = Math.random() * enonces.length;
			} while (etats[numeroChoisi] != AFFICHABLE);
			etats[numeroChoisi] = AFFICHE;
			dernierNumeroAffiche = numeroChoisi;
			return numeroChoisi;
		}

		public function donnerNumeroBallonAEnlever() : int {
			if (aucunBallonAffiche()) return -1;
			var numeroChoisi : uint = 0;
			do {
				numeroChoisi = Math.random() * enonces.length;
			} while (etats[numeroChoisi] != AFFICHE || (numeroChoisi == dernierNumeroAffiche && getNbBallonsAffiches() > 1));
			etats[numeroChoisi] = EN_COURS_RETRAIT;

			return numeroChoisi;
		}

		private function aucunBallonAffichable() : Boolean {
			for each (var etat : uint in etats) {
				if (etat == AFFICHABLE)
					return false;
			}
			return true;
		}

		private function aucunBallonAffiche() : Boolean {
			for each (var etat : uint in etats) {
				if (etat == AFFICHE)
					return false;
			}
			return true;
		}

		public function donnerNumeroEmplacementDisponible() : int {
			if (aucunEmplacementDisponible()) return -1;
			var numeroChoisi : uint = 0;
			do {
				numeroChoisi = Math.random() * emplacementsOccupes.length;
			} while (emplacementsOccupes[numeroChoisi]);
			emplacementsOccupes[numeroChoisi] = true;
			return numeroChoisi;
		}

		private function aucunEmplacementDisponible() : Boolean {
			for each (var statut : Boolean in emplacementsOccupes) {
				if (statut == false)
					return false;
			}
			return true;
		}

		public function getEnonceStr(numEnonce : uint) : String {
			return enonces[numEnonce];
		}

		public function setEtatBallon(numero : uint, etat : uint) : void {
			etats[numero] = etat;
		}

		public function libererEmplacement(numero : uint) : void {
			emplacementsOccupes[numero] = false;
		}

		public function getNbBallonsAffiches() : Number {
			var nb : uint = 0;
			for each (var etat : uint in etats) {
				if (etat == AFFICHE)
					nb++;
			}
			return nb;
		}

		public function selectionEnonce(numero : uint) : void {
			setEtatBallon(numero, Modele.COCHE);
			var event : Event;
			switch(statuts[numero]) {
				case true:
					_score++;
					event = new PopMotsModeleEvent(PopMotsModeleEvent.BONNE_REPONSE, numero);
					verifieSiGagne();
					break;
				case false:
					if (_score > 0)
						_score--;
					event = new PopMotsModeleEvent(PopMotsModeleEvent.MAUVAISE_REPONSE, numero);
					break;
			}
			dispatchEvent(event);
		}

		private function verifieSiGagne() : void {
			for (var i : int = 0; i < statuts.length; i++) {
				if (statuts[i] && etats[i] != COCHE) {
					_gagne = false;
					return;
				}
			}
			_gagne = true;
		}

		public function getScore() : uint {
			return _score;
		}

		public function reset() : void {
			_score = 0;
			_gagne = false;
			dernierNumeroAffiche = -1;
			initialiserTableaux();
			initialiserEmplacements();
		}

		public function get gagne() : Boolean {
			return _gagne;
		}

		public function get nbPointsTotal() : uint {
			return _nbPointsTotal;
		}

		public function get score() : uint {
			return _score;
		}

		public function getNbEnoncesRestants() : uint {
			var nbEnoncesRestants : uint=0;
			for (var i : int = 0; i < statuts.length; i++) {
				if (statuts[i] && etats[i] != COCHE) {
					nbEnoncesRestants++;
				}
			}
			
			return nbEnoncesRestants;
		}
	}
}
