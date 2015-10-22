package fovea.chat
{
	import flash.geom.Point;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;

	public class ChatUtil
	{
		// Chat States
		public static const OPEN:String 			= "open";
		public static const CLOSED:String 			= "closed";
		public static const KEYBOARD_OPEN:String 	= "keyboardOpen";
		public static const KEYBOARD_CLOSED:String 	= "keyboardClosed";
		public static const TRANSITIONING:String 	= "transitioning";
		
		// Event definitions
		public static const SHOW_KEYBOARD:String	= "SHOW_KEYBOARD";
		public static const HIDE_KEYBOARD:String	= "HIDE_KEYBOARD";
		public static const LOAD_SUCCESS:String 	= "LOAD_SUCCESS";
		public static const LOAD_FAIL:String 		= "LOAD_FAIL";
		
		// Color Definitions
		public static const GREY_TEXT_COLOR:uint 	= 0xC8C8C8;
		
		/**
		 * Retreives the stage dimension in a defined space
		 * @param space:DisplayObject - the space in whech to define the stage dimnensions.
		 */
		public static function stageDimensions(space:DisplayObject):Point
		{
			var screenWidth:Number = Starling.current.nativeStage.fullScreenWidth * Starling.contentScaleFactor;
			var screenHeight:Number = Starling.current.nativeStage.fullScreenHeight * Starling.contentScaleFactor;
			 
			return space.globalToLocal(new Point(screenWidth, screenHeight));
		}
	}
}