package fovea.chat
{
	import flash.display.Stage;
	import flash.geom.Point;
	
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
		
		// Translate function
		public static var translate:Function = function(str:String):String{return str};
		
		/** obuscateMap */
		private static const obfuscateMap:Object = {
			"a":"0","b":"9","c":"1","d":"8","e":"2","f":"7","g":"3","h":"6","i":"4","j":"5","k":"q","l":"w","m":"e",
			"n":"r","o":"t","p":"y","q":"u","r":"i","s":"o","t":"p","u":"a","v":"s","w":"d","x":"f","y":"g","z":"h",
			"0":"j","1":"k","2":"l","3":"z","4":"x","5":"c","6":"v","7":"b","8":"n","9":"m"
		};
		
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
		
		/**
		 * Uses a replacement algo to reassign a strings value
		 */
		public static function obfuscateString(string:String):String
		{
			var returnString:String = new String();
			
			for(var i:int = 0; i < string.length;++i)
			{
				if(obfuscateMap.hasOwnProperty(string.charAt(i)))
					returnString += obfuscateMap[string.charAt(i)];
			}
			return returnString;
		}
	}
}