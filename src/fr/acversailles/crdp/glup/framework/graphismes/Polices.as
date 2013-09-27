package fr.acversailles.crdp.glup.framework.graphismes {
	import flash.text.Font;

	/**
	 * @author Dornbusch
	 */
	public class Polices {
		[Embed(source="../../../../../../../assets/fonts/AGENCYB.TTF", fontFamily="AngecyB", embedAsCFF=false)]
		private static const FONT_0 : Class;
		public static const POLICE_0 : String = (new FONT_0() as Font).fontName;
		[Embed(source="../../../../../../../assets/fonts/Arial_Black.ttf", fontFamily="Arial_Black", embedAsCFF=false)]
		private static const FONT_1 : Class;
		public static const POLICE_1 : String = (new FONT_1() as Font).fontName;
		[Embed(source="../../../../../../../assets/fonts/ARLRDBD.TTF", fontFamily="Arial_Rounded", embedAsCFF=false)]
		private static const FONT_2 : Class;
		public static const POLICE_2 : String = (new FONT_2() as Font).fontName;
		[Embed(source="../../../../../../../assets/fonts/actionj.ttf", fontFamily="actionj", embedAsCFF=false)]
		private static const FONT_3 : Class;
		public static const POLICE_3 : String = (new FONT_3() as Font).fontName;
		[Embed(source="../../../../../../../assets/fonts/GGSID.TTF", fontFamily="GGSID", embedAsCFF=false)]
		private static const FONT_4 : Class;
		public static const POLICE_4 : String = (new FONT_4() as Font).fontName;
	}
}
