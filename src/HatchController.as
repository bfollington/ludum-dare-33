package
{
	public class HatchController extends Controller
	{
		private var speed: Number = 3;
		
		public function HatchController()
		{
			super();
		}
		
		override public function update():void
		{
			super.update();
			
			player.y -= speed;
			player.x += speed;
			speed += 0.25;
			
			player.angle = 45;
		}
	}
}