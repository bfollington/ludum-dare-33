package entities
{
	import flash.geom.Point;
	
	import assets.A;
	
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.masks.Hitbox;
	
	import volticpunk.V;
	import volticpunk.components.PlatformerMovement;
	import volticpunk.entities.VEntity;
	import volticpunk.util.Choose;
	
	public class Arrow extends VEntity
	{
		private var damage: Number;
		
		private var velocity: Point;
		
		public function Arrow(x: Number, y: Number, xVel: Number, yVel: Number, index: uint, ballistaArrow: Boolean = false)
		{
			super(x, y);
			
			velocity = new Point(xVel, yVel);
			
			if (ballistaArrow) {
				graphic = new Image(A.ProjectilesBallistasList[index]);
				damage = Math.round( index / 2.0 );		
			} else {
				graphic = new Image(A.ProjectilesArrowsList[index]);
				damage = Math.round( index / 4.0 );
			}
			
			type = "arrow";
			mask = new Hitbox(4, 4);
		}
		
		public function getDamage():Number{
			return damage;
		}
		
		override public function update():void
		{
			super.update();
			
			x += velocity.x; 
			y += velocity.y;
			velocity.y += 0.025;
			
			getImage().angle = (FP.angle(0, 0, velocity.x, velocity.y) - 90);
			
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