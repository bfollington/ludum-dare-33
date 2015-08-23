package
{
	import net.flashpunk.graphics.Text;
	
	public class DragonText extends Text
	{
		[Embed(source="assets/apple.ttf",
        fontName = "Apple ][",
        mimeType = "application/x-font",
        advancedAntiAliasing="true",
        embedAsCFF = "false")] private var myEmbeddedFont:Class;
		
		public function DragonText(text:String, x:Number=0, y:Number=0, options:Object=null, size: int = 8)
		{
			super(text, x, y, options);
			
			this.font = "Apple ][";
			this.size = size;
		}
	}
}