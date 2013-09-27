package fr.acversailles.crdp.glup.framework.donnees {
	/**
	 * @author joachim
	 */
	public class Phrase {
		private var _segments : Vector.<SegmentPhrase>;
		public function Phrase() {
			_segments = new Vector.<SegmentPhrase>();
		}

		public function ajouterBloc(segmentPhrase : SegmentPhrase) : void {
			_segments.push(segmentPhrase);
		}

		public function get segments() : Vector.<SegmentPhrase> {
			return _segments;
		}

		public function get nbBlocsSpeciaux() : uint {
			var nbSegments : uint = 0;
			for each (var segment : SegmentPhrase in _segments) {
				if (segment.special) nbSegments++;
			}

			return nbSegments;
		}
	}
}
