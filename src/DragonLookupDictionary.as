package
{
	
	import entities.Building;
	import entities.Tree;
	
	import net.flashpunk.World;
	
	import volticpunk.worlds.LookupDictionary;
	
	public class DragonLookupDictionary extends LookupDictionary
	{
		public function DragonLookupDictionary()
		{
			super();
			
			dict["BuildingSpawn"] = function(n: XML, world: World): void {
				//trace("BUILDING", n.@x, n.@y, n.@width, n.@height);
				world.add( new Building(n.@x, n.@y, n.@width / C.TILE_SIZE, n.@height / C.TILE_SIZE, n.@isCastle == "True") );
			}
				
			dict["TreeSpawn"] = function(n: XML, world: World): void {
				world.add( new Tree(n.@x, n.@y) );
			}
				
			dict["Dragon"] = function(n: XML, world: World): void {
				
			}
		}
		
	}
}