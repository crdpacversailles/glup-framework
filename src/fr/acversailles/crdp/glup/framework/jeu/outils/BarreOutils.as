package fr.acversailles.crdp.glup.framework.jeu.outils {
	import fr.acversailles.crdp.glup.framework.controle.ControleurGeneral;
	import fr.acversailles.crdp.glup.framework.icones.IconeHome;
	import fr.acversailles.crdp.glup.framework.icones.IconePause;
	import fr.acversailles.crdp.glup.framework.icones.IconePleinEcran;
	import fr.acversailles.crdp.glup.framework.icones.IconeReset;
	import fr.acversailles.crdp.glup.framework.icones.IconeSonOff;
	import fr.acversailles.crdp.glup.framework.icones.IconeSonOn;
	import fr.acversailles.crdp.glup.framework.parametres.PG;

	import com.somerandomdude.iconic.Iconic_play;

	import flash.display.Sprite;

	/**
	 * @author joachim
	 */
	public class BarreOutils extends Sprite {
		private var outils : Vector.<BoutonOutil>;
		private var reductionOutils : Number = 1;

		public function BarreOutils() {
			outils = new Vector.<BoutonOutil>();
		}

		public function ajouterOutil(code : String) : void {
			var nouvelOutil : BoutonOutil;
			switch(code) {
				case ControleurGeneral.PAUSE:
					nouvelOutil = new BoutonOutil(code, new IconePause(), new Iconic_play(), 0);
					break;
				case ControleurGeneral.PLEIN_ECRAN:
					nouvelOutil = new BoutonOutil(code, new IconePleinEcran());
					break;
				case ControleurGeneral.ACCUEIL:
					nouvelOutil = new BoutonOutil(code, new IconeHome());
					break;
				case ControleurGeneral.REINIT:
					nouvelOutil = new BoutonOutil(code, new IconeReset());
					break;
				case ControleurGeneral.VOLUME:
					nouvelOutil = new BoutonOutil(code, new IconeSonOn(), new IconeSonOff(), 0);
					break;
			}
			addChild(nouvelOutil);
			outils.push(nouvelOutil);
			reordonner();
		}

		private function reordonner() : void {
			outils.forEach(replacer);
		}

		private function replacer(outil : BoutonOutil, index : int, v : Vector.<BoutonOutil>) : void {
			outil.y = index > 0 ? v[index - 1].getBounds(this).bottom + PG.MARGE_V_ENTRE_OUTILS : 0;
		}

		private function reduire(outil : BoutonOutil, index : int, v : Vector.<BoutonOutil>) : void {
			index;v;outil.scaleX = outil.scaleY = reductionOutils;
		}

		public function afficherOutil(idCommande : String, actif : Boolean) : void {
			for each (var outil : BoutonOutil in outils) {
				if (outil.idCommande == idCommande) actif ? outil.activer() : outil.desactiver();
			}
		}

		public function recadrer() : void {
			while (outils[outils.length - 1].getBounds(this).bottom > PG.hauteurDispoJeu() - 2 * PG.RAYON_BOUTONS_OUTILS && reductionOutils > 0.1) {
				reductionOutils = reductionOutils - 0.1;
				outils.forEach(reduire);
				reordonner();
			}
		}
	}
}
