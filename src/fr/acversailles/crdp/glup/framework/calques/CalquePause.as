package fr.acversailles.crdp.glup.framework.calques {
	import fr.acversailles.crdp.glup.framework.controle.ControleurGeneral;
	import fr.acversailles.crdp.glup.framework.icones.IconePause;
	import fr.acversailles.crdp.glup.framework.jeu.outils.LienCommande;
	import fr.acversailles.crdp.utils.functions.tr;

	/**
	 * @author joachim
	 */
	public class CalquePause extends AbstractCalque {
		public function CalquePause(textesSupplementaire : Vector.<String>) {
			super(textesSupplementaire);
		}

		override protected function determinerTextes() : void {
			titre = tr("PAUSE");
			texte = "";
		}

		override protected function ajouterCommandes() : void {
			ajouterCommande(new LienCommande(ControleurGeneral.PAUSE, new  IconePause(), tr("REPRENDRE")));
		}
	}
}
