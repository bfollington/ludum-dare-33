package rooms
{
	import flash.utils.Dictionary;
	
	import assets.A;
	
	import entities.Animal;
	import entities.Ballista;
	import entities.Pawn;
	import entities.Player;
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Draw;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	import volticpunk.V;
	import volticpunk.util.StringManipulation;
	import volticpunk.util.XMLUtil;
	import volticpunk.worlds.CollisionLayer;
	import volticpunk.worlds.LookupDictionary;
	import volticpunk.worlds.Room;
	import volticpunk.worlds.TileLayer;
	
	public class Level extends Room
	{
		private var tilesetDict: Dictionary;
		private var levelName: String;
		
		private var hasBallistas: Boolean;
		
		[Embed(source = '/assets/levels/DragonWagon.oep', mimeType = 'application/octet-stream')] public static const Project:Class;
		
		public function Level(levelName: String = "C", hasBallistas: Boolean = false)
		{
			super();
			
			this.hasBallistas = hasBallistas;
			
			this.levelName = levelName;
			extractTilesetInfo(XMLUtil.loadXml(Project));
			FP.screen.color = 0x31A2F2;
			
			DragonGame.startMusic(A.IsItABanger2Sound);
		}
		
		/**
		 * Read the project file and build a map of tilset names to file names 
		 * @param projectXml
		 * 
		 */		
		private function extractTilesetInfo(projectXml: XML): void
		{
			tilesetDict = new Dictionary();
			
			for each (var n: XML in projectXml.Tilesets.Tileset) 
			{
				var name: String = n.Name;
				var file: String = n.FilePath;
				// Strip off the file location
				file = file.replace("..\\", "");
				file = file.replace(".png", "");
				file = StringManipulation.formatFilename(file);
				
				tilesetDict[name] = file;
			}
		}
		
		/**
		 * Retrieve the tileset for the given name.
		 * @param s Tileset name
		 * 
		 */		
		private function getTileset(s: String): Class
		{
			var tileset: Class = A.TILES[tilesetDict[s]];
			
			if (tileset == null)
			{
				throw new Error("You seem to be using an unknown tileset, " +
					"try rebuilding assets. Tilesets must have 'tile' " +
					"in their name. Alternatively, this could be due to " +
					"the level you're loading missing a layer");
			}
			
			return tileset;
		}
		
		override public function update():void
		{
			super.update();
			
			if (Input.pressed(Key.R))
			{
				reset();
			}
			
			if (DragonGame.getPlayer().x > levelWidth + 256 || DragonGame.getPlayer().x < -256 || DragonGame.getPlayer().y < -256  || DragonGame.getPlayer().y > levelHeight + 256) {
				V.changeRoom( new WorldMap() );
			}
		}
		
		override public function render():void {
			super.render();
			
			Draw.rect(FP.camera.x + 8, FP.camera.y + 8, (DragonGame.getPlayer().getHealth() / Player.maxHealth) * 624, 8, 0xFF0000);
			Draw.text(V.getGlobal("score").toString(), FP.camera.x + 8, FP.camera.y + 16);
		}
		
		private function reset(): void {
			V.changeRoom(new Level());
		}
		
		override public function begin(): void
		{
			super.begin();
			
			disableDarknessOverlay();
			var map: XML;
			
			var count: int = 0;
			
			map = XMLUtil.loadXml(A.LEVELS[levelName]);
			
			levelWidth = map.@width;
			levelHeight = map.@height;
			
			var collisionLayer: CollisionLayer = new CollisionLayer(map, A.CollisionTileset, map.Collision);
			var e: Entity;
			
			// Extend the collision map to stop the player getting inside the terrain. 
			for (var i: int = 0; i < levelWidth / C.GRID; i++)
			{
				for (var j: int = 0; j < levelHeight / C.GRID; j++)
				{
					if ( collisionLayer.getTilemap().getTile(i, j) && !collisionLayer.getTilemap().getTile(i, j - 1) )
					{
						if (Math.random() > 0.7) {
							V.getRoom().add( new Pawn(i*C.TILE_SIZE, (j - 1) * C.TILE_SIZE) );
						}
						
						if (Math.random() > 0.7) {
							V.getRoom().add( new Animal(i*C.TILE_SIZE, (j - 1) * C.TILE_SIZE) );
						}
						
						if (hasBallistas && Math.random() > 0.9) {
							V.getRoom().add( new Ballista(i*C.TILE_SIZE, (j - 1) * C.TILE_SIZE) );
						}
					}
				}
			}
			
			add( collisionLayer );
			add( new TileLayer(map, getTileset(map.Ground.@tileset), map.Ground, C.LAYER_GROUND) );
			
			var lookupDictionary: LookupDictionary = new DragonLookupDictionary();
			var madePlayer: Boolean = false;
			
			//Load Entities
			for each (var n:XML in map.Entities.*) 
			{
				lookupDictionary.create(n, this);
				if (n.name() == "PlayerStart")
				{
					madePlayer = true;
				}
			}
			
			if (!madePlayer)
			{
				var p: Player = add( new Player(levelWidth / 2, 48) ) as Player;
				V.getRoom().cam.snapToEntity(p);
				V.getRoom().cam.follow(p);
			}
		}
	}
}