package fovea.chat.themes
{
	import feathers.controls.Button;

	import fovea.chat.interfaces.IChatTheme;
	import fovea.chat.message.MessageDisplayUtil;
	
	import starling.utils.Color;
	
	public class DefaultChatTheme implements IChatTheme
	{	
		private var _stageWidth:Number = 0;
		private var _stageHeight:Number = 0;

		/**
		 * Define if the platform is mobile
		 */
		public function get isMobile():Boolean
		{
			return true;
		}
		
		/**
		 * How graphic elements must be scaled up/down
		 */
		public function get scaleFactor():Number {
			return 1.0;
		}

		/** 
		 *  Background Color of the chat console window 
		 */
		public function get backgroundColor():uint
		{
			return Color.WHITE;
		}

		/**
		 * Background transparency of the chat console window
		 */
		public function get backgroundAlpha():Number
		{
			return 0.9;
		}
		
		public function get borderColor():uint { return Color.RED; }
		public function get borderAlpha():Number { return 0.5; }
		public function get borderWidth():Number { return 2; }
		
		/**
		 * Width of the chat console, defines where the chat rests when opened.
		 */
		public function get width():Number
		{
			return _stageWidth * 0.9; // 800;
		}
		
		/** 
		 * Length of time for the open and close transition animations, (in Seconds) 
		 */
		public function get openCloseTransitionTime():Number
		{
			return .2;
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

		/**
		 * Customize the look of the close button
		 */
		public function customizeCloseButton(b:Button):void
		{}

    		/**
		 * Size of the avatar image
		 */
		public function avatarSize():Number
		{
			return 32;
		}

		public function customizeMessageDisplay(mdu:MessageDisplayUtil):void
		{}

		public function sendButtonFactory():Button
		{
			return new Button();
		}

		public function get replyHeight():Number {
			return 150 * scaleFactor;
		}
		
		public function DefaultChatTheme(stageWidth:Number, stageHeight:Number)
		{
			_stageWidth = stageWidth;
			_stageHeight = stageHeight;
		}
	}
}
