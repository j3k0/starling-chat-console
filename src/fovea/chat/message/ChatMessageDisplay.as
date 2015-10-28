package fovea.chat.message
{
	import starling.display.DisplayObjectContainer;

	/**
	 * Abstract base class for a chat message. </br>
	 * defines  message layout
	 */
	public class ChatMessageDisplay extends DisplayObjectContainer 
	{
		/**
		 * Sets the state
		 */
		public function set state(value:int):void{}
		/**
		 * Defines the message layout
		 * @param consoleWidth:Number - Width of the console used to define positioning of message display objects 
		 */
		public function layout(consoleWidth:Number):void{}
	}
}