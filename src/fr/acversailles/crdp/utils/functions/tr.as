package fr.acversailles.crdp.utils.functions {
	import fr.acversailles.crdp.glup.framework.donnees.Textes;
	/**
	 * @author joachim
	 */
	public function tr(cle:String) : String {
		return Textes.traduire(cle);
	}
}
