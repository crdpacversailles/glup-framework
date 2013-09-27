 package fr.acversailles.crdp.glup.jeux.chateauMots.modele {
	import flash.events.EventDispatcher;
	import fr.acversailles.crdp.glup.framework.donnees.IContenu;
	import fr.acversailles.crdp.glup.framework.donnees.IEnonce;
	import fr.acversailles.crdp.glup.framework.donnees.IOptions;
	import fr.acversailles.crdp.utils.melanger;


	public class Modele extends EventDispatcher {
		private static const IMPACTE_CHATEAU_VRAI : uint = 0, IMPACTE_CHATEAU_FAUX : uint = 1;
		private static const IMPACTE_PROJECTILE_VRAI : uint = 2, IMPACTE_PROJECTILE_FAUX : uint = 3;
		private static const AJOUT : uint = 0, RETRAIT : uint = 1;
		public static const AFFICHABLE : uint = 0;
		private var _nombreEnoncer : Number = 0;
		private var contenu : IContenu;
		private var options : IOptions;
		private var _score : uint = 0;
		private var _nb : uint = 0;
		private var enonces : Vector.<IEnonce>;
		private var visible : Vector.<uint>;
		private var totalVrai : Number = 0;
		private var totalFaux : Number = 0;
		private var totalMots : Number = 0;
		private var decoupe : Number ;
		private var melange : Boolean;

		public function Modele(options : IOptions, contenu : IContenu) {
			this.options = options;
			this.contenu = contenu;
			super();
			init();
		}

		private function init() : void {
			enonces = new Vector.<IEnonce>();
			enonces = contenu.getEnonces();

			initListe();
			melangerListe();
			blablablublu();
			calculeModificateurScore();
			calculeTimer();
			calculeVitesse();
		}

		private function blablablublu() : void {
			visible = new Vector.<uint>();
			var i : Number = 0;
			for (i = 0; i < enonces.length; i++) {
				visible[i] = 0;
			}
		}

		private function initListe() : void {
			for each (var enonce : IEnonce in enonces) {
				totalMots++;
				if (enonce.statut) {
					totalVrai++;
				}
			}
			totalFaux = totalMots - totalVrai;
			dispatchEvent(new ModeleEvent(ModeleEvent.MAJ_LIST, 2));
		}
	
		private function melangerListe() : void {
			decoupe = Math.floor(totalMots / totalVrai);

			while (melange == false) {
				melanger(Vector.<*>(enonces));
				melange = testMelange();
			}
		}

		private function testMelange() : Boolean {
			var i : Number = 0, o : Number = 0;
			var f : Number = 0, t : Number = 0;
			var temp : Number = 0;
			var g : Number = Math.floor(totalMots / decoupe) - 1;
			for (o = 0; o <= g ; o++) {
				for (temp = i; temp <= (i + decoupe) - 1; temp++) {
					if (enonces[temp].statut) {
						t++;
					} else {
						f++;
					}
				}
				if ((f / t) != (totalFaux / totalVrai)) {
					return false;
				}
				f = t = 0;
				i = i + decoupe;
			}
			return true;
		}

		private function calculeModificateurScore() : void {
			// En construction
		}

		private function calculeTimer() : void {
			// En construction
		}

		private function calculeVitesse() : void {
			// En construction
		}

		public function modifScore(modif : uint) : void {
			switch (modif) {
				case IMPACTE_CHATEAU_VRAI  :
					_score = _score + 2;
					break;
				case IMPACTE_CHATEAU_FAUX :
					_score = _score - 2;
					break;
				case IMPACTE_PROJECTILE_VRAI :
					_score = _score + 2;
					break;
				case IMPACTE_PROJECTILE_FAUX  :
					_score = _score - 0;
					break;
				default :
					_score = _score + 50000;
					break;
			}
			dispatchEvent(new ModeleEvent(ModeleEvent.SCORE_CHANGE, 1));
		}

		public function changerNombreEnoncer() : void {
			_nombreEnoncer++;
			if (_nombreEnoncer > 24) {
				_nombreEnoncer = 1;
			}
		}

		public function ChangeNbCharetteAffiches(i : Number) : void {
			switch (i) {
				case AJOUT :
					_nb++;
					break;
				case RETRAIT :
					_nb = _nb - 1;
					break;
			}
		}

		public function get score() : Number {
			return _score;
		}

		public function ajoutVisible(i : uint) : void {
			visible[i] = 1;
		}

		public function retirerVisible(i : uint) : void {
			visible[i] = 0;
		}

		public function donnerEnonce(i : Number) : String {
			ajoutVisible(i);
			return enonces[i].contenu;
		}

		public function get nombreEnoncer() : Number {
			return _nombreEnoncer;
		}

		public function get NbCharetteAffiches() : Number {
			return _nb;
		}

		public function getvisible(i : Number) : uint {
			return visible[i];
		}
		
		public function getStatut(i : Number) : Boolean{
			return enonces[i].statut;
		}
	}
}

