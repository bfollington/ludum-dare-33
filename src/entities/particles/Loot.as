package entities.particles
{
	import assets.A;
	
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.graphics.Image;
	
	import volticpunk.V;
	import volticpunk.components.Animator;
	import volticpunk.entities.VEntity;
	
	public class Loot extends VEntity
	{
		private var vel: Number = 1;
		private var value: Number;
		
		public function Loot(x:Number=0, y:Number=0, value: Number = 1)
		{
			super(x, y, null, mask);
			
			addComponent( new Animator(A.Loot, 16, 16) );
			
			var image: uint = FP.rand(getAnimator().getSpritemap().columns);
			
			getAnimator().getSpritemap().setFrame(image, 0);
			getAnimator().getSpritemap().scale = Math.random() * 1 + 0.5;
			getAnimator().getSpritemap().angle = Math.random() * 360;
			
			this.value = value;
			V.setGlobal("score", V.getGlobal("score") + value);
			A.GetLootSound.play();
		}
		
		override public function update(): void {
			super.update();
			
			y -= vel;
			vel += 0.1;
			
			getAnimator().getSpritemap().angle += vel;
			
			if (y < 0) {
				removeFromWorld();
			}
		}
	}
}