package rooms
{
	import mx.utils.StringUtil;
	
	import assets.A;
	
	import data.StringData;
	
	import entities.Egg;
	import entities.Player;
	
	import net.flashpunk.FP;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	import volticpunk.V;
	import volticpunk.entities.util.Delayer;
	import volticpunk.worlds.Room;
	
	public class Hatch extends Room
	{
		private var egg: Egg;
		private var hasHatched: Boolean = false;
		private var textBox: TextBox;
		
		public function Hatch(fadeIn:Boolean=true)
		{
			super(fadeIn);
			disableDarknessOverlay();
			
			addGraphic( A.LairImage, 512 );
			addGraphic( A.UnderEggGlowImage, 512, 320 - 122 / 2 - 4, 240 - 52 / 2 );
			
			DragonGame.startMusic(A.ChooseYourDragonSound);
			
			V.setGlobal("health", null);
			V.setGlobal("score", 0);
			V.storeReference("segment_list", null);
		}
		
		override public function begin():void {
			super.begin();
			
			addGraphic( A.TitleTextImage, 0, 0, 0 );
			
			addGraphic( new DragonText("Name your dragon: \n\n(and then press < Enter/Return >)", 16, 120) );

			add( egg = new Egg(320, 240) );
			add( textBox = new TextBox(true, "", 160, 120) );
		}
		
		private function hatch(): void {
			egg.hatch();
			V.getRoom().add( new Player(egg.x, egg.y - 48, new HatchController()) );
			
			A.HATCHSound.play();
		}
		
		private function goToMap(): void {
			V.changeRoom(new WorldMap());
		}
		
		override public function update():void {
			super.update();
			
			if (Input.pressed(Key.ENTER) && !hasHatched) {
				hatch();
				hasHatched = true;
				V.setString("name", StringUtil.trim(textBox.text) || FP.choose(StringData.nameless));
				add( new Delayer(1, goToMap) );
			}
		}
	}
}