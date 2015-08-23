package
{
	import flash.geom.Point;
	
	import net.flashpunk.FP;
	import net.flashpunk.utils.Ease;
	
	import volticpunk.util.Angle;

	public class MapController extends Controller
	{
		private var center: Point;
		private var radius: Number = 64;
		private var angle: Number = 0;
		
		public function MapController(centerX: Number, centerY: Number)
		{
			super();
			
			center = new Point(centerX, centerY);
		}
		
		public function setCenter(x: Number, y: Number): void {
			player.getTweener().tween(center, {x: x, y: y}, 0.5, Ease.quadOut);
		}
		
		override public function update():void {
			super.update();
			
			angle += 0.05;
			
			player.x = center.x + radius * Math.cos(angle);
			player.y = center.y + radius * Math.sin(angle);
			player.angle = angle * FP.DEG - 90;
		}
	}
}