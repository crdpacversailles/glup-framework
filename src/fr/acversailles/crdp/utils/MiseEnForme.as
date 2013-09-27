package fr.acversailles.crdp.utils {
	/**
	 * @private
	 */
	public class MiseEnForme {
		public static function mettreEspaceDansNombre(nombre : String) : String {
			if (nombre.length <= 3) return nombre;
			else return mettreEspaceDansNombre(nombre.substring(0, nombre.length - 3)) + "\u00A0" + nombre.substring(nombre.length - 3, nombre.length);
			return "";
		}

		public static function sommeEnEuros(nombre : String) : String {
			return mettreEspaceDansNombre(nombre) + '\u00A0' + "€";
		}

		public static function arrondir(donneeDeBase : Number, decimales : uint) : Number {
			var coeff : Number = Math.pow(10, decimales);
			return Math.round(donneeDeBase * coeff) / coeff;
		}

		public static function retirerDoublesEspaces(chaine : String) : String {
			return chaine.replace(/\s\s/g, " ");
		}

		public static function retirerEspaces(chaine : String) : String {
			return chaine.replace(/\s/g, "");
		}

		public static function espaceInsecableAvant(phrase : String, car : String) : String {
			var chaineModele : String = "\\s" + car;
			var schema : RegExp = new RegExp(chaineModele, "g");
			phrase = phrase.replace(schema, "\u00a0" + car);
			return phrase;
		}

		public static function corrigerPbAAccentSqLite(chaine : String) : String {
			var aAccent : RegExp = new RegExp(String.fromCharCode(65533), "g");
			return chaine.replace(aAccent, "à");
		}

		public static function corrigerPbSlashSqLite(chaine : String) : String {
			return chaine.replace(/\\#/g, "'");
		}

		public static function remplacerCaracteresSpeciaux(description : String) : String {
			description = description.replace(/\n/g, " ");
			description = description.replace(/\t/g, "");
			description = description.replace(/\r/g, "");
			description = description.replace(/§/g, "\n");
			description = description.replace(/_/g, "\u00A0");			description = description.replace(/\\#/g, "\u2019");
			return description;
		}
	}
}