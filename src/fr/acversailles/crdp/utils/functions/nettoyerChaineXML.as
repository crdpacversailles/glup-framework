package fr.acversailles.crdp.utils.functions {
	/**
	 * @author joachim
	 */
	public function nettoyerChaineXML(chaine : String) : String {
		return chaine.replace(/\n*/g, "").replace(/\s\s+/g, " ");
	}
}
