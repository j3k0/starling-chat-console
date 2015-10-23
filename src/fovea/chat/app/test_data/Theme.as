package fovea.chat.app.test_data
{
	import fovea.chat.interfaces.IChatTheme;
	import starling.utils.Color;

	public class Theme implements IChatTheme
	{	
		/**
		 * Define if the platform is mobile
		 */
		public function get isMobile():Boolean
		{
			return true;
		}
		
		/** 
		 *  Background Color of the chat console window 
		 */
		public function get backgroundColor():uint
		{
			return Color.WHITE;
		}
		
		/**
		 * Width of the chat console, defines where the chat rests when opened.
		 */
		public function get width():Number
		{
			return 800;
		}
		
		/** 
		 * Length of time for the open and close transition animations, (in Seconds) 
		 */
		public function get openCloseTransitionTime():Number
		{
			return .25;
		}
		
		
		/**
		 * Type of Ease used in the open and close animations
		 * <ul>
		 * 	<li>linear</li>
		 * 	<li>easeIn</li>
		 * 	<li>easeOut</li>
		 * 	<li>easeInOut</li>
		 * 	<li>easeOutIn</li>
		 * 	<li>easeInBack</li>
		 * 	<li>easeOutBack</li>
		 * 	<li>easeInOutBack</li>
		 * 	<li>easeOutInBack</li>
		 * 	<li>easeInBounce</li>
		 * 	<li>easeOutBounce</li>
		 * 	<li>easeInOutBounce</li>
		 * 	<li>easeOutInBounce</li>
		 * 	<li>easeInElastic</li>
		 * 	<li>easeOutElastic</li>
		 * 	<li>easeInOutElastic</li>
		 * 	<li>easeOutInElastic</li>
		 * </ul>
		 */
		public function get openCloseTransitionType():String
		{
			return "easeOut";
		}
		
		/**
		 * Background color of the reply window
		 */
		public function get replyWindowBackgroundColor():uint
		{
			return 0xF2F2F4;
		}
		
		/**
		 * Background color of the reply window text area
		 */
		public function get replyWindowTextBoxColor():uint
		{
			return Color.WHITE;
		}
		
		public function Theme()
		{}
	}
}