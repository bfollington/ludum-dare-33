package rooms
{
	import assets.A;
	
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	import volticpunk.V;
	import volticpunk.worlds.Room;
	
	public class GameOver extends Room
	{
		private var ignoreInputTimer: Number = 30;
		
		public function GameOver(fadeIn:Boolean=true)
		{
			super(fadeIn);
			
			disableDarknessOverlay();
			
			addGraphic( A.DeathSceneImage );
			
			var message: String = stringRepeat("Great-", Math.min(12, V.getReference("segment_list").length) - 3) + "Grandparents will tell their " + stringRepeat("great-", Math.min(12, V.getReference("segment_list").length - 3)) + "grandchildren about " + DragonGame.generateName() + "!";
			
			addGraphic( A.YouDiedImage, 0, 320 - 128, 0 );
			addGraphic( new DragonText(message, 160, 256, {color: 0, width: 320, wordWrap: true}, 8) );
			
			DragonGame.startMusic(A.DragonTechnoDirgeSound);
		}
		
		private function stringRepeat(s: String, times: uint): String {
			var ret: String = "";
			
			for (var i: uint = 0; i < times; i++) {
				ret += s;
			}
			
			return ret;
		}
		
		override public function update(): void {
			super.update();
			
			ignoreInputTimer -= 1;
			
			if (ignoreInputTimer <= 0 && Input.pressed(Key.ANY)) {
				V.changeRoom( new Hatch() );
			}
		}
	}
}