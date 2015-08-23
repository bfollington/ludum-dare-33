package entities
{
	import assets.A;
	
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	
	import volticpunk.entities.VEntity;
	
	public class TooHungryMessage extends VEntity
	{
		private var counter: Number = 0;
		
		public function TooHungryMessage(x:Number=0, y:Number=0, graphic:Graphic=null, mask:Mask=null)
		{
			super(x, y, A.TooHungry3Image, mask);
			
			getImage().centerOrigin();
			
			
		}
		
		override public function update(): void {
			super.update();
			
			counter += 0.2;
			getImage().angle = 12 * Math.sin(counter);
		}
	}
}