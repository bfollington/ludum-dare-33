package entities
{
	import flash.geom.Point;
	
	import assets.A;
	
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	
	import volticpunk.V;

	public class Ballista extends Person
	{
		private var arrowTimeout: Number = 0;
		private var p: Point = new Point();
		
		public function Ballista(x:Number=0, y:Number=0)
		{
			super(x + 16, y + 32);
			
			graphic = new Image(A.Ballista);
			getImage().centerOrigin();
		}
		
		override public function update(): void {
			super.update();
			
			arrowTimeout--;
			
			var angle: Number = FP.angle(x, y, DragonGame.getPlayer().x, DragonGame.getPlayer().y);
			getImage().angle = angle;
			
			if (x > FP.camera.x && x < FP.camera.x + C.WIDTH) {
				if (Math.random() < 0.05) {
					
					if (arrowTimeout <= 0) {
						
						FP.angleXY(p, angle, Math.random() * 4 + 3);
						V.getRoom().add(new Arrow(x, y, p.x, p.y, Math.floor(Math.random() * 20), true));
						arrowTimeout = 75;
						A.ArrowFiredSound.play(0.25);
					}
					
				}
			}
		}
	}
}