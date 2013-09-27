package fr.acversailles.crdp.glup.framework.calques {
	import fr.acversailles.crdp.glup.framework.controle.ControleurGeneral;
	import fr.acversailles.crdp.glup.framework.icones.IconeHome;
	import fr.acversailles.crdp.glup.framework.icones.IconeReset;
	import fr.acversailles.crdp.glup.framework.jeu.outils.LienCommande;
	import fr.acversailles.crdp.utils.functions.tr;

	/**
	 * @author joachim
	 */
	public class CalqueDefaiteSansScore extends AbstractCalque {
		public function CalqueDefaiteSansScore() {
			super(null);
		}

		override protected function determinerTextes() : void {
			titre = "Perdu !";
			texte = "Le temps est écoulé, tu peux tenter ta chance à nouveau.";
		}

		override protected function ajouterCommandes() : void {
			ajouterCommande(new LienCommande(ControleurGeneral.REINIT, new  IconeReset(), tr("REJOUER")));
			ajouterCommande(new LienCommande(ControleurGeneral.ACCUEIL, new  IconeHome(), tr("RETOUR_ACCUEIL")));
		}
	}
}
