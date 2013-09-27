package fr.acversailles.crdp.glup.framework.son {
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;

	/**
	 * @author joachim
	 */
	public class DiffusionSons {
		private static var librairie : LibrairieSons;
		private static var channels : Vector.<SoundChannel>;
		private static var _autorisationSon : Boolean;
		private static var canalMusique : SoundChannel;
		private static var musique : Sound;
		private static var _autorisationMusique : Boolean;

		public static function jouerSon(cle : String) : void {
			if (!_autorisationSon) return;
			if (!librairie) {
				librairie = new LibrairieSons();
				channels = new Vector.<SoundChannel>;
			}
			var son : Sound = librairie.donnerSon(cle);
			channels.push(son.play());
		}

		public static function arreterTousSons() : void {
			for each (var channel : SoundChannel in channels) {
				channel.stop();
			}
			arreterMusique();
		}

		static public function get autorisationSon() : Boolean {
			return _autorisationSon;
		}

		static public function set autorisationSon(autorisationSon : Boolean) : void {
			_autorisationSon = autorisationSon;
			if (!_autorisationSon) arreterTousSons();
			if (_autorisationMusique && autorisationSon && musique) boucleMusique(null);
		}

		public static function jouerMusique(cle : String) : void {
			if (!_autorisationSon) return;
			arreterMusique();
			if (!librairie) {
				librairie = new LibrairieSons();
				channels = new Vector.<SoundChannel>;
			}
			musique = librairie.donnerSon(cle);

			boucleMusique(null);
		}

		private static function boucleMusique(event : Event) : void {
			if (!_autorisationMusique)
				return;
			if (canalMusique) {
				canalMusique.removeEventListener(Event.SOUND_COMPLETE, boucleMusique);
			}
			canalMusique = musique.play();
			canalMusique.addEventListener(Event.SOUND_COMPLETE, boucleMusique);
		}

		public static function arreterMusique() : void {
			if (canalMusique) {
				canalMusique.removeEventListener(Event.SOUND_COMPLETE, boucleMusique);
				canalMusique.stop();
			}
		}

		static public function set autorisationMusique(autorisationMusique : Boolean) : void {
			_autorisationMusique = autorisationMusique;
		}
	}
}
