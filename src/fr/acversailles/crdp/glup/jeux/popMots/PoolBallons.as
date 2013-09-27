package fr.acversailles.crdp.glup.jeux.popMots {
	import fr.acversailles.crdp.glup.jeux.popMots.ballons.BallonAvecTexte;
	/**
	 * @author Joachim
	 */
	public class PoolBallons {
		private static var ballons:Vector.<BallonAvecTexte> = new Vector.<BallonAvecTexte>();
		public static function donnerBallon() : BallonAvecTexte {
			if(ballons.length>0)
				return ballons.pop();
			return new BallonAvecTexte();
		}

		public static function rendre(ball : BallonAvecTexte) : void {
			ball.reinitialiser();
			PoolBallons.ballons.push(ball);
		}
	}
}
