package fovea.chat.themes
{
	public class ThemeWeb extends DefaultChatTheme
	{
		/**
		 * Define if the platform is mobile
		 */
		override public function get isMobile():Boolean
		{
			return false;
		}
		
		/**
		 * Width of the chat console, defines where the chat rests when opened.
		 */
		override public function get width():Number
		{
			return 400;
		}
	}
}