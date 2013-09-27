package fr.acversailles.crdp.glup.framework.jeu {
	import fr.acversailles.crdp.glup.framework.donnees.IContenu;
	import fr.acversailles.crdp.glup.framework.donnees.IOptions;
	import fr.acversailles.crdp.glup.jeux.bruleMots.BruleMots;
	import fr.acversailles.crdp.glup.jeux.chateauMots.ChateauMots;
	import fr.acversailles.crdp.glup.jeux.popMots.PopMots;
	import fr.acversailles.crdp.glup.jeux.tetrisPhrases.TetrisPhrases;
	import fr.acversailles.crdp.utils.functions.assert;

	/**
	 * @author joachim
	 */
	public class JeuxFactory {
		private static const TETRIS_PHRASES : String = "MOTS-TRIS";
		private static const BRULE_MOTS : String = "BRULE-MOTS";
		private static const POP_MOTS : String = "POP-MOTS";
		private static const  JEU_QUENTIN: String = "JEU-QUENTIN";

		public static function creerJeu(identifiantJeu : String, options : IOptions, contenu : IContenu) : IJeu {
			var jeu : IJeu;
			switch(identifiantJeu) {
				case TETRIS_PHRASES:
					jeu = new TetrisPhrases(options, contenu);
					break;
				case BRULE_MOTS:
					jeu = new BruleMots(options, contenu);
					break;
				case POP_MOTS:
					jeu = new PopMots(options, contenu);
					break;
				case JEU_QUENTIN:
					jeu = new ChateauMots(options, contenu);
				break;
				
				default:
					assert(false, "["+identifiantJeu + "] ne correspond à aucun jeu");
			}
			return jeu;
		}
	}
}
