package 
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.geom.Rectangle;
	
	import fovea.chat.app.TestHarness;
	import fovea.chat.app.test_data.ThemeMobile;
	
	import starling.core.Starling;
	import starling.events.Event;
	
	public class App extends Sprite
	{
		private var _starling:Starling;
		public function App()
		{
			var viewPort:Rectangle = new Rectangle(0,0, stage.fullScreenWidth, stage.fullScreenHeight); 
			
			// support autoOrients
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			_starling = new Starling(TestHarness, stage, viewPort);
			_starling.start();
			_starling.antiAliasing = 0;
			_starling.addEventListener(Event.ROOT_CREATED, onRootCreated);
		}
		
		/**
		 * Root Created call back
		 */
		private function onRootCreated(event:Event):void
		{
			// Initialize the testHarness theme
			(_starling.root as TestHarness).init(new ThemeMobile());
		}
	}
}