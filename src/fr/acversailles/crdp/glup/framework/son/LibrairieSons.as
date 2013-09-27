package fr.acversailles.crdp.glup.framework.son {
	import flash.media.Sound;

	/**
	 * @author joachim
	 */
	public class LibrairieSons {
		public static const PERDU_1 : String = "PERDU_1";
		public static const BONNE_REPONSE_1 : String = "BONNE_REPONSE_1";
		public static const CHUTE : String = "CHUTE";
		public static const ERREUR_1 : String = "ERREUR_1";
		public static const ERREUR_2 : String = "ERREUR_2";
		public static const PLOP_1 : String = "PLOP_1";
		public static const GAGNE_1 : String = "GAGNE_1";
		public static const GAGNE_2 : String = "GAGNE_2";
		public static const FEU_1 : String = "FEU_1";
		public static const SPRAY_1 : String = "SPRAY_1";
		public static const TIC_1 : String = "TIC_1";
		public static const MUSIQUE_1 : String = "MUSIQUE_1";
		[Embed(source="../../../../../../../assets/sons/ok.mp3")]
		protected var SonOK : Class;
		[Embed(source="../../../../../../../assets/sons/chute.mp3")]
		protected var SonChute : Class;
		[Embed(source="../../../../../../../assets/sons/plop1.mp3")]
		protected var SonPlop1 : Class;
		[Embed(source="../../../../../../../assets/sons/erreur2.mp3")]
		protected var SonErreur1 : Class;
		[Embed(source="../../../../../../../assets/sons/erreur3.mp3")]
		protected var SonErreur2 : Class;
		[Embed(source="../../../../../../../assets/sons/gong.mp3")]
		protected var SonPerdu1 : Class;
		[Embed(source="../../../../../../../assets/sons/gagne1.mp3")]
		protected var SonGagne1 : Class;
//		[Embed(source="../../../../../../../assets/sons/gagne2.mp3")]
//		protected var SonGagne2 : Class;
		[Embed(source="../../../../../../../assets/sons/feu1.mp3")]
		protected var SonFeu1 : Class;
		[Embed(source="../../../../../../../assets/sons/spray.mp3")]
		protected var SonSpray1 : Class;
		[Embed(source="../../../../../../../assets/sons/tic.mp3")]
		protected var SonTic1 : Class;
		[Embed(source="../../../../../../../assets/sons/musik1.mp3")]
		protected var Musique1 : Class;
		private var sons : Object ;

		public function donnerSon(cle : String) : Sound {
			if (!sons) sons = new Object();
			if (sons[cle]) return sons[cle];
			var son : Sound;
			switch(cle) {
				case BONNE_REPONSE_1:
					son = Sound(new SonOK());
					break;
				case CHUTE:
					son = Sound(new SonChute());
					break;
				case ERREUR_1:
					son = Sound(new SonErreur1());
					break;
				case ERREUR_2:
					son = Sound(new SonErreur2());
					break;
				case PLOP_1:
					son = Sound(new SonPlop1());
					break;
				case PERDU_1:
					son = Sound(new SonPerdu1());
					break;
				case GAGNE_1:
					son = Sound(new SonGagne1());
					break;
				case GAGNE_2:
					son = Sound(new SonGagne1());
					break;
				case FEU_1:
					son = Sound(new SonFeu1());
					break;
				case SPRAY_1:
					son = Sound(new SonSpray1());
					break;
				case TIC_1:
					son = Sound(new SonTic1());
					break;
				case MUSIQUE_1:
					son = Sound(new Musique1());
					break;
			}
			sons[cle] = son;
			return son;
		}
	}
}
