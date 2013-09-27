package fr.acversailles.crdp.glup.jeux.popMots.ballons {
	import flash.events.Event;

	/**
	 * @author Joachim
	 */
	public class BallonEvent extends Event {
		public static const FIN_EXPLOSION_GAGNE : String = "FIN_EXPLOSION_GAGNE";
		public static const CREVAISON : String = "CREVAISON";
		public static const FIN_DISPARITION : String = "FIN_DISPARITION";
		public function BallonEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
		}
	}
}
