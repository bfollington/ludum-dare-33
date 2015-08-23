package entities.particles
{
	import flash.geom.Point;
	
	import assets.A;
	
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.masks.Hitbox;
	
	import volticpunk.V;
	import volticpunk.entities.VEntity;
	
	public class Blood extends VEntity
	{
		private var velocity: Point;
		private var scale: Number = 1;
		
		public function Blood(x: Number, y: Number, xVel: Number, yVel: Number)
		{
			super(x, y, new Image(A.Blood));
			
			getImage().originX = 16;
			getImage().originX = 8;
			
			velocity = new Point(xVel, yVel);
		}
		
		override public function update():void
		{
			super.update();
			
			x += velocity.x; 
			y += velocity.y;
			velocity.y += 0.1;
			scale -= 0.01;
			getImage().scale = scale;
			
			getImage().angle = (FP.angle(0, 0, velocity.x, velocity.y));
			
			if (y > V.getRoom().levelHeight) {
				V.getRoom().remove(this);
			}
			
			if (x > FP.camera.x + C.WIDTH + 128) {
				removeFromWorld();				
			}
			
			if (x < FP.camera.x - 128) {
				removeFromWorld();
			}
		}
	}
}