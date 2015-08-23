package entities.particles
{
	import flash.display.BlendMode;
	
	import assets.A;
	
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.graphics.Image;
	
	import volticpunk.components.LifespanComponent;
	import volticpunk.entities.VEntity;
	
	public class Smoke extends VEntity
	{
		private var velocityX: Number;
		private var velocityY: Number;
		private var lifespan: LifespanComponent;
		private var scaleFactor: Number = 1;
		
		public function Smoke(x:Number=0, y:Number=0)
		{
			super(x, y, null, mask);
			
			graphic = new Image(FP.choose(A.Smoke1, A.Smoke2));
			
			this.velocityX = Math.random() - 0.5;
			this.velocityY = Math.random() - 0.5;
			
			getImage().color = 0x999999;
			//getImage().blend = BlendMode.ADD;
			getImage().angle = Math.random() * 360;
			scaleFactor = Math.random() * 0.5 + 0.5;
			
			addComponent( lifespan = new LifespanComponent(1) );
		}
		
		override public function update(): void {
			super.update();
			
			x += velocityX;
			y += velocityY;
			
			velocityX /= 1.005;
			velocityY /= 1.005;
			
			getImage().scale = lifespan.getRemainingPercent() * scaleFactor + 0.25;
			getImage().alpha = lifespan.getRemainingPercent();
		}
	}
}