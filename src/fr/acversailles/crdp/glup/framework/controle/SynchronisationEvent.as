package fr.acversailles.crdp.glup.framework.controle {
	import flash.events.Event;

	/**
	 * @author joachim
	 */
	public class SynchronisationEvent extends Event {
		public static const DEMANDE_BLOCAGE : String = "DEMANDE_BLOCAGE";
		public static const AFFICHAGE_SCORE : String = "AFFICHAGE_SCORE";
		public static const FIN_AFFICHAGE_MASQUE : String = "FIN_AFFICHAGE_MASQUE";
		public static const DEMARRAGE_CHRONO : String = "DEMARRAGE_CHRONO";
		public static const FIN_CHRONO : String = "FIN_CHRONO";
		public static const EXTINCTION : String = "EXTINCTION";
		public static const ARRET_CHRONO : String = "ARRET_CHRONO";
		public static const SUSPENSION_CHRONO : String = "SUSPENSION_CHRONO";
		public static const REPRISE_CHRONO : String = "REPRISE_CHRONO";
		private var _donnee : uint;

		public function SynchronisationEvent(type : String, donnee : uint = 0) {
			_donnee = donnee;
			super(type);
		}

		public function get donnee() : uint {
			return _donnee;
		}
	}
}
