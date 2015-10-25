package fovea.chat.app
{	
	import flash.filesystem.File;
	import flash.geom.Point;
	
	import fovea.chat.ChatConsole;
	import fovea.chat.ChatUtil;
	import fovea.chat.app.test_data.Server;
	import fovea.chat.interfaces.IChatTheme;
	
	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.AssetManager;
	import starling.utils.Color;

	public class TestHarness extends Sprite
	{
		private var _chatConsole:ChatConsole;
		private var _server:Server;
		private var _openButton:Quad;
		private var _assetManager:AssetManager;
		
		public function TestHarness()
		{}
		
		public function init(theme:IChatTheme):void
		{
			var appDir:File = File.applicationDirectory;
			_assetManager = new AssetManager(1);
			_assetManager.enqueue(appDir.resolvePath("loadFailedIcon.png"));
			_assetManager.enqueue(appDir.resolvePath("loadingImage.png"));
			
			_assetManager.loadQueue(function(ratio:Number):void
			{
				if(ratio == 1)
					start(theme);
			});
		}
		
		private function start(theme:IChatTheme):void
		{
			var dim:Point = ChatUtil.stageDimensions(this, theme.isMobile);
			var quad:Quad = new Quad(dim.x, dim.y, Color.BLACK);
			
			_server = new Server(_assetManager.getTexture("loadFailedIcon"), _assetManager.getTexture("loadingImage"));
			
			_openButton = new Quad(40,40,Color.GREEN);
			_openButton.x = 10;
			_openButton.y = 10;
			_openButton.addEventListener(TouchEvent.TOUCH, onOpenButtonTouched);
			
			_chatConsole = new ChatConsole(_server, theme);
			_chatConsole.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			addChild(quad);
			addChild(_chatConsole);
			addChild(_openButton);
		}
		
		private function onAddedToStage(event:Event):void
		{
			_server.dataUpdated();
		}
		
		private function onOpenButtonTouched(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(event.currentTarget as DisplayObject);
			if(!touch)
				return;

			switch(touch.phase)
			{
				case TouchPhase.ENDED:
					_chatConsole.show();
					break;
			}
		}
	}
}
