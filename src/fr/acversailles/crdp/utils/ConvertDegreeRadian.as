package fr.acversailles.crdp.utils {
	public class ConvertDegreeRadian {
		
	public static function radianToDegree(n : Number) : Number {
		return (n*180/Math.PI);
		}
		
	public static function degreeToRadian(n : Number) : Number {
		return (n/180)*Math.PI;
		}
	}
}

