package fovea.chat.app.test_data
{
	import fovea.chat.interfaces.IChatServer;
	import fovea.chat.message.ChatMessage;
	import fovea.chat.message.ChatMessageData;
	import fovea.chat.message.ChatMessageDisplayConfig;
	
	import starling.events.EventDispatcher;
	import starling.utils.Color;

	public class Server extends EventDispatcher implements IChatServer 
	{
		private var _listenerFucntions:Vector.<Function>;
		
		public static const MESSAGE_SENT:String = "MESSAGE_SENT";
		public function Server()
		{
			_listenerFucntions = new Vector.<Function>();
		}
		
		// initiate sending a message
		public function send(message:String):void
		{
			dispatchEventWith(MESSAGE_SENT, false, {message:message});
		}
		
		public function test():void
		{
			for(var i:int = 0; i < _listenerFucntions.length; ++i)
			{
				_listenerFucntions[i]();
			}
		}
		
		// return the list of messages on the chat room
		public function getData():Vector.<ChatMessage>
		{
			var messages:Vector.<ChatMessage> = new Vector.<ChatMessage>();
			
			messages.push(new ChatMessage(
				new ChatMessageData(
					"James", "http://www.thotkraft.com/test/anime_head_01.jpg", "Beat cha", "11:00"), 
					new ChatMessageDisplayConfig(Color.WHITE, 0)));
			messages.push(
				new ChatMessage(
					new ChatMessageData(
						"William", "http://www.thotkraft.com/test/anime_head_02.jpg", "This Time", "11:01"), 
						new ChatMessageDisplayConfig(Color.WHITE, 0)));
			messages.push(
				new ChatMessage(
					new ChatMessageData(
						null, null, "Some dude wants to play", "11:01"), 
					new ChatMessageDisplayConfig(Color.WHITE, 0)));
			/*
			messages.push(new ChatMessage(
				new ChatMessageData(
					"Bakugan", "http://www.thotkraft.com/test/anime_head_01.jpg", "14", "11:00"), 
				new ChatMessageDisplayConfig(Color.WHITE, 0)));
			messages.push(
				new ChatMessage(
					new ChatMessageData(
						"Daigon", "http://www.thotkraft.com/test/anime_head_02.jpg", "13", "11:01"), 
					new ChatMessageDisplayConfig(Color.WHITE, 0)));
			
			messages.push(new ChatMessage(
				new ChatMessageData(
					"Bakugan", "http://www.thotkraft.com/test/anime_head_01.jpg", "12", "11:00"), 
				new ChatMessageDisplayConfig(Color.WHITE, 0)));
			messages.push(
				new ChatMessage(
					new ChatMessageData(
						"Daigon", "http://www.thotkraft.com/test/anime_head_02.jpg", "11", "11:01"), 
					new ChatMessageDisplayConfig(Color.WHITE, 0)));
			
			messages.push(new ChatMessage(
				new ChatMessageData(
					"Bakugan", "http://www.thotkraft.com/test/anime_head_01.jpg", "10", "11:00"), 
				new ChatMessageDisplayConfig(Color.WHITE, 0)));
			messages.push(
				new ChatMessage(
					new ChatMessageData(
						"Daigon", "http://www.thotkraft.com/test/anime_head_02.jpg", "9", "11:01"), 
					new ChatMessageDisplayConfig(Color.WHITE, 0)));
			
			messages.push(new ChatMessage(
				new ChatMessageData(
					"Bakugan", "http://www.thotkraft.com/test/anime_head_01.jpg", "8", "11:00"), 
				new ChatMessageDisplayConfig(Color.WHITE, 0)));
			messages.push(
				new ChatMessage(
					new ChatMessageData(
						"Daigon", "http://www.thotkraft.com/test/anime_head_02.jpg", "7", "11:01"), 
					new ChatMessageDisplayConfig(Color.WHITE, 0)));
			
			messages.push(new ChatMessage(
				new ChatMessageData(
					"Bakugan", "http://www.thotkraft.com/test/anime_head_01.jpg", "6", "11:00"), 
				new ChatMessageDisplayConfig(Color.WHITE, 0)));
			messages.push(
				new ChatMessage(
					new ChatMessageData(
						"Daigon", "http://www.thotkraft.com/test/anime_head_02.jpg", "5", "11:01"), 
					new ChatMessageDisplayConfig(Color.WHITE, 0)));
			
			messages.push(new ChatMessage(
				new ChatMessageData(
					"Bakugan", "http://www.thotkraft.com/test/anime_head_01.jpg", "4", "11:00"), 
				new ChatMessageDisplayConfig(Color.WHITE, 0)));
			messages.push(
				new ChatMessage(
					new ChatMessageData(
						"Daigon", "http://www.thotkraft.com/test/anime_head_02.jpg", "3", "11:01"), 
					new ChatMessageDisplayConfig(Color.WHITE, 0)));
			
			messages.push(new ChatMessage(
				new ChatMessageData(
					"Bakugan", "http://www.thotkraft.com/test/anime_head_01.jpg", "2", "11:00"), 
				new ChatMessageDisplayConfig(Color.WHITE, 0)));
			messages.push(
				new ChatMessage(
					new ChatMessageData(
						"Daigon", "http://www.thotkraft.com/test/anime_head_02.jpg", "1", "11:01"), 
					new ChatMessageDisplayConfig(Color.WHITE, 0)));
			//*/
			return messages;
		}
		
		// listeners functions will be called without arguments
		// when data is updated.
		public function addListener(f:Function):void
		{
			_listenerFucntions.push(f);
		}
		
		public function removeListener(f:Function):void
		{
	
		}
	}
}