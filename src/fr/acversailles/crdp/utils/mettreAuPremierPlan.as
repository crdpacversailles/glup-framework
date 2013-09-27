package fr.acversailles.crdp.utils {
	import flash.display.DisplayObject;
	/**
	 * @author Dornbusch
	 */
	public function mettreAuPremierPlan(objet : DisplayObject) : void {
		objet.parent.setChildIndex(objet, objet.parent.numChildren - 1);
	}
}
