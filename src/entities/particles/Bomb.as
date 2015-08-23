package entities.particles
{
	import assets.A;
	
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.masks.Hitbox;
	
	import volticpunk.V;
	import volticpunk.components.Tweener;
	import volticpunk.entities.VEntity;
	
	public class Bomb extends VEntity
	{
		private var velocity: Number = 1;
		
		public function Bomb(x:Number=0, y:Number=0)
		{
			super(x, y, new Image(A.Bomb), new Hitbox(16, 16, -8, -8) );
			
			getImage().centerOrigin();
			addComponent( new Tweener() );
			getTweener().tween( getImage(), {angle: -90}, 1 );
		}
		
		override public function update():void
		{
			super.update();
			
			y += velocity;
			velocity += 0.1;
			
			if (collideTypes(["level", "block"], x, y)) {
				V.getRoom().cam.screenshake(10, 0.5);
				removeFromWorld();
				V.getRoom().add( new BombRadius(x, y) );
				
				V.getRoom().add( new Smoke(x, y) );
				V.getRoom().add( new Smoke(x, y) );
				V.getRoom().add( new Smoke(x, y) );
				
				A.BombExplosionSound.play();
			}
		}
	}
}