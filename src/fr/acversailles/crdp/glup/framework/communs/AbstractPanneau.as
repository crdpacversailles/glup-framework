package fr.acversailles.crdp.glup.framework.communs {
	import fr.acversailles.crdp.glup.framework.donnees.IContenu;
	import fr.acversailles.crdp.glup.framework.donnees.IOptions;
	import fr.acversailles.crdp.glup.framework.parametres.PG;
	import fr.acversailles.crdp.utils.avertirClasseAbstraite;

	import flash.display.Sprite;

	/**
	 * Classe abstraite représentant un panneau en général, c'est à dire aussi bien un jeu que le panneau d'accueil
	 * @author joachim
	 */
	public class AbstractPanneau extends Sprite implements IPanneau {
		protected var couleurFond : uint;
		protected var options : IOptions;
		protected var contenu : IContenu;

		public function AbstractPanneau(options : IOptions, contenu : IContenu) {
			this.contenu = contenu;
			this.options = options;
			determinerCouleurFond();
			dessiner();
		}

		protected function determinerCouleurFond() : void {
			avertirClasseAbstraite();
		}

		protected function dessiner() : void {
			graphics.beginFill(couleurFond);
			graphics.lineStyle(0, 0, 0);
			graphics.drawRoundRect(PG.MARGE_GAUCHE + PG.LARGEUR_OUTILS + PG.EPAISSEUR_BORD, PG.MARGE_HAUTE + PG.EPAISSEUR_BORD, PG.LARGEUR_SCENE - PG.MARGE_DROITE - (PG.MARGE_GAUCHE + PG.LARGEUR_OUTILS) - 2 * PG.EPAISSEUR_BORD + 1, PG.HAUTEUR_SCENE - PG.MARGE_INF - PG.MARGE_HAUTE - 2 * PG.EPAISSEUR_BORD + 1, PG.ARRONDI_BORDS_CADRE);
			graphics.endFill();
		}

		public function get sprite() : Sprite {
			return this;
		}

		/**
		 * Fonction appelée automatiquement lorsque le panneau est affiché
		 * A implémenter obligatoirement dans les jeux concrets
		 */
		public function activer() : void {
			avertirClasseAbstraite();
		}

		/**
		 * Fonction appelée automatiquement lorsque le panneau est retiré de l'affichage
		 * A implémenter obligatoirement dans les jeux concrets
		 */
		public function desactiver() : void {
			avertirClasseAbstraite();
		}
	}
}
