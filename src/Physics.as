package
{
	import flash.geom.Point;
	
	import net.flashpunk.FP;
	
	import volticpunk.components.Component;
	import volticpunk.components.util.PolarPoint;
	
	public class Physics extends Component
	{
		private var positionVector: Point;
		private var velocityVector: Point;
		private var accelerationVector: Point;
		private var gravityVector: Point;
		
		private var polarPositionVector: PolarPoint;
		private var polarVelocityVector: PolarPoint;
		private var polarAccelerationVector: PolarPoint;
		private var polarGravityVector: PolarPoint;
		
		
		public function Physics()
		{
			super();
			
			positionVector = new Point();
			this.velocityVector = new Point();
			this.accelerationVector = new Point();
			this.gravityVector = new Point();
			
			this.polarAccelerationVector = new PolarPoint();
			this.polarGravityVector = new PolarPoint();
			this.polarPositionVector = new PolarPoint();
			this.polarVelocityVector = new PolarPoint();
		}
		
		private function computePolarValues(): void {
			pointToPolar(positionVector, polarPositionVector);
			pointToPolar(velocityVector, polarVelocityVector);
			pointToPolar(accelerationVector, polarAccelerationVector);
			pointToPolar(gravityVector, polarGravityVector);
		}
		
		private function pointToPolar(p: Point, out: PolarPoint): void {
			out.angle = Math.atan2(p.y, p.x);
			out.maginitude = Math.sqrt( Math.pow(p.x, 2) + Math.pow(p.y, 2) );
		}
		
		
		
		public function get position(): Point {
			return positionVector;
		}
		
		public function get acceleration(): Point {
			return accelerationVector;
		}
		
		public function get velocity(): Point {
			return velocityVector;
		}
		
		public function get gravity(): Point {
			return gravityVector;
		}
		
		
		
		
		public function get polarPosition(): PolarPoint {
			return polarPositionVector;
		}
		
		public function get polarAcceleration(): PolarPoint {
			return polarAccelerationVector;
		}
		
		public function get polarVelocity(): PolarPoint {
			return polarVelocityVector;
		}
		
		public function get polarGravity(): PolarPoint {
			return polarGravityVector;
		}
		
		
		override public function update(): void {
			super.update();
			
			
			velocityVector.x += accelerationVector.x;
			velocityVector.x += gravityVector.x;
			positionVector.x += velocityVector.x;
			
			
			velocityVector.y += accelerationVector.y;
			velocityVector.y += gravityVector.y;
			positionVector.y += velocityVector.y;
			
			computePolarValues();

		}
	}
}