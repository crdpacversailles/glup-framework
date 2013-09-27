package fr.acversailles.crdp.glup.framework.calques {
	import fr.acversailles.crdp.glup.framework.controle.ControleurGeneral;
	import fr.acversailles.crdp.glup.framework.icones.IconeHome;
	import fr.acversailles.crdp.glup.framework.icones.IconeReset;
	import fr.acversailles.crdp.glup.framework.jeu.outils.LienCommande;
	import fr.acversailles.crdp.utils.functions.tr;

	/**
	 * @author joachim
	 */
	public class CalqueFiniAvecScore extends AbstractCalque {
		public function CalqueFiniAvecScore(textesSupplementaire : Vector.<String>) {
			super(textesSupplementaire);
		}

		override protected function determinerTextes() : void {
			titre = tr("FINI")+" !";
			texte = tr("SCORE_OBTENU") + " "+textesSupplementaire[0] + ".";
		}

		override protected function ajouterCommandes() : void {
			ajouterCommande(new LienCommande(ControleurGeneral.REINIT, new  IconeReset(), tr("REJOUER")));
			ajouterCommande(new LienCommande(ControleurGeneral.ACCUEIL, new  IconeHome(), tr("RETOUR_ACCUEIL")));
		}
	}
}
