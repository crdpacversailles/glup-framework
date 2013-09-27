package fr.acversailles.crdp.glup.framework.controle {
	import fr.acversailles.crdp.glup.framework.Main;
	import fr.acversailles.crdp.glup.framework.jeu.outils.BoutonOutil;
	import fr.acversailles.crdp.glup.framework.jeu.outils.LienCommande;
	import fr.acversailles.crdp.glup.framework.son.DiffusionSons;

	import flash.display.StageDisplayState;
	import flash.events.MouseEvent;

	/**
	 * @author joachim
	 */
	public class ControleurGeneral {
		public static const SUITE_AIDE : String = "SUITE_AIDE";
		public static const PRECEDENT_AIDE : String = "PRECEDENT_AIDE";
		public static const FERMER_AIDE : String = "FERMER_AIDE";
		public static const QUITTER : String = "QUITTER";
		private var support : Main;
		public static const JOUER : String = "JOUER";
		public static const AIDE : String = "AIDE";
		public static const PAUSE : String = "PAUSE";
		public static const PLEIN_ECRAN : String = "PLEIN_ECRAN";
		public static const ACCUEIL : String = "ACCUEIL";
		public static const REINIT : String = "REINIT";
		public static const VOLUME : String = "VOLUME";

		public function ControleurGeneral(support : Main) {
			this.support = support;
		}

		public function transmettre(event : MouseEvent) : void {
			switch(event.type) {
				case MouseEvent.CLICK:
					gererClic(event);
					break;
			}
		}

		private function gererClic(event : MouseEvent) : void {
			if (event.target is BoutonOutil) {
				var bouton : BoutonOutil = event.target as BoutonOutil;
				if (bouton.desactive)
					return;
				switch(bouton.idCommande) {
					case PLEIN_ECRAN:
						if (support.stage.displayState == StageDisplayState.FULL_SCREEN) {
							support.stage.displayState = StageDisplayState.NORMAL;
						} else if (support.stage.displayState == StageDisplayState.NORMAL) {
							support.stage.displayState = StageDisplayState.FULL_SCREEN;
						}
						break;
					case VOLUME:
						DiffusionSons.autorisationSon = !DiffusionSons.autorisationSon;
						bouton.etatIcone = DiffusionSons.autorisationSon ? 0 : 1;
						break;
					case PAUSE:
						togglePause();
						break;
					case REINIT:
						support.reinitialiser();
						break;
					case ACCUEIL:
						support.etat = EtatsInterface.ACCUEIL;
						break;
					case FERMER_AIDE:
						support.masquerAide();;
						break;
				}
			} else if (event.target is LienCommande) {
				var commande : LienCommande = event.target as LienCommande;
				switch(commande.idCommande) {
					case REINIT:
						support.reinitialiser();
						break;
					case PAUSE:
						togglePause();
						break;
					case ACCUEIL:
						support.etat = EtatsInterface.ACCUEIL;
						break;
					case JOUER:
						support.etat = EtatsInterface.JEU;
						break;
					case AIDE:
						support.afficherAide();;
						break;
				}
			}
		}

		private function togglePause() : void {
			if (support.enPause)
				support.play();
			else
				support.pause();
		}
	}
}
