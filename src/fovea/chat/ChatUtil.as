package fovea.chat
{
	import flash.display.Stage;
	import flash.geom.Point;
	import flash.system.Capabilities;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;

	public class ChatUtil
	{
		// Chat States
		/** Chat open state*/
		public static const OPEN:String 			= "open";
		/** Chat closed state */
		public static const CLOSED:String 			= "closed";
		/** Chat Keyboard open state */
		public static const KEYBOARD_OPEN:String 	= "keyboardOpen";
		/** Chat Transitioning state, when an animation is running */
		public static const TRANSITIONING:String 	= "transitioning";
		
		// Event definitions
		/** Reply was defined and is ready to be sent: data={text:(replytext)}*/
		public static const SEND_REPLY_TEXT:String			= "SEND_REPLY_TEXT";
		/** A Load was succesful */
		public static const LOAD_SUCCESS:String 			= "LOAD_SUCCESS";
		/** A Load was unsuccesful */
		public static const LOAD_FAIL:String 				= "LOAD_FAIL";
		/** The soft keyboard has been shown (only used on mobile devices) */
		public static const SHOW_KEYBOARD:String 			= "SHOW_KEYBOARD";
		/** The soft keyboard has been hidden (only used on mobile devices) */
		public static const HIDE_KEYBOARD:String 			= "HIDE_KEYBOARD";
		/** Dispatched when the scroller reaches the bottom */
		public static const SCROLLER_BOTTOM_REACHED:String	= "SCROLLER_BOTTOM_REACHED";
		
		// Color Definitions
		public static const GREY_TEXT_COLOR:uint 	= 0xC8C8C8;
		
		/**
		 * Retreives the stage dimension in a defined space
		 * @param space:DisplayObject - the space in whech to define the stage dimnensions.
		 * @param isMobile:Boolean - whther this is a mobile platform or not
		 */
		public static function stageDimensions(space:DisplayObject=null, isMobile:Boolean=false):Point
		{
			var nativeStage:Stage = Starling.current.nativeStage;
			var screenDim:Point = isMobile ? new Point(nativeStage.fullScreenWidth, nativeStage.fullScreenHeight) :
										screenDim = new Point(nativeStage.stageWidth, nativeStage.stageHeight);
			var screenWidth:Number = screenDim.x * Starling.contentScaleFactor;
			var screenHeight:Number = screenDim.y * Starling.contentScaleFactor;
			
			return space.globalToLocal(new Point(screenWidth, screenHeight));
		}
	}
}