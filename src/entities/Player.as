package entities
{
	import flash.geom.Point;
	
	import assets.A;
	
	import entities.particles.Fire;
	import entities.particles.Fireball;
	import entities.particles.Smoke;
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.masks.Hitbox;
	import net.flashpunk.utils.Draw;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	import rooms.GameOver;
	
	import volticpunk.V;
	import volticpunk.components.Delayer;
	import volticpunk.components.PlatformerMovement;
	import volticpunk.entities.Group;
	import volticpunk.entities.util.Delayer;
	import volticpunk.util.Angle;
	import volticpunk.util.Constrain;
	
	public class Player extends Group
	{
		private var segments: Vector.<PlayerSegment>;
		public var angle: Number = 0;
		private var physics: PlatformerMovement;
		
		private var numWingSegments: uint = 0;
		private var numFireSegments: uint = 0;
		private var numArmourSegments: uint = 0;
		
		private var bouncing: Boolean = false;
		private var delayer: volticpunk.components.Delayer;
		
		public static var maxHealth: Number = 1000;
		private var health: Number;
		
		public var wingsAngle: Number = 0;
		private var fireCooldown: Number = 200;
		
		private var controller: Controller;
		
		public function Player(x:Number=0, y:Number=0, controlledBy: Controller = null)
		{
			super(x, y);
			
			//graphic = Image.createRect(32, 32);
			mask = new Hitbox(16, 16, -8, -8);
			
			graphic = A.DragonHeadImage;
			getImage().originX = 8;
			getImage().originY = 16;
			
			health = V.getGlobal("health") || maxHealth;
			
			segments = new Vector.<PlayerSegment>();
			
			if (V.getReference("segment_list") == null) {
				for (var i: uint = 0; i < 3; i++) {
					newSegment({wings: i == 2});
				}
			} else {
				var list: Array = V.getReference("segment_list") as Array;
				list = list.slice().reverse();
				for each (var obj: Object in list) {
					segments.push( new PlayerSegment(x + i * 16, y, 1, obj) );
					add( segments[segments.length - 1] );
				}
			}
			
			setLinksInSegments();
			
			physics = new PlatformerMovement();
			if (controlledBy) {
				controller = controlledBy;
				controller.setPlayer(this);
			} else {
				addComponent( physics );
			}
			
			
			physics.setCollisionTypes(["level"]);
			physics.setLandingCallback( hitFloor );
			physics.setWallCallback( hitWall );
			
			addComponent( delayer = new volticpunk.components.Delayer(0.25, function(): void { bouncing = false; }, false) );
				
		}
		
		public function newSegment(config: Object): void {
			if (V.getReference("segment_list") == null) {
				V.storeReference("segment_list", []);
			}
			
			(V.getReference("segment_list") as Array).push(config);
			var list: Array = (V.getReference("segment_list") as Array);
			addSegment( new PlayerSegment(x, y, 1, config), 0 );
		}
		
		public function hitByArrow(arrow: Arrow): void {
			health -= Math.max( (arrow.getDamage() - numArmourSegments/2), 1);
			arrow.removeFromWorld();
			
			V.setGlobal("health", health);
			var c: Class = volticpunk.entities.util.Delayer;
			
			if (health < 0) {
				A.DEADSound.play();
				
				for each (var segment: PlayerSegment in segments) {
					V.getRoom().add( new Smoke(segment.x, segment.y) );
				}
				
				V.getRoom().add( new c(1.5, function(): void {
					V.changeRoom(new GameOver());
				}) );
			}
			
			A.HitHurtSound.play();
		}
		
		private function hitFloor(): void {
			if (physics.velocity.y > 1) {
				V.getRoom().cam.screenshake(physics.velocity.y * 3, 0.5);
			}
		}
		
		private function hitWall(): void {
			if (Math.abs(physics.velocity.x) > 1) {
				V.getRoom().cam.screenshake(Math.abs(physics.velocity.x) * 3, 0.5);
			}
		}
		
		public function addSegment(segment: PlayerSegment, index: uint): void {
			for (var i = segments.length; i > index; i--) {
				segments[i] = segments[i - 1];
			}
			
			segments[index] = segment;
			add(segment, true);
			setLinksInSegments();
		}
		
		public function setLinksInSegments(): void {
			
			var last: Entity = this;
			var layer: int = 128;
			last.layer = layer;
			numWingSegments = 0;
			numFireSegments = 0;
			numArmourSegments = 0;
			
			for each (var seg: PlayerSegment in segments) {
				seg.setPrevious(last);
				seg.setFrame(1,  new Point(8, 16));
				layer++;
				seg.layer = layer;
				
				if (seg.hasWings()) {
					numWingSegments++;
				}
				
				if (seg.hasFire()) {
					numFireSegments++;
				}
				
				if (seg.armour) {
					numArmourSegments++;
				}
				
				last = seg;
			}
			
			(last as PlayerSegment).setFrame(0, new Point(12, 16));
		}
		
		public function getHealth(): Number {
			return health;
		}
		
		override public function update(): void {
			super.update();
			
			if (controller) {
				controller.update();
			} else {
				
				if (health > 0) {
					if (Input.check("Left")) {
						angle += 3;
					}
					
					if (Input.check("Right")) {
						angle -= 3;
					}
					
					if (Input.check("Up") && !bouncing) {
						FP.angleXY(physics.velocity, angle, 0.5 * (numWingSegments / 2.0), Constrain.constrain(physics.velocity.x, -4, 4), Constrain.constrain(physics.velocity.y, -4, 4));
						wingsAngle -= 2;
					}
					
					if (!bouncing) {
						FP.angleXY(physics.velocity, angle, 0.1, Constrain.constrain(physics.velocity.x, -4, 4), Constrain.constrain(physics.velocity.y, -4, 4));
						wingsAngle -= 0.2;
					}
					
					
					if (Input.check("Jump") && !bouncing) {
						FP.angleXY(physics.velocity, angle, 3 * (numWingSegments / 4.0), Constrain.constrain(physics.velocity.x, -5, 5), Constrain.constrain(physics.velocity.y, -5, 5));
						wingsAngle -= 6;
					}
					
					if (Input.pressed(Key.C)) {
						for each (var seg: PlayerSegment in segments) {
							seg.dropBomb();
						}
					}
					
					if (Input.pressed("Dash")) {
						var p: Point = new Point();
						FP.angleXY(p, angle, 2);
						
						if (fireCooldown > 200) {
							A.SHOOTSound.play();
							V.getRoom().add( new Fireball(Math.max(numFireSegments, 1), x + p.x * 4, y + p.y * 4, p.x + physics.velocity.x, p.y + physics.velocity.y ) );
							fireCooldown -= 25;
						}				
					}
				} else {
					physics.velocity.y = 2;
				}
				
			}
			
			
			
			var block: Block;
			if (block = collide("block", x, y) as Block) {
				
				if (physics.velocity.length < 4) {
					trace("bounce me");
					physics.velocity.x *= -2;
					physics.velocity.y *= -2;
					bouncing = true;
					delayer.reset();
					
					A.COLLIDESound.play();
				}
				
				block.receiveDamage();
			}
			
			var person: Person;
			if (person = collide("person", x, y) as Person) {
				
				person.getPlatformMovement().velocity.y = -5;
				person.hurtMe(Math.max(1, numFireSegments));
			}
			
			var arrow: Arrow;
			if (arrow = collide("arrow", x, y) as Arrow) {
				
				hitByArrow(arrow);
			}
			
			physics.velocity.x /= 1.1;
			physics.velocity.y /= 1.1;
			physics.acceleration.y = 0.2;
			
			while (angle > 360) angle -= 360;
			while (angle < 0) angle += 360;
			getImage().angle = angle;
			
			if (angle > 90 && angle < 270) {
				getImage().scaleY = -1;
			} else {
				getImage().scaleY = 1;
			}
			
			if (fireCooldown < 250) {
				fireCooldown += Math.max(numFireSegments / 2, 1);
			}
			
		}
	}
}