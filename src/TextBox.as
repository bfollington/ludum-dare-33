package {
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	public class TextBox extends Entity {
		
		//True if this text box is reading data.
		private var _reading: Boolean;
		
		//The text being displayed by this text box.
		private var displayText: DragonText;
		
		//Initialize a new TextBox. Only one text box should be reading at a time.
		public function TextBox(reading: Boolean, text: String = "", x: Number = 0, y: Number = 0) {
			displayText = new DragonText(text);
			this.reading = reading;
			super(x, y, displayText);
			width = displayText.width;
			height = displayText.height;
		}
		
		override public function update():void {
			if (_reading) {
				displayText.text = Input.keyString;
				width = displayText.width;
				height = displayText.height;
			}
			if (Input.mouseReleased && collidePoint(x, y, Input.mouseX, Input.mouseY)) {
				//Setting reading to false for all other TextBoxes and reading to true
				//for this one.
				if (_reading != true) {
					enableInput();
				}
			}
		}
		
		override public function added():void {
			//Add this element into the all_boxes list.
			if (_reading) {
				enableInput();
			}
		}
		
		public function enableInput():void {
			_reading = true;
			//What is currently in this buffer is transferred to the keyString.
			//This makes backspaces and such work correctly.
			Input.keyString = displayText.text;
		}
		
		public function get text():String { return displayText.text; }
		public function set text(str:String):void { displayText.text = str; }
		
		public function get reading():Boolean { return _reading; }
		public function set reading(reading:Boolean):void {
			if (reading != _reading) {
				_reading = reading;
				//What is currently in this buffer is transferred to the keyString.
				//This makes backspaces and such work correctly.
				if (_reading) {
					enableInput();
				}
			}
		}
	}
}
