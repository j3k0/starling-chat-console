package fovea.chat.app.test_data
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import fovea.chat.interfaces.IChatServer;
	import fovea.chat.message.ChatMessage;
	import fovea.chat.message.ChatMessageData;
	import fovea.chat.message.ChatMessageDisplayConfig;
	
	import starling.events.EventDispatcher;
	import starling.utils.Color;

	public class Server extends EventDispatcher implements IChatServer 
	{
		private var _listenerFunctions:Vector.<Function>;
		private var _messages:Vector.<ChatMessage>;
		private var _messageTimer:Timer;
		
		public static const MESSAGE_SENT:String = "MESSAGE_SENT";
		
		private static const TEST_IMAGES:Array = 
			[
				"http://www.thotkraft.com/test/anime_head_01.jpg",
				"http://www.thotkraft.com/test/anime_head_02.jpg"
			];
		
		private static const TEST_NAMES:Array = 
			[
				"Steve",
				"Tony",
				"Clint",
				"Bruce",
				"Nick",
				"Natasia",
				"Hank",
				"Wanda",
				"T'Challa",
				"Simon",
				"Carol",
				"Jennifer",
				"Logan",
				"Henry",
			];
		
		private static const TEST_MESSAGES:Array = 
			[
				"I want to play again",
				"Good Job",
				"Avengers Assemble",
				"GG, Next time Im gonna win",
				"Anybody want to join a campaign",
				"Awesome",
				"I let you win",
				"Bruce, I cant believe you won",
				"Natasha, lets play a game",
				"T'Challa Good game, lets play again",
				"This game is awesome",
				"I need four for a campaign",
				"Tony where'd you get your armor",
				"Simon you red eye costume is awesome farming or bought."
			];
		
		private static const TEST_SERVER_MESSAGES:Array = 
			[
				"Steve wants to play a game",
				"Tony wants to play a game",
				"Clint wants to play a game",
				"Bruce wants to play a game",
				"Nick wants to play a game",
				"Natasia wants to play a game",
				"Hank wants to play a game",
				"Wanda wants to play a game",
				"T'Challa wants to play a game",
				"Simon wants to play a game",
				"Carol wants to play a game",
				"Jennifer wants to play a game",
				"Logan wants to play a game",
				"Henry wants to play a game",
			];
		
		public function Server()
		{
			_listenerFunctions = new Vector.<Function>();
			_messageTimer = new Timer(5000);
			_messageTimer.addEventListener(TimerEvent.TIMER, onMessageTimer);
			_messageTimer.start();
			
			_messages = new Vector.<ChatMessage>();
			_messages.push(generateTestMessage());
			_messages.push(generateTestMessage());
			_messages.push(generateTestMessage());
		}
		
		// initiate sending a message
		public function send(id:String, message:String):void
		{
			// theres a 75% probability that the message will be added.
			if(Math.random() * 100 > 25)
			{
				_messages.push(
					new ChatMessage(new ChatMessageData(id, "Jacob", "http://www.thotkraft.com/test/anime_head_02.jpg", message, "9:46")));
				dataUpdated();
			}
		}
		
		private function getTimeString():String
		{
			var date:Date = new Date();
			var hrs:String = date.getHours().toString(); 
			var minutes:String = date.getMinutes().toString();
			
			if(minutes.length == 1)
				minutes = "0"+minutes;
			return hrs+":"+minutes;
		}
		
		private function onMessageTimer(event:TimerEvent):void
		{
			_messages.push(generateTestMessage());
			dataUpdated();
		}
		
		private function generateTestMessage():ChatMessage
		{
			var data:ChatMessageData = null;
			var time:String = getTimeString();
			
			if(Math.random() * 100 < 25)
			{
				var serverMessageIdx:int = Math.floor(Math.max(0, Math.random() * TEST_SERVER_MESSAGES.length - .1));
				data = new ChatMessageData(
					"fakeID",
					null,
					null,
					TEST_SERVER_MESSAGES[serverMessageIdx],
					time
				);
			}else{
				var userMessageIdx:int = Math.floor(Math.max(0, Math.random() * TEST_MESSAGES.length - .1));
				var userNameIdx:int = Math.floor(Math.max(0, Math.random() * TEST_NAMES.length - .1));
				var userImageIdx:int = Math.floor(Math.max(0, Math.random() * TEST_IMAGES.length - .1));
				data = new ChatMessageData(
					"fakeID",
					TEST_NAMES[userNameIdx],
					TEST_IMAGES[userImageIdx],
					TEST_MESSAGES[userMessageIdx],
					time
				);
			}
			
			return new ChatMessage(data, new ChatMessageDisplayConfig(Color.WHITE, 0));
		}
			
		
		public function dataUpdated():void
		{
			for(var i:int = 0; i < _listenerFunctions.length; ++i)
			{
				_listenerFunctions[i]();
			}
		}
		
		// return the list of messages on the chat room
		public function getData():Vector.<ChatMessage>
		{
			return _messages;
		}
		
		// listeners functions will be called without arguments
		// when data is updated.
		public function addListener(f:Function):void
		{
			_listenerFunctions.push(f);
		}
		
		public function removeListener(f:Function):void
		{
	
		}
	}
}