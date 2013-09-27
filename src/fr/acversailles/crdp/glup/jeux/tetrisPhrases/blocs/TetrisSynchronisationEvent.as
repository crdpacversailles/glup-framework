package fr.acversailles.crdp.glup.jeux.tetrisPhrases.blocs {
	import fr.acversailles.crdp.glup.framework.controle.SynchronisationEvent;

	/**
	 * @author joachim
	 */
	public class TetrisSynchronisationEvent extends SynchronisationEvent {
		public static const ARRIVEE_PHRASE : String = "ARRIVEE_PHRASE";
				public static const DISPARITION_PHRASE : String = "DISPARITION_PHRASE";
		

		public function TetrisSynchronisationEvent(type : String) {
			super(type);
		}
	}
}
