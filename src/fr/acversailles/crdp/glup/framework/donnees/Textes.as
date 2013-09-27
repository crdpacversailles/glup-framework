package fr.acversailles.crdp.glup.framework.donnees {
	/**
	 * @author joachim
	 */
	public class Textes {
		private static var _textesXML : XML;
		private static var _langue : String;

		public static function initialiser(textesXML : XML, langue : String) : void {
			_langue = langue;
			_textesXML = textesXML;
		}

		public static function traduire(cle : String) : String {
			return _textesXML.xmldata.(@id==cle).translation.(@lang==_langue);
		}

	}
}
