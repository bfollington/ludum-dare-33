package data
{
	import flash.geom.Point;

	public class MapNode
	{
		public var right: MapNode;
		public var up: MapNode;
		public var down: MapNode;
		public var left: MapNode;
		
		public var levelCode: String;
		public var selected: Function;
		
		public var position: Point;
		
		public var hasBallistas: Boolean;
		
		public function MapNode(x: Number, y: Number)
		{
			position = new Point(x, y);
		}
	}
}