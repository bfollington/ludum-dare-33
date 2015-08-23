package 
{	
	
	import flash.desktop.NativeApplication;
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import assets.A;
	
	import data.StringData;
	
	import entities.Player;
	
	import net.flashpunk.Engine;
	import net.flashpunk.FP;
	import net.flashpunk.Sfx;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	import rooms.Hatch;
	import rooms.Level;
	
	import volticpunk.V;
	import volticpunk.util.Choose;
	
	[SWF(width = 1280, height = 720, frameRate = 60, backgroundColor = "#31A2F2")]
	public class DragonGame extends Engine
	{
		private static var volume: Number = 1;
		private static var currentTrack: Sfx;
		
		public function DragonGame()
		{
			super(C.WIDTH, C.HEIGHT, 60, false);
			
			FP.screen.scale = 2;
			
			FP.world = new Hatch();
			
			Input.define("Left", Key.LEFT);
			Input.define("Right", Key.RIGHT);
			Input.define("Up", Key.UP);
			Input.define("Down", Key.DOWN);
			Input.define("Jump", Key.Z);
			Input.define("Dash", Key.X);
			Input.define("Action", Key.C);
			Input.define("Fullscreen", Key.F);
			
//			FP.console.enable();
//			FP.console.toggleKey = Key.TAB;
			
			V.setGlobal("score", 0);
		}
		
		override public function init(): void
		{
			var windowMenu: NativeMenu = new NativeMenu();
			var fullscreenCommand: NativeMenuItem = windowMenu.addItem(new NativeMenuItem("Fullscreen"));
			fullscreenCommand.keyEquivalent = 'f';
			fullscreenCommand.addEventListener(Event.SELECT, fullScreen);
			
			var windowedCommand: NativeMenuItem = windowMenu.addItem(new NativeMenuItem("Windowed"));
			windowedCommand.keyEquivalent = 'd';
			windowedCommand.addEventListener(Event.SELECT, windowed);
			
			if (NativeApplication.supportsMenu) {
				//NativeApplication.nativeApplication.menu = new NativeMenu();
				NativeApplication.nativeApplication.menu.addSubmenu(windowMenu, "Display");
			}
		}
		
		override public function update(): void {
			super.update();
			
			if (Input.pressed("Fullscreen")) {
				if (FP.stage.displayState == StageDisplayState.NORMAL) {
					fullScreen(null);
				} else {
					windowed(null);
				}
			}
		}
		
		private function fullScreen(e: Event): void {
			FP.stage.fullScreenSourceRect = new Rectangle(0, 0, 1280, 720);
			FP.stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
		}
		
		private function windowed(e: Event): void {
			FP.stage.displayState = StageDisplayState.NORMAL;
		}
		
		public static function toggleMute(): void
		{
			volume = 1 - volume;
			currentTrack.volume = volume;
		}
		
		public static function getVolume(): Number
		{
			return volume;
		}
		
		public static function getPlayer(): Player {
			return V.getRoom().getMembersByClass(Player).getMembers()[0] as Player;
		}
		
		public static function generateName(): String {
			var descriptor: String;
			var list: Array = V.getReference("segment_list") as Array || [];
			
			if (list.length >= 13) {
				descriptor = FP.choose(StringData.fifthtTier);
			} else if (list.length >= 11) {
				descriptor = FP.choose(StringData.fourTier);
			} else if (list.length >= 8) {
				descriptor = FP.choose(StringData.thirdTier);
			} else if (list.length >= 5) {
				descriptor = FP.choose(StringData.secondTier);
			} else {
				descriptor = FP.choose(StringData.firstTier);
			}
			
			var firstChar: String = descriptor.substr(0, 1); 
			var restOfString: String = descriptor.substr(1, descriptor.length);
			descriptor = firstChar.toUpperCase() + restOfString.toLowerCase(); 
			
			return V.getString("name") + " the " + descriptor; 
		}
		
		public static function howManyUpgrades(): uint {
			
			var list: Array = V.getReference("segment_list") as Array || [];
			var numberOfSegments: uint = list.length;
			
			var permittedSegments: uint = V.getGlobal("score") / 1000 + 3;
			
			
			return permittedSegments - numberOfSegments;
		}
		
		public static function startMusic(music: Sfx): void
		{
			if (currentTrack == music) return;
			
			if (currentTrack) currentTrack.stop();
			currentTrack = music;
			music.loop(volume);
		}
	}
}