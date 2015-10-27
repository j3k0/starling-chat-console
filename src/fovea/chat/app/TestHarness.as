package fovea.chat.app
{	
	import flash.geom.Point;
	
	import fovea.chat.ChatConsole;
	import fovea.chat.ChatUtil;
	import fovea.chat.app.test_data.Server;
	import fovea.chat.interfaces.IChatTheme;
	import fovea.chat.message.ChatMessageData;
	
	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.Color;

	public class TestHarness extends Sprite
	{
		private var _chatConsole:ChatConsole;
		private var _server:Server;
		private var _openButton:Quad;
		
		public function TestHarness()
		{}
		
		public function init(theme:IChatTheme):void
		{
			var dim:Point = ChatUtil.stageDimensions(this, theme.isMobile);
			var quad:Quad = new Quad(dim.x, dim.y, Color.BLACK);
			
			_server = new Server();
			_server.addEventListener(Server.MESSAGE_SENT, onMessageSent);
			
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
		
		private function onMessageSent(event:Event):void
		{
			var chatMessageData:ChatMessageData = 
				new ChatMessageData("Jacob", "http://www.thotkraft.com/test/anime_head_02.jpg", event.data.message, "9:46"); 
			_chatConsole.addMessageData(chatMessageData);
		}
	}
}
