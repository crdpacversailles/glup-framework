package fr.acversailles.crdp.utils {
	import flash.errors.IllegalOperationError;
	/**
	 * @author J. Dornbusch - Educnet - Insee
	 */
	public function avertirReferenceSceneNecessaire() : void {
		throw new IllegalOperationError("Cette classe statique aurait dû ere initialisée par le passage d'une référence à la scène");
	}
}
