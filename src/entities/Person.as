package entities
{
	import flash.geom.Point;
	
	import assets.A;
	
	import entities.particles.Blood;
	import entities.particles.Loot;
	import entities.particles.Smoke;
	
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.masks.Hitbox;
	
	import volticpunk.V;
	import volticpunk.components.Animator;
	import volticpunk.components.PlatformerMovement;
	import volticpunk.entities.VEntity;
	
	public class Person extends VEntity
	{
		protected var health: Number = 50;
		public function Person(x:Number=0, y:Number=0)
		{
			super(x, y, null, new Hitbox(16, 16));
			
			addComponent( new PlatformerMovement(new Point(0, 0.5) ));
			getPlatformMovement().setCollisionTypes(["level", "block"]);
			
			type = "person";
		}
		
		public function hurtMe(multiplier: Number): void {
			health -= 1 * multiplier;
			
			if (health < 0) {
				removeFromWorld();
				V.getRoom().add( new Loot(x, y, 10) );
				
				A.KilledSomethingSound.play();
				
				V.getRoom().add( new Smoke(x, y) );
				V.getRoom().add( new Blood(x, y, Math.random() * 5 - 2.5, Math.random() * -3) );
				V.getRoom().add( new Blood(x, y, Math.random() * 5 - 2.5, Math.random() * -3) );
				V.getRoom().add( new Blood(x, y, Math.random() * 5 - 2.5, Math.random() * -3) );
				V.getRoom().add( new Blood(x, y, Math.random() * 5 - 2.5, Math.random() * -3) );
				V.getRoom().add( new Blood(x, y, Math.random() * 5 - 2.5, Math.random() * -3) );
			}
		}
	}
}