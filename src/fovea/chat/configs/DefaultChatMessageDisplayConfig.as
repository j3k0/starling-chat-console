package fovea.chat.configs
{
	import fovea.chat.message.ChatMessageDisplayConfig;
	
	import starling.utils.Color;

	/**
	 * Default Chat message config</br>
	 * Implemented when a config isnt defined.
	 */
	public class DefaultChatMessageDisplayConfig extends ChatMessageDisplayConfig
	{
		/**
		 * Instantiate a 
		 */
		public function DefaultChatMessageDisplayConfig()
		{
			super(Color.WHITE, 0);
		}
	}
}