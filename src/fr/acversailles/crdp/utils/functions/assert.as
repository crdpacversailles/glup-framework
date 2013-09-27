package fr.acversailles.crdp.utils.functions {
	import flash.errors.IllegalOperationError;
	/**
	 * @author Dornbusch
	 */
	public function assert(bool : Boolean, message : String = "") : void {
		if (!bool)
			throw new IllegalOperationError(message);
	}
}
