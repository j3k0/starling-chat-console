package 
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.geom.Rectangle;
	
	import starling.core.Starling;

	public class App extends Sprite
	{
		private var _starling:Starling;
		public function App()
		{
			var viewPort:Rectangle = new Rectangle(0,0, stage.fullScreenWidth, stage.fullScreenHeight); 
			
			// support autoOrients
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			_starling = new Starling(AppTestHarness, stage, viewPort);
			_starling.start();
			_starling.antiAliasing = 0;
		}
	}
}