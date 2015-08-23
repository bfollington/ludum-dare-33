package rooms
{
	import assets.A;
	
	import data.MapNode;
	
	import entities.Player;
	import entities.TooHungryMessage;
	
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Draw;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	import volticpunk.V;
	import volticpunk.worlds.Room;
	
	public class WorldMap extends Room
	{
		private var currentPosition: MapNode;
		private var controller: MapController;
		private var name: DragonText;
		private var score: DragonText;
		
		public function WorldMap(fadeIn:Boolean=true)
		{
			super(fadeIn);
			
			addGraphic( name = new DragonText(DragonGame.generateName(), 320, 90, {color: 0x000000}, 16) );
			addGraphic( score = new DragonText(DragonGame.generateName(), 600, 8, {color: 0x000000}) );
			name.x = 320 - name.width / 2;
			addGraphic( new Image(A.Map), 512);
			add( new Player(320, 180, controller = new MapController(320, 180)) );
			
			disableDarknessOverlay();
			
			var lair: MapNode = new MapNode(320, 180);
			var castle: MapNode = new MapNode(71, 86);
			var farm: MapNode = new MapNode(566, 321);
			var village: MapNode = new MapNode(575, 58);			
			var town: MapNode = new MapNode(105, 300);
			
			lair.selected = function(): void {
				
				if (DragonGame.howManyUpgrades() > 0) {
					V.changeRoom(new Lair());
				} else {
					// Handle not allowed condition	
					
					add( new TooHungryMessage(320, 180) );
				}
			};
			town.levelCode = "B";
			castle.levelCode = "A";
			farm.levelCode = "D";
			village.levelCode = "C";
			
			castle.hasBallistas = true;
			town.hasBallistas = true;
			farm.hasBallistas = false;
			village.hasBallistas = false;
			
			
			lair.left = castle;
			lair.right = village;
			lair.down = town;
			
			town.right = lair;
			town.up = castle;
			
			castle.right = lair;
			castle.down = town;
			
			farm.up = village;
			farm.left = lair;
			
			village.down = farm;
			village.left = lair;
			
			currentPosition = lair;
			
			DragonGame.startMusic(A.ChooseYourDragonSound);
		}
		
		private function changePosition(pos: MapNode): void {
			controller.setCenter(pos.position.x, pos.position.y);
			currentPosition = pos;
		}
		
		override public function update(): void {
			super.update();
			
			score.text = V.getGlobal("score").toString();
			
			if (Input.pressed("Jump")) {
				
				if (currentPosition.selected) {
					currentPosition.selected();
				} else {
					V.changeRoom(new Level(currentPosition.levelCode, currentPosition.hasBallistas));	
				}
				
				
			}
			
			if (Input.pressed("Up")) {
				if (currentPosition.up) {
					changePosition(currentPosition.up);
				}
			}
			
			if (Input.pressed("Down")) {
				if (currentPosition.down) {
					changePosition(currentPosition.down);
				}
			}
			
			if (Input.pressed("Left")) {
				if (currentPosition.left) {
					changePosition(currentPosition.left);
				}
			}
			
			if (Input.pressed("Right")) {
				if (currentPosition.right) {
					changePosition(currentPosition.right);
				}
			}
		}
	}
}