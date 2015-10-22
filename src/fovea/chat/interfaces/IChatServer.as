package fovea.chat.interfaces
{
	import fovea.chat.message.ChatMessage;

	public interface IChatServer
	{
		// initiate sending a message
		function send(message:String):void;
		
		// return the list of messages on the chat room
		function getData():Vector.<ChatMessage>;
		
		// listeners functions will be called without arguments
		// when data is updated.
		function addListener(f:Function):void;
		function removeListener(f:Function):void;
	}
}