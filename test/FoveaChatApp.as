package 
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.geom.Rectangle;
    import fovea.chat.app.TestHarness;
	
	import starling.core.Starling;

	public class FoveaChatApp extends Sprite
	{
		private var _starling:Starling;
		public function FoveaChatApp()
		{
			var viewPort:Rectangle = new Rectangle(0,0, stage.fullScreenWidth, stage.fullScreenHeight); 
			
			// support autoOrients
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			_starling = new Starling(TestHarness, stage, viewPort);
			_starling.start();
			_starling.antiAliasing = 0;
		}
	}
}
