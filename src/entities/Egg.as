package entities
{
	import assets.A;
	
	import entities.particles.EggBits;
	
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.utils.Ease;
	
	import volticpunk.V;
	import volticpunk.components.Repeater;
	import volticpunk.components.Tweener;
	import volticpunk.entities.VEntity;
	
	public class Egg extends VEntity
	{
		public function Egg(x:Number=0, y:Number=0)
		{
			super(x, y, A.EggFinalImage, mask);
			getImage().centerOrigin();
			getImage().originY = getImage().height;
			
			addComponent( new Tweener() );
			addComponent( new Repeater(2, wiggle) );
		}
		
		private function wiggle(e: Entity = null): void {
			
			getTweener().tween(getImage(), {angle: Math.random() * 20 - 10}, 0.5, Ease.bounceOut);
			getTweener().setCallback(function(): void {
				getTweener().tween(getImage(), {angle: 0}, 0.5, Ease.bounceOut);
				getTweener().setCallback(null);
			});
			
			
		}
		
		public function hatch(): void {
			V.getRoom().add( new EggBits(x, y, 0) );
			V.getRoom().add( new EggBits(x, y, 1) );
			V.getRoom().add( new EggBits(x, y, 2) );
			
			graphic = A.EggFrag4Image;
			getImage().centerOrigin();
			getImage().originY = getImage().height;
		}
	}
}