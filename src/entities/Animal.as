package entities
{
	import assets.A;
	
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.masks.Hitbox;

	public class Animal extends Person
	{
		public function Animal(x:Number=0, y:Number=0)
		{
			super(x, y);
			
			graphic = new Spritemap(A.Animals, 16, 16);
			(graphic as Spritemap).setFrame(FP.rand((graphic as Spritemap).columns), 0);
			mask = new Hitbox(16, 16, 0, -16);
			health = 35;
			
			getImage().originY = (graphic as Spritemap).height;
		}
	}
}