package entities
{
	import flash.geom.Point;
	
	import assets.A;
	
	import entities.particles.Loot;
	import entities.particles.Smoke;
	
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.masks.Hitbox;
	
	import volticpunk.V;
	import volticpunk.components.PlatformerMovement;
	import volticpunk.entities.VEntity;
	
	public class Block extends VEntity
	{
		private var hasRoof: Boolean = false;
		private var needsRoof: Boolean = false;
		private var checkRoof: Boolean = true;
		private var parent: Building;
		
		private var health: Number = 100;
		
		public function Block(x:Number, y:Number, parent: Building, graphic:Graphic=null)
		{
			super(x, y, graphic, new Hitbox(32, 32));
			
			addComponent( new PlatformerMovement(new Point(0, 0.5) ));
			getPlatformMovement().setCollisionTypes(["level", "block"]);
			type = "block";
			this.parent = parent;
		}
		
		public function receiveDamage(multiplier: Number = 1): void {
			V.getRoom().cam.screenshake(5, 0.5);
			health -= 5 * multiplier;
			
			V.getRoom().add( new Smoke(x + 16, y + 16) );
			
			if (health < 0 && this.world != null) {
				V.getRoom().add( new Loot(x, y, 50) );
				V.getRoom().remove(this);
				A.COLLAPSESound.play();
			}
		}
		
		override public function update():void {
			super.update();
			
			if (checkRoof) {
				if (!hasRoof) {
					if (!collide("block", x, y - 32)) {
						needsRoof = true;
					}
				}
				
				if (needsRoof && !hasRoof) {
					hasRoof = true;
					parent.addRoofBlock( x, y - C.TILE_SIZE );
				}
				
				checkRoof = false;
			}
			
		}
	}
}