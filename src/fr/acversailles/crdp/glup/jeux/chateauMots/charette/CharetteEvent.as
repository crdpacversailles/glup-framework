package fr.acversailles.crdp.glup.jeux.chateauMots.charette {
	import flash.events.Event;

	public class CharetteEvent extends Event {
		public static const CHARETTE_EXPLOSION : String = "CHARETTE_EXPLOSION";
		public static const CHARETTE_DISPARITION : String = "CHARETTE_DISPARITION";
			public function CharetteEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false) {
				super(type, bubbles, cancelable);
			}
	}
}