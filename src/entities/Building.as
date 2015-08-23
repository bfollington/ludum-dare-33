package entities
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import assets.A;
	
	import net.flashpunk.graphics.Image;
	
	import volticpunk.entities.Group;
	
	public class Building extends Group
	{
		private var wallTiles: Class;
		private var roofTiles: Class;
		private var bitmapData: BitmapData;
		private var roofBitmapData: BitmapData;
		
		public function Building(x:int, y:int, width: uint, height: uint, isCastle: Boolean = false)
		{
			super(x, y + height * C.TILE_SIZE);
			
			if (!isCastle) {
				wallTiles = A.BrickTiles;
				roofTiles = A.BrickRoof;	
			} else {
				wallTiles = A.CastleTiles;
				roofTiles = A.CastleRoof;
			}
			
			
			
			bitmapData = (new wallTiles() as Bitmap).bitmapData;
			roofBitmapData = (new roofTiles() as Bitmap).bitmapData;
			
			growSelf(width, height);
		}
		
		private function getTileCount(): uint {
			var count: uint = 0;
			
			count = (bitmapData.width / C.TILE_SIZE) * (bitmapData.height / C.TILE_SIZE);
			return count;
		}
		
		private function getRoofTileCount(): uint {
			var count: uint = 0;
			
			count = (roofBitmapData.width / C.TILE_SIZE) * (roofBitmapData.height / C.TILE_SIZE);
			return count;
		}
		
		private function convertFromTileIndexToRect(index:int):Rectangle
		{
			//Dims 8 x 2
			
			var x:int = (index % 8) * C.TILE_SIZE;
			var y:int = int(index / 8) * C.TILE_SIZE;
			
			return new Rectangle(x, y, C.TILE_SIZE, C.TILE_SIZE);
		}
		
		private function addNewBlock(x: Number, y: Number): Block {
			
			var maskbitmap: BitmapData = new BitmapData(C.TILE_SIZE, C.TILE_SIZE, true, 0);
			maskbitmap.fillRect(maskbitmap.rect, 0);
			maskbitmap.copyPixels(bitmapData, convertFromTileIndexToRect(Math.floor(Math.random() * getTileCount())), new Point(0,0));
			
			var i: Image = new Image(maskbitmap);
			var block: Block = new Block(x, y, this, i);
			
			return block;
		}
		
		public function addRoofBlock(x: Number, y: Number): void {
			var maskbitmap: BitmapData = new BitmapData(C.TILE_SIZE, C.TILE_SIZE, true, 0);
			maskbitmap.fillRect(maskbitmap.rect, 0);
			maskbitmap.copyPixels(roofBitmapData, convertFromTileIndexToRect(Math.floor(Math.random() * getRoofTileCount())), new Point(0,0));
			
			var i: Image = new Image(maskbitmap);
			var roofBlock: RoofBlock= new RoofBlock(x, y, i);
			add( roofBlock, true );
		}
		
		private function isValidPositionToPlace(p: Point, grid: Array): Boolean {
			
			if (p.y >= grid.length || p.x >= grid[0].length) return false;
			
			if (p.y >= grid.length - 1 && grid[p.y][p.x] == 0) {
				return true;
			}
			
			if (p.y <= grid.length - 1 && grid[p.y][p.x] == 0 && grid[p.y + 1][p.x] == 1) {
				return true;
			}
			
			return false;
		}
		
		private function growSelf(width: uint, height: uint): void {
			
			var grid: Array = [];
			
			for (var i = 0; i < height; i++) {
				grid.push([]);
				for (var j = 0; j < width; j++) {
					grid[i].push(0);
				}
			}
			
			var cursor: Point;
			
			var max: uint = width * height / (1 + 1.5 * Math.random());
			//add( addNewBlock(x, y) );
			
			while (max > 0) {
				//add( addNewBlock(x + Math.random() * 64, y + Math.random() * 64) );
				max--;
				
				cursor = new Point(Math.floor(Math.random() * width), Math.floor(Math.random() * height));
				while (!isValidPositionToPlace(cursor, grid)) {
					if (cursor.y <= height - 1) {
						cursor.y++;
					} else {
						cursor = new Point(Math.floor(Math.random() * width), Math.floor(Math.random() * height));
					}
				}
				
				grid[cursor.y][cursor.x] = 1;
			}
			
			for (var i = 0; i < height; i++) {
				for (var j = 0; j < width; j++) {
					if (grid[i][j] == 1) {
						add( addNewBlock(x + j*C.TILE_SIZE, y + i*C.TILE_SIZE - height * C.TILE_SIZE) );
					}
				}
			}

		}
	}
}