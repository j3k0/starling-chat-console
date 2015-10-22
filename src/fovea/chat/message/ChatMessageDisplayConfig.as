package fovea.chat.message
{
	import flash.geom.Rectangle;

	/**
	 * Configuration for a chat messages display </br>
	 * <ul>
	 * 		<li>backgroundColor - the message background color </li>
	 * 		<li>backgroundAlpha - the message background backgroundAlpha </li>
	 * </ul>
	 */
	public class ChatMessageDisplayConfig
	{
		public var backgroundColor:uint;
		public var backgroundAlpha:Number;
		
		public function ChatMessageDisplayConfig(backgroundColor:uint, backgroundAlpha:Number)
		{
			this.backgroundColor = backgroundColor;
			this.backgroundAlpha = backgroundAlpha;
		}
	}
}