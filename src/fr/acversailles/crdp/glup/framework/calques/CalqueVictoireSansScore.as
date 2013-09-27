package fr.acversailles.crdp.glup.framework.calques {
	import fr.acversailles.crdp.glup.framework.controle.ControleurGeneral;
	import fr.acversailles.crdp.glup.framework.icones.IconeHome;
	import fr.acversailles.crdp.glup.framework.icones.IconeReset;
	import fr.acversailles.crdp.glup.framework.jeu.outils.LienCommande;
	import fr.acversailles.crdp.utils.functions.tr;

	/**
	 * @author joachim
	 */
	public class CalqueVictoireSansScore extends AbstractCalque {
		public function CalqueVictoireSansScore() {
			super(null);
		}

		override protected function determinerTextes() : void {
			titre = "Gagné !";
			texte = "Tu as trouvé tous les mots dans le temps imparti.";
		}

		override protected function ajouterCommandes() : void {
			ajouterCommande(new LienCommande(ControleurGeneral.REINIT, new  IconeReset(), tr("REJOUER")));
			ajouterCommande(new LienCommande(ControleurGeneral.ACCUEIL, new  IconeHome(), tr("RETOUR_ACCUEIL")));
		}
	}
}
