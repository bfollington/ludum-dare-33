package entities
{
	import assets.A;
	
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.masks.Hitbox;

	public class Tree extends Person
	{
		public function Tree(x:Number=0, y:Number=0)
		{
			super(x - 8, y);
			graphic = new Image(FP.choose(A.TreesList));
			mask = new Hitbox(16, getImage().height, 8, -getImage().height);
			health = 10;
			
			getImage().originY = getImage().height;
		}
	}
}