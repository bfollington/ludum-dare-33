package entities.particles
{
	import flash.geom.Point;
	
	import assets.A;
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.masks.Hitbox;
	
	import volticpunk.V;
	import volticpunk.components.LifespanComponent;
	import volticpunk.components.Repeater;
	import volticpunk.entities.VEntity;
	
	public class Fireball extends VEntity
	{
		private var velocity: Point;
		private var damage: Number;
		
		public function Fireball(damage: Number, x:Number=0, y:Number=0, velX: Number = 0, velY: Number = 0)
		{
			super(x, y, new Image(A.Fireball), new Hitbox(2, 2));
			
			getImage().originX = 32;
			getImage().originY = 16;
			
			getImage().angle = FP.angle(0, 0, velX, velY);
			
			velocity = new Point(velX, velY);
			log("Fireball damage", damage);
			this.damage = damage;
			
			addComponent( new Repeater(0.05, makeFire) );
			addComponent( new LifespanComponent(damage) );
		}
		
		private function makeFire(e: Entity = null): void {
			V.getRoom().add( new Fire(damage, x - velocity.x, y - velocity.y, 0, 0) );
		}
		
		override public function removed():void
		{
			super.removed();
			
			A.FireballExplosionSound.play();
			V.getRoom().add( new Smoke(x, y) );
		}
		
		override public function update(): void {
			super.update();
			
			x += velocity.x;
			y += velocity.y;
			
			if (collide("level", x, y)) {
				removeFromWorld();
				V.getRoom().cam.screenshake(2, 0.5);
			}
			
			if (x > FP.camera.x + C.WIDTH + 32) {
				removeFromWorld();				
			}
			
			if (x < FP.camera.x - 32) {
				removeFromWorld();
			}
			
			if (y > FP.camera.y + C.HEIGHT + 32) {
				removeFromWorld();				
			}
			
			if (y < FP.camera.y - 32) {
				removeFromWorld();
			}
		}
	}
}