package fr.acversailles.crdp.glup.jeux.bruleMots {
	import fr.acversailles.crdp.glup.framework.son.LibrairieSons;
	import fr.acversailles.crdp.glup.framework.son.DiffusionSons;
	import fr.acversailles.crdp.glup.framework.donnees.Phrase;
	import fr.acversailles.crdp.glup.framework.donnees.SegmentPhrase;
	import fr.acversailles.crdp.glup.framework.parametres.PG;

	import flash.display.Sprite;
	import flash.events.MouseEvent;

	/**
	 * @author joachim
	 */
	public class SupportTexte extends Sprite {
		private static const MARGE_GAUCHE_TEXTES : Number = 0.05 * PG.LARGEUR_SCENE;
		private var blocsMots : Vector.<BlocMot>;
		private var curseurX : Number;
		private var curseurY : Number;
		private var dureeExtinction : int;

		public function SupportTexte(dureeExtinction : int) {
			this.dureeExtinction = dureeExtinction;
			initialiser();
			ecouter();
		}

		private function ecouter() : void {
			addEventListener(MouseEvent.MOUSE_OVER, gererMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, gererMouseOut);
		}

		private function gererMouseOut(event : MouseEvent) : void {
			toutDesemphaser();
		}

		private function toutDesemphaser() : void {
			for each (var zone : BlocMot in blocsMots) {
				zone.emphaser(false);
			}
		}

		private function gererMouseOver(event : MouseEvent) : void {
			if (!(event.target is BlocMot)) return;
			var cible : BlocMot = event.target as BlocMot;
			for each (var zone : BlocMot in blocsMots) {
				zone.emphaser(zone == cible);
			}
		}

		private function initialiser() : void {
			if (blocsMots) {
				while (blocsMots.length > 0)
					removeChild(blocsMots.pop());
			}
			blocsMots = new Vector.<BlocMot>();
			curseurX = MARGE_GAUCHE_TEXTES;
			curseurY = 0;
		}

		public function ajouterTexte(phrase : Phrase) : Boolean {
			var nbSegmentsAvant : uint = blocsMots.length;
			var premierMot : Boolean = true;
			for each (var segment : SegmentPhrase in phrase.segments) {
				var nouvelleZone : BlocMot = new BlocMot(segment.contenu, segment.special, dureeExtinction);
				blocsMots.push(nouvelleZone);
				nouvelleZone.x = curseurX;
				nouvelleZone.y = curseurY;
				addChild(nouvelleZone);
				if (premierMot || nouvelleZone.getBounds(this).right > PG.largeurDispoJeu()-MARGE_GAUCHE_TEXTES) {
					nouvelleZone.x = 0;
					nouvelleZone.y += nouvelleZone.height;
				}
				curseurX = nouvelleZone.getBounds(this).right;
				curseurY = nouvelleZone.y;
				premierMot = false;
			}
			if (nouvelleZone.getBounds(this).bottom > PG.hauteurDispoJeu() - PG.HAUTEUR_CONSIGNE) {
				while (blocsMots.length > nbSegmentsAvant)
					removeChild(blocsMots.pop());
				return false;
			}
			return true;
		}

		public function toutEteindre() : void {
			DiffusionSons.jouerSon(LibrairieSons.SPRAY_1);
			for each (var bloc : BlocMot in blocsMots) {
				bloc.eteindre();
			}
		}

		public function reinitialiser() : void {
			while (blocsMots.length > 0)
				removeChild(blocsMots.pop());
			curseurX = MARGE_GAUCHE_TEXTES;
			curseurY = 0;
		}
	}
}
