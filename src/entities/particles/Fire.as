package entities.particles
{
	import flash.display.BlendMode;
	
	import assets.A;
	
	import entities.Person;
	
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.masks.Hitbox;
	
	import volticpunk.components.LifespanComponent;
	import volticpunk.entities.VEntity;
	
	public class Fire extends VEntity
	{
		private var velocityX: Number;
		private var velocityY: Number;
		private var lifespan: LifespanComponent;
		private var scaleFactor: Number = 1;
		private var damage: Number;
		
		public function Fire(damage: Number, x:Number, y:Number, velocityX: Number = 0, velocityY: Number = 0)
		{
			super(x, y, new Image(FP.choose(A.Fire1, A.Fire2)), new Hitbox(16, 16));
			
			getImage().centerOrigin();
			
			this.velocityX = velocityX + Math.random() - 0.5;
			this.velocityY = velocityY + Math.random() - 0.5;
			this.damage = damage;
			
			getImage().color = 0xFF9900 + 512 * Math.random();
			getImage().blend = BlendMode.ADD;
			getImage().angle = Math.random() * 360;
			scaleFactor = Math.random() * 0.5 + 0.5;
			
			addComponent( lifespan = new LifespanComponent(1) );
			type = "fire";
		}
		
		public function getDamage(): Number {
			return damage;
		}
		
		override public function update(): void {
			super.update();
			
			x += velocityX;
			y += velocityY;
			
			velocityX /= 1.005;
			velocityY /= 1.005;
			
			var person: Person;
			if (person = collide("person", x, y) as Person) {
				
				person.hurtMe(damage * 3);
				log("Fire damage", damage);
				removeFromWorld();
			}
			
			getImage().scale = lifespan.getRemainingPercent() * scaleFactor + 0.25;
			getImage().alpha = lifespan.getRemainingPercent();
		}
	}
}