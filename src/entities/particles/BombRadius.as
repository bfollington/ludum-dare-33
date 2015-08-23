package entities.particles
{
	import entities.Arrow;
	import entities.Block;
	import entities.Person;
	
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.masks.Hitbox;
	
	import volticpunk.entities.VEntity;
	
	public class BombRadius extends VEntity
	{
		public function BombRadius(x:Number=0, y:Number=0)
		{
			super(x, y, null, new Hitbox(128, 128, -64, -64) );
		}
		
		override public function update():void {
			super.update();

			var blocks: Array = [];
			collideInto("block", x, y, blocks);
			for each (var block: Block in blocks) {
				block.receiveDamage(40);
			}
			
			var people: Array = [];
			collideInto("person", x, y, people);
			for each (var person: Person in people) {
				person.getPlatformMovement().velocity.y = -5;
				person.hurtMe(40);
			}
			
			removeFromWorld();
		}
	}
}