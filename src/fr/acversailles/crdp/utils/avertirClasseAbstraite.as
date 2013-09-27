package fr.acversailles.crdp.utils {
	import flash.errors.IllegalOperationError;
	/**
	 * @author J. Dornbusch - Educnet - Insee
	 */
	public function avertirClasseAbstraite() : void {
		throw new IllegalOperationError("Attention, ceci est une classe ou une méthode de classe abstraite");
	}
}
