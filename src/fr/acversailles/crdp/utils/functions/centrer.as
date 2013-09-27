package fr.acversailles.crdp.utils.functions {
	import flash.display.DisplayObject;

	/**
	 * @author Dornbusch
	 */
	public function centrer(objet : DisplayObject, espaceHorizontal : Number = 0, espaceVertical : Number = 0) : void {
		if (espaceHorizontal > 0) objet.x = (espaceHorizontal - objet.width) / 2;		if (espaceVertical > 0) objet.y = (espaceVertical - objet.height) / 2;
	}
}
