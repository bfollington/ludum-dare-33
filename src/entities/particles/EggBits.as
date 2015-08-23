package entities.particles
{
	import assets.A;
	
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.graphics.Image;
	
	import volticpunk.entities.VEntity;
	
	public class EggBits extends VEntity
	{
		private var physics: Physics;
		
		public function EggBits(x:Number=0, y:Number=0, pieceIndex: uint = 0)
		{
			super(x, y, graphic, mask);
			
			graphic = new Image(A.EggPiecesList[pieceIndex]);
			getImage().centerOrigin();
			getImage().originY = getImage().height;
			
			addComponent( physics = new Physics() );
			physics.position.x = x;
			physics.position.y = y;
			
			physics.acceleration.y = 0.2;
			
			physics.velocity.y = -2 + Math.random() * 3;
			physics.velocity.x = Math.random() * 6 - 3;
		}
		
		override public function update():void {
			super.update();
			
			x = physics.position.x;
			y = physics.position.y;
			
			
		}
	}
}