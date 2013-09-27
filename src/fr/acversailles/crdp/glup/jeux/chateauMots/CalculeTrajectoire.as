package fr.acversailles.crdp.glup.jeux.chateauMots {
	import fr.acversailles.crdp.glup.framework.parametres.PG;
	import fr.acversailles.crdp.utils.ConvertDegreeRadian;

	import flash.geom.Point;

	public class CalculeTrajectoire {
		private static const HAUT : uint = 0, BAS : uint = 1;
		private static var vecX : Number = 0, vecY : Number = 0, alpha : Number = 0;
		private static var bord : uint;
		private static var _savoirRebond : Boolean;
		private static var _impacte : Point;
		private static var _rebond : Point;

		public static function trajectoire(origine : Point, cible : Point) : void {
			_rebond = new Point(cible.x, cible.y);
			_impacte = new Point(cible.x, cible.y);
			alpha = Math.acos((cible.x - origine.x) / Point.distance(origine, cible));
			vecX = ConvertDegreeRadian.radianToDegree(Math.cos(alpha));
			vecY = ConvertDegreeRadian.radianToDegree(Math.sin(alpha));
			if (origine.y > cible.y) {
				vecY = vecY * -1;
				bord = HAUT;
			} else {
				bord = BAS;
			}
			analyse();
		}

		private static function analyse() : void {
			chercheRebond();
			if (_savoirRebond) {
				calculeRebond();
			}
			calculeImpacte();
		}

		private static function chercheRebond() : void {
			_savoirRebond = false;
			switch (bord) {
				case BAS :
					for (var i : Number = _impacte.x; i < PG.largeurDispoJeu(); i = i + vecX) {
						_rebond.y = _rebond.y + vecY;
						if (_rebond.y > PG.hauteurDispoJeu()) {
							rebondTrue(i);
							break;
						}
					}
					break;
				case HAUT :
					for (i = _impacte.x; i < PG.largeurDispoJeu(); i = i + vecX) {
						_rebond.y = _rebond.y + vecY;
						if (_rebond.y < 0) {
							rebondTrue(i);
							break;
						}
					}
					break;
			}
		}

		private static function rebondTrue(i : Number) : void {
			_savoirRebond = true;
			_rebond.x = i;
			_rebond.y = _rebond.y - vecY;
		}

		private static function calculeRebond() : void {
			switch (bord) {
				case BAS :
					_rebond.x = _rebond.x + (vecX * ((PG.hauteurDispoJeu() - _rebond.y) / vecY));
					_rebond.y = _rebond.y + (vecY * ((PG.hauteurDispoJeu() - _rebond.y) / vecY));
					break;
				case HAUT :
					_rebond.x = _rebond.x + (vecX * ((_rebond.y-60)/vecY * -1));
					_rebond.y = _rebond.y - (vecY * ((_rebond.y-60)/ vecY));
					break;
			}
			vecY = vecY * -1;
			_impacte.x=_rebond.x;
			_impacte.y=_rebond.y;
		}

		private static function calculeImpacte() : void {
			while (_impacte.x < PG.largeurDispoJeu()) {
				_impacte.x = _impacte.x + vecX;
				_impacte.y = _impacte.y + vecY;
				if (_impacte.y > PG.hauteurDispoJeu() || _impacte.y < 60) {
					break;
				}
			}
		}

		static public function get posImpacte() : Point {
			return _impacte;
		}

		static public function get posRebond() : Point {
			return _rebond;
		}

		static public function get savoirRebond() : Boolean {
			return _savoirRebond;
		}
		
		static public function get savoirBord() : uint {
			return bord;
		}
	}
}
