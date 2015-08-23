package entities
{
	import flash.geom.Point;
	
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.masks.Hitbox;
	
	import volticpunk.V;
	import volticpunk.components.PlatformerMovement;
	import volticpunk.entities.VEntity;
	
	public class RoofBlock extends VEntity
	{
		public function RoofBlock(x:Number=0, y:Number=0, graphic:Graphic=null)
		{
			super(x, y, graphic, new Hitbox(32, 32));
			
			addComponent( new PlatformerMovement(new Point(0, 0.5) ));
			getPlatformMovement().setCollisionTypes(["level", "block"]);
		}
		
		override public function added():void {
			super.added();
			
			if (Math.random() > 0.5) {
				V.getRoom().add( new Archer(x + 16, y - 32) );	
			}
			
		}
	}
}