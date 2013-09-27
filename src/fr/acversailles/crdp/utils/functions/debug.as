package fr.acversailles.crdp.utils.functions {
	import flash.errors.IllegalOperationError;
	/**
	 * @author joachim
	 */
	public function debug(...args) : void {
		var retour:String="";
		for each (var arg : * in args) {
			retour+=String(arg)+" / ";
		}
		throw new IllegalOperationError(retour);
	}
}
