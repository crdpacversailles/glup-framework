package fr.acversailles.crdp.glup.jeux.popMots.modele {
	import flash.events.Event;

	/**
	 * @author Joachim
	 */
	public class PopMotsModeleEvent extends Event {
		public static const BONNE_REPONSE : String = "BONNE_REPONSE";
		public static const MAUVAISE_REPONSE : String = "MAUVAISE_REPONSE";
		private var _numero : uint;

		public function PopMotsModeleEvent(type : String, numero : uint, bubbles : Boolean = false, cancelable : Boolean = false) {
			_numero = numero;
			super(type, bubbles, cancelable);
		}

		public function get numero() : uint {
			return _numero;
		}
	}
}
