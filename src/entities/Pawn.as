package entities
{
	import assets.A;
	
	import volticpunk.components.Animator;

	public class Pawn extends Person
	{
		public function Pawn(x:Number=0, y:Number=0)
		{
			super(x, y);
			
			addComponent( new Animator(A.Pawn, 16, 16) );
			getAnimator().add("waddle", [0, 1], 3, true);
			getAnimator().play("waddle");
		}
	}
}