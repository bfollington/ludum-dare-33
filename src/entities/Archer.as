package entities
{
	import flash.geom.Point;
	
	import assets.A;
	
	import net.flashpunk.FP;
	
	import volticpunk.V;
	import volticpunk.components.Animator;

	public class Archer extends Person
	{
		private var arrowTimeout: Number = 0;
		private var p: Point = new Point();
		
		public function Archer(x:Number=0, y:Number=0)
		{
			super(x, y);
			
			addComponent( new Animator(A.Archer, 16, 16) );
			getAnimator().add("waddle", [0, 1], 3, true);
			getAnimator().play("waddle");
		}
		
		override public function update(): void {
			super.update();
			
			arrowTimeout--;
			
			if (x > FP.camera.x && x < FP.camera.x + C.WIDTH) {
				if (Math.random() < 0.05) {
					
					if (arrowTimeout <= 0) {
						var angle: Number = FP.angle(x, y, DragonGame.getPlayer().x, DragonGame.getPlayer().y);
						FP.angleXY(p, angle, Math.random() * 3 + 2);
						V.getRoom().add(new Arrow(x, y, p.x, p.y, Math.floor(Math.random() * 20)));
						arrowTimeout = 25;
						A.ArrowFiredSound.play(0.25);
					}
					
				}
			}
		}
	}
}