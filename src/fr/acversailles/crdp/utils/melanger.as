package fr.acversailles.crdp.utils {
	/**
	 * @author Dornbusch
	 */
	public function melanger(v : Vector.<*>) : void {
		var nbMelanges : uint = Math.random() * v.length*10+v.length;
		for (var i : int = 0;i < nbMelanges;i++) {
			var elem : * = v.pop();
			var pos : uint = Math.floor(Math.random() * v.length);
			v.splice(pos, 0, elem);
		}
	}
}
