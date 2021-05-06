package fovea.chat.message
{
	import fovea.chat.ChatConsole;

	/**
	 * Container for global Message display constants
	 */
	public class MessageDisplayUtil
	{
		/** X-Coordinate of the avatar image */
		public var AV_IMAGE_X:Number = 15;
		/** Y-Coordinate of the avatar image */
		//public var AV_IMAGE_Y:Number = 14;
		
		/** X-Coordinate of the avatar name */
		public var NAME_TEXT_X:Number = 65;
		/** Y-Coordinate of the avatar name*/
		public var NAME_TEXT_Y:Number = 14;
		public var NAME_TEXT_WIDTH:Number = 620;
		public var NAME_TEXT_HEIGHT:Number = 30;
		public var NAME_TEXT_FONT_NAME:String = "_sans";
		public var NAME_TEXT_FONT_SIZE:Number = 12;
		public var NAME_TEXT_COLOR:uint = 0;
		
		/** X-Coordinate of the chat message */
		public var MESSAGE_TEXT_X:Number = 65;
		/** Y-Coordinate of the chat message */
		public var MESSAGE_TEXT_Y:Number = 40;
		public var MESSAGE_TEXT_WIDTH:Number = 620;
		public var MESSAGE_TEXT_HEIGHT:Number = 70;
		public var MESSAGE_TEXT_FONT_NAME:String = "_sans";
		public var MESSAGE_TEXT_FONT_SIZE:Number = 12;
		public var MESSAGE_TEXT_COLOR:uint = 0;

		public var MESSAGE_SYSTEM_TEXT_X:Number = 65;
		public var MESSAGE_SYSTEM_TEXT_Y:Number = 40;
		public var MESSAGE_SYSTEM_TEXT_WIDTH:Number = 620;
		public var MESSAGE_SYSTEM_TEXT_HEIGHT:Number = 70;
		public var MESSAGE_SYSTEM_TEXT_FONT_NAME:String = "_sans";
		public var MESSAGE_SYSTEM_TEXT_FONT_SIZE:Number = 12;
		public var MESSAGE_SYSTEM_TEXT_COLOR:uint = 0x888888;
		
		/** Y-Coordinate of time-stamp of the message */
		public var TIME_TEXT_Y:Number = 14;
		public var TIME_TEXT_WIDTH:Number = 66;
		public var TIME_TEXT_HEIGHT:Number = 30;
		public var TIME_TEXT_FONT_NAME:String = "_sans";
		public var TIME_TEXT_FONT_SIZE:Number = 12;
		public var TIME_TEXT_COLOR:uint = 0;
		
		/** MESSAGE PADDING */
		public var BOTTOM_PADDING:Number = 15;

		public var LOADING_STATE_ICON_SIZE:Number = 15;
		
		/** Maximum allowed characters */
		public var MAX_CHARACTERS:int = 257;

		private static var _instance:MessageDisplayUtil = null;
		public static function getInstance():MessageDisplayUtil {
			if (_instance == null) {
				_instance = new MessageDisplayUtil();
				ChatConsole.theme.customizeMessageDisplay(_instance);
			}
			return _instance;
		}
	}
}
