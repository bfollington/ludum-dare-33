package entities
{
	import flash.geom.Point;
	
	import assets.A;
	
	import entities.particles.Bomb;
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.masks.Hitbox;
	
	import volticpunk.V;
	import volticpunk.components.PlatformerMovement;
	import volticpunk.entities.VEntity;
	import volticpunk.util.Angle;
	
	public class PlayerSegment extends VEntity
	{
		private var follow: Entity;
		private var physics: PlatformerMovement;
		
		public var wings: Boolean = false;
		public var fire: Boolean = false;
		public var claws: Boolean = false;
		public var armour: Boolean = false;
		public var bomb: Boolean = false;
		public var heart: Boolean = false;
		
		private var damageTimeout: uint = 0;
		private var spritemap: Spritemap;
		private var image: Image;
		
		private var heartPulseCalc: Number = 0;
		
		private var canDropBomb: Boolean = false;
		
		public function PlayerSegment(x:Number=0, y:Number=0, frame: uint = 1, obj: Object = null)
		{
			super(x, y, null, mask);
			
			mask = new Hitbox(16, 16, 0, -8);
			
			if (obj != null) {
				wings = obj.wings;
				claws = obj.claws;
				fire = obj.fire;
				armour = obj.armour;
				bomb = obj.bomb;
				heart = obj.heart;
			}
			
			spritemap = new Spritemap(A.Dragon, 32, 32);
			spritemap.add("Mid", [frame], 1, true);
			spritemap.play("Mid");
			spritemap.originX = 8;
			spritemap.originY = 16;
			
			if (wings) {
				image = new Image(A.DragonBits5);
				image.originX = 23;
				image.originY = 15;
			}
			
			if (claws) {
				image = new Image(A.DragonBits4);
			}
			
			if (fire) {
				image = new Image(A.DragonBits7);
			}
			
			if (armour) {
				image = new Image(A.DragonBits6);
			}
			
			if (bomb) {
				image = new Image(A.DragonBits8);
				canDropBomb = true;
			}
			
			if (heart) {
				image = new Image(A.DragonBits10);
			}
			
			if (!wings && image) {
				image.originX = 8;
				image.originY = 16;	
			}
			
			if (image) {
				graphic = new Graphiclist(spritemap, image);	
			} else {
				graphic = new Graphiclist(spritemap);
			}
			
			addComponent( physics = new PlatformerMovement() );
			physics.setCollisionTypes(["level"]);
			physics.acceleration.y = 0.2;
		}
		
		public function dropBomb(): void {
			if (!bomb) {
				return;
			}
			
			log("BOMB DROPPED");
			
			V.getRoom().add( new Bomb(x, y) );
			
			canDropBomb = false;
			(graphic as Graphiclist).remove(image);
			image = new Image(A.DragonBits9);
			image.originX = 8;
			image.originY = 16;	
			(graphic as Graphiclist).add( image );
			
		}
		
		public function setPrevious(prev: Entity): void {
			follow = prev;
		}
		
		public function hasWings(): Boolean {
			return wings;
		}
		
		public function hasFire(): Boolean {
			return fire;
		}
		
		public function hasClaws(): Boolean {
			return claws;
		}
		
		public function setFrame(frame: uint, origin: Point = null): void {
			spritemap.setFrame(frame, 0);
			
			if (origin != null) {
				spritemap.originX = origin.x;
				spritemap.originY = origin.y;
			}
		}
		
		override public function update(): void {
			super.update();
			
			var dist: Number = FP.distance(x, y, follow.x, follow.y);
			var angle: Number = FP.angle(x, y, follow.x, follow.y);
			
			if (damageTimeout > 0) {
				damageTimeout--;
			}
			
			spritemap.scaleX = Math.max(dist / 24.0, 1);
			
			var xDist: Number = x - follow.x;
			if (xDist > 8) {
				physics.velocity.x = -( (x - follow.x) - 8) / 6.0;	
			} else if (xDist < -8) {
				physics.velocity.x = -( (x - follow.x) + 8) / 6.0;	
			} else {
				physics.velocity.x = 0;
			}
			
			var yDist: Number = y - follow.y;
			if (yDist > 8) {
				physics.velocity.y = -( (y - follow.y) - 8) / 6.0;	
			} else if (yDist < -8) {
				physics.velocity.y = -( (y - follow.y) + 8) / 6.0;	
			} else {
				physics.velocity.y = 0;
			}
			
			if (collide("level", x, y)) {
				physics.velocity.y *= -0.75;
			}
			
			spritemap.angle = angle;
			if (!wings && image) image.angle = angle;
			if (wings && image) image.angle = angle + DragonGame.getPlayer().wingsAngle;
			
			heartPulseCalc += 0.2;
			
			if (heart) {
				image.scale = 0.25 * Math.sin(heartPulseCalc) + 1;
			}
			
			if (angle > 90 && angle < 270) {
				spritemap.scaleY = -1;
				if (image) image.scaleY = -1;
			} else {
				spritemap.scaleY = 1;
				if (image) image.scaleY = 1;
			}
			
			var block: Block;
			if ( (block = collide("block", x, y) as Block) && damageTimeout == 0) {
				block.receiveDamage();
				
				if (hasClaws) {
					block.receiveDamage();
					block.receiveDamage();	
				}
				
				damageTimeout = 15;
			}
			
			var arrow: Arrow;
			if (arrow = collide("arrow", x, y) as Arrow) {
				
				if (!armour) DragonGame.getPlayer().hitByArrow(arrow);
			}
			
//			if (follow is PlayerSegment) {
//				var segment: PlayerSegment = follow as PlayerSegment;
//				segment.physics.acceleration
//			}
		}
	}
}