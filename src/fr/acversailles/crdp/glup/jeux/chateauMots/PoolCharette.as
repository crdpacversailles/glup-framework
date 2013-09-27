package fr.acversailles.crdp.glup.jeux.chateauMots {
	import fr.acversailles.crdp.glup.jeux.chateauMots.charette.Charette;

	public class PoolCharette {
		private static var chariottes:Vector.<Charette> = new Vector.<Charette>();
		public static function donnerCharette() : Charette {
			if(chariottes.length>0)
				return chariottes.pop();
			return new Charette();
		}
		
		public static function rendre(chariotte : Charette) : void {
			chariotte.reinitialiser();
			PoolCharette.chariottes.push(chariotte);
		}
		
		static public function get getChariotte () : Vector.<Charette> {
			return chariottes;
			
		}
	}
}
