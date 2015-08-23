package
{

	public class C
	{

		public static const WIDTH: int = 640;
		public static const HEIGHT: int = 360;
		public static const GRID: int = 32;
		public static const TILE_SIZE:int = 32;
		
		public static const LEFT:int = -1;
		public static const RIGHT:int = 1;
		
		public static const LETTERS: Array = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"];
		
		public static const TIMES: Object = {
			"A" : [15, 12.5, 10],
			"B" : [15, 12.5, 10],
			"C" : [25, 17, 13],
			"D" : [20, 13, 9],
			"E" : [27, 22.5, 15],
			"F" : [22.5, 17.5, 12.5],
			"G" : [25, 20, 15],
			"H" : [25, 17, 13],
			"I" : [24, 16, 12],
			"J" : [27, 20, 15.5],
			"K" : [20, 15.5, 11.5],
			"L" : [36, 28, 23],
			"M" : [28, 21, 14],
			"N" : [40, 30, 25.5],
			"O" : [40, 30, 25.5],
			"P" : [27, 18, 13.5],
			"Q" : [45, 38, 31],
			"R" : [40, 30, 25.5],
			"S" : [35, 25, 18],
			"T" : [40, 30, 19.5],
			"U" : [40, 32, 27],
			"V" : [52, 42, 36.5],
			"W" : [57, 47, 37],
			"X" : [59, 49, 39],
			"Y" : [55, 42, 32],
			"Z" : [42, 32, 22]
		};
		
		
        public static const LAYER_BACKGROUND:int = 15;
        public static const LAYER_GROUND:int = 0;
        public static const LAYER_LIGHT:int = -2;
        public static const LAYER_FOREGROUND:int = -3;
        public static const LAYER_DARKNESS:int = -5;
        public static const LAYER_MENU:int = -10;
        public static const LAYER_MENU_UI:int = -11;
		
		public static const FAST_TWEEN:Number = 0.1;
		public static const MEDIUM_TWEEN:Number = 1;
		public static const VERY_SLOW_TWEEN:Number = 1.25;
		public static const FADE_TWEEN:Number = 0.5;

		public static const DEFAULT_COLLISION_TYPE:String = "level";
		
		/** Types the player should collide with */
		public static const COLLISION_TYPES:Array = [DEFAULT_COLLISION_TYPE, "moving_platform", "rotating_platform"];
		
	}
}