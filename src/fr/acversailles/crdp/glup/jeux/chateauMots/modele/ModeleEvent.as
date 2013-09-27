package fr.acversailles.crdp.glup.jeux.chateauMots.modele {
	import flash.events.Event;

	public class ModeleEvent extends Event {
		public static const SCORE_CHANGE : String = "SCORE_CHANGE";
		public static const MAJ_LIST : String = "MAJ_LIST";
		private var _numero : uint;
		
		public function ModeleEvent(type : String, numero : uint, bubbles : Boolean = false, cancelable : Boolean = false) {
			_numero = numero;
			super(type, bubbles, cancelable);
		}
		
		public function get numero() : uint {
			return _numero;
		}
	}
}

