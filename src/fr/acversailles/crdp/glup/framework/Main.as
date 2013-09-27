package fr.acversailles.crdp.glup.framework {
	import fr.acversailles.crdp.glup.framework.calques.GestionCalques;
	import fr.acversailles.crdp.glup.framework.communs.IPanneau;
	import fr.acversailles.crdp.glup.framework.communs.accueil.Accueil;
	import fr.acversailles.crdp.glup.framework.controle.ControleurGeneral;
	import fr.acversailles.crdp.glup.framework.controle.EtatsInterface;
	import fr.acversailles.crdp.glup.framework.controle.SynchronisationEvent;
	import fr.acversailles.crdp.glup.framework.donnees.Contenu;
	import fr.acversailles.crdp.glup.framework.donnees.IContenu;
	import fr.acversailles.crdp.glup.framework.donnees.IOptions;
	import fr.acversailles.crdp.glup.framework.donnees.Options;
	import fr.acversailles.crdp.glup.framework.donnees.Textes;
	import fr.acversailles.crdp.glup.framework.graphismes.FormatsTexte;
	import fr.acversailles.crdp.glup.framework.icones.FondGeneral;
	import fr.acversailles.crdp.glup.framework.jeu.IJeu;
	import fr.acversailles.crdp.glup.framework.jeu.JeuxFactory;
	import fr.acversailles.crdp.glup.framework.jeu.chrono.BarreChrono;
	import fr.acversailles.crdp.glup.framework.jeu.outils.BarreOutils;
	import fr.acversailles.crdp.glup.framework.jeu.score.FenetreScore;
	import fr.acversailles.crdp.glup.framework.parametres.PG;
	import fr.acversailles.crdp.glup.framework.son.DiffusionSons;
	import fr.acversailles.crdp.glup.framework.transitions.GestionTransitions;

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;

	/**
	 * @author joachim
	 */
	public class Main extends Sprite {
		private static var IDENTIFIANT_JEU : String = CONFIG::nom;
		[Embed(source=CONFIG::chemin_options, mimeType="application/octet-stream")]
		private const OptionsXML : Class;
		[Embed(source=CONFIG::chemin_contenu, mimeType="application/octet-stream")]
		private const ContenuXML : Class;
		[Embed(source="../../../../../../data/langues.xml", mimeType="application/octet-stream")]
		private const langueXML : Class;
		private var options : IOptions;
		private var contenu : IContenu;
		private var jeu : IJeu;
		private var accueil : Accueil;
		protected var titre : String;
		private var controleur : ControleurGeneral;
		private var _enPause : Boolean;
		private var _etat : String;
		private var barreOutils : BarreOutils;
		private var zoneScore : FenetreScore;
		private var panneauCourant : IPanneau;
		private var barreChrono : BarreChrono;
		private var fond : FondGeneral;

		public function Main() {
			acquisitionDonnees();
			Textes.initialiser(XML(new langueXML()), options.langue);
			dessiner();
			creerJeu();
			creerAccueil();
			creerControleur();
			mettreBarreOutils();
			if (options.score)
				mettreZoneScore();
			if (options.chrono)
				mettreZoneChrono();
			GestionCalques.initialiser(this);
			DiffusionSons.autorisationSon = true;
			GestionTransitions.initialiser(this);
			etat = EtatsInterface.ACCUEIL;
		}

		private function dessiner() : void {
			fond = new FondGeneral();
			fond.width=PG.LARGEUR_SCENE;
			fond.height=PG.HAUTEUR_SCENE;
			fond.filters=[new DropShadowFilter()];
			fond.cacheAsBitmap=true;
			addChild(fond);
		}

		private function creerControleur() : void {
			controleur = new ControleurGeneral(this);
			addEventListener(MouseEvent.CLICK, transmettreControleur);
		}

		private function transmettreControleur(event : MouseEvent) : void {
			controleur.transmettre(event);
		}

		private function creerJeu() : void {
			jeu = JeuxFactory.creerJeu(IDENTIFIANT_JEU, options, contenu);
			addChildAt(jeu.sprite, 0);
			jeu.sprite.addEventListener(SynchronisationEvent.DEMANDE_BLOCAGE, gererDemandeBlocage);
			jeu.sprite.addEventListener(SynchronisationEvent.AFFICHAGE_SCORE, afficherScore);
			jeu.sprite.addEventListener(SynchronisationEvent.DEMARRAGE_CHRONO, demarrerChrono);
			jeu.sprite.addEventListener(SynchronisationEvent.ARRET_CHRONO, arreterChrono);
			jeu.sprite.addEventListener(SynchronisationEvent.SUSPENSION_CHRONO, suspendreChrono);
			jeu.sprite.addEventListener(SynchronisationEvent.REPRISE_CHRONO, reprendreChrono);
			jeu.sprite.visible = false;
		}

		private function reprendreChrono(event : SynchronisationEvent) : void {
			if(options.chrono)
				barreChrono.reprendre();
		}

		private function suspendreChrono(event : SynchronisationEvent) : void {
			if(options.chrono)
				barreChrono.suspendre();
		}

		private function arreterChrono(event : SynchronisationEvent) : void {
			if(options.chrono)
				barreChrono.arreter();
		}
		
		private function reinitialiserChrono() : void {
			if(options.chrono)
				barreChrono.afficherTemps(options.tempsDepartChrono);
		}

		private function demarrerChrono(event : SynchronisationEvent) : void {
			if(options.chrono)
				barreChrono.demarrer();
		}

		private function gererDemandeBlocage(event : SynchronisationEvent) : void {
			activerInterface(false);
		}

		private function creerAccueil() : void {
			accueil = new Accueil(jeu.nomJeu, options, contenu);
			addChildAt(accueil,0);
			accueil.x = 0;
			accueil.y = 0;
		}

		private function acquisitionDonnees() : void {
			options = new Options(XML(new OptionsXML()));
			contenu = new Contenu(XML(new ContenuXML()));
			FormatsTexte.taillePolicePrincipale = options.taillePolice;
		}

		public function get enPause() : Boolean {
			return _enPause;
		}

		public function play() : void {
			_enPause = false;
			if (barreChrono) barreChrono.reprendre();
			GestionCalques.masquerCalque();
			jeu.play();
		}

		public function pause() : void {
			_enPause = true;
			if (barreChrono) barreChrono.suspendre();
			jeu.pause();
			GestionCalques.afficherCalque(GestionCalques.PAUSE);
		}

		public function reinitialiser() : void {
			DiffusionSons.arreterTousSons();
			GestionCalques.masquerCalque();
			jeu.reinitialiser();
		}

		public function activerInterface(actif : Boolean) : void {
			jeu.sprite.mouseEnabled = actif;
			jeu.sprite.mouseChildren = actif;
			barreOutils.mouseEnabled = actif;
			barreOutils.mouseChildren = actif;
		}

		public function get etat() : String {
			return _etat;
		}

		public function set etat(nouvelEtat : String) : void {
			if (_etat == nouvelEtat) return;
			_etat = nouvelEtat;
			GestionCalques.masquerCalque();
			switch(nouvelEtat) {
				case EtatsInterface.ACCUEIL:
					barreOutils.afficherOutil(ControleurGeneral.ACCUEIL, true);
					barreOutils.afficherOutil(ControleurGeneral.PAUSE, false);
					barreOutils.afficherOutil(ControleurGeneral.PLEIN_ECRAN, true);
					barreOutils.afficherOutil(ControleurGeneral.REINIT, false);
					barreOutils.afficherOutil(ControleurGeneral.VOLUME, true);
					mettrePanneau(accueil);
					arreterChrono(null);
					reinitialiserChrono();
					break;
				case EtatsInterface.JEU:
					barreOutils.afficherOutil(ControleurGeneral.ACCUEIL, true);
					barreOutils.afficherOutil(ControleurGeneral.PAUSE, true);
					barreOutils.afficherOutil(ControleurGeneral.PLEIN_ECRAN, true);
					barreOutils.afficherOutil(ControleurGeneral.REINIT, true);
					barreOutils.afficherOutil(ControleurGeneral.VOLUME, true);
					mettrePanneau(jeu);
					break;
			}
		}


		private function mettrePanneau(panneau : IPanneau) : void {
			if (panneauCourant) panneauCourant.desactiver();
			GestionTransitions.transition(panneauCourant, panneau);
			panneauCourant = panneau;
			panneauCourant.activer();
		}

		private function mettreBarreOutils() : void {
			barreOutils = new BarreOutils();
			addChild(barreOutils);
			barreOutils.x = PG.MARGE_GAUCHE;
			barreOutils.y = PG.MARGE_HAUTE;
			barreOutils.ajouterOutil(ControleurGeneral.ACCUEIL);
			barreOutils.ajouterOutil(ControleurGeneral.PLEIN_ECRAN);
			barreOutils.ajouterOutil(ControleurGeneral.VOLUME);
			barreOutils.ajouterOutil(ControleurGeneral.PAUSE);
			barreOutils.ajouterOutil(ControleurGeneral.REINIT);
			barreOutils.recadrer();
		}

		private function mettreZoneScore() : void {
			zoneScore = new FenetreScore(2);
			addChild(zoneScore);
			zoneScore.x = PG.MARGE_GAUCHE;
			zoneScore.y = PG.HAUTEUR_SCENE - PG.MARGE_INF - zoneScore.height;
		}

		protected function afficherScore(event : SynchronisationEvent) : void {
			if (zoneScore)
				zoneScore.afficherScore(event.donnee);
		}

		private function mettreZoneChrono() : void {
			barreChrono = new BarreChrono(options.tempsDepartChrono, PG.Y_BORD_INF_CORNICHE - PG.Y_BORD_SUP_CORNICHE - PG.RAYON_BOUTONS_OUTILS);
			addChild(barreChrono);
			barreChrono.x = PG.MARGE_GAUCHE + PG.RAYON_BOUTONS_OUTILS/2;
			barreChrono.y = PG.Y_BORD_SUP_CORNICHE + PG.RAYON_BOUTONS_OUTILS/2 ;
			barreChrono.addEventListener(SynchronisationEvent.FIN_CHRONO, gererFinChrono);
		}

		private function gererFinChrono(event : SynchronisationEvent) : void {
			jeu.gererFinChrono();
		}

		public function afficherAide() : void {
			if (etat != EtatsInterface.ACCUEIL) return;
			accueil.afficherAide();
		}

		public function masquerAide() : void {
			accueil.masquerAide();
		}
	}
}
