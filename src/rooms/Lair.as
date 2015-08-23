package rooms
{
	import assets.A;
	
	import entities.Player;
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	import volticpunk.V;
	import volticpunk.entities.VEntity;
	import volticpunk.util.Constrain;
	import volticpunk.util.Range;
	import volticpunk.worlds.Room;
	
	public class Lair extends Room
	{
		private var upgrades: Array;
		private var displayEntities: Array;
		
		private var selected: int = 0;
		
		private const options = [
			{
				image: A.SegmentCard1Image,
				config: {claws: true}
			},
			{
				image: A.SegmentCard2Image,
				config: {wings: true}
			},
			{
				image: A.SegmentCard3Image,
				config: {armour: true}
			},
			{
				image: A.SegmentCard4Image,
				config: {fire: true}
			},
			{
				image: A.SegmentCard5Image,
				config: {bomb: true}
			},
			{
				image: A.SegmentCard6Image,
				config: {heart: true},
				func: function(): void {
					V.setGlobal("health", Math.min(Player.maxHealth, V.getGlobal("health") + 333));
				}
			}
		];
		
		public function Lair(fadeIn:Boolean=true)
		{
			super(fadeIn);

			
			displayEntities = [];
			
			addGraphic( A.LairImage );
			
			disableDarknessOverlay();
			
			addGraphic( A.SegmentTitleImage, 0, 0, 0 );
			
			generateUpgradesArray();
			
			for (var i: uint = 0; i < 3; i++) {
				displayEntities.push( add( new VEntity(80 + i * 192, 64 )) );
			}
			
			setEntityImages();
			
		}
		
		private function generateUpgradesArray(): void {
			upgrades = [];
			
			while (upgrades.length < 3) {
				var index: uint = FP.rand(options.length);
				while (upgrades.indexOf(index) >= 0) {
					index = FP.rand(options.length);
				}
				
				upgrades.push(index);
			}
		}
		
		private function setEntityImages(): void {
			for (var i: uint = 0; i < 3; i++) {
				displayEntities[i].graphic = options[upgrades[i]].image;
			}
		}
		
		private function selectEntity(): void {
			for each (var e: Entity in displayEntities) {
				(e.graphic as Image).alpha = 0.5;
				(e.graphic as Image).y = 64;
			}
			
			(displayEntities[selected].graphic as Image).alpha = 1;
			(displayEntities[selected].graphic as Image).y = 48;
		}
		
		override public function update():void {
			super.update();
			
			if (Input.pressed("Left")) {
				selected--;	
			}
			
			if (Input.pressed("Right")) {
				selected++;
			}
			
			selected = Constrain.constrain(selected, 0, 2);
			selectEntity();
			
			if (Input.pressed("Jump")) {
				if (options[upgrades[selected]].func) {
					options[upgrades[selected]].func();
				}
				
				var list: Array = V.getReference("segment_list") as Array;
				list.push(options[upgrades[selected]].config);
			
				
				if (DragonGame.howManyUpgrades() > 0) {
					generateUpgradesArray();
					setEntityImages();
				} else {
					V.changeRoom(new WorldMap());	
				}
				
			}
		}
	}
}