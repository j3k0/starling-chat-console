package fovea.chat.reply_window
{
	import feathers.controls.TextArea;
	
	import starling.display.DisplayObjectContainer;
	import starling.display.Quad;
	
	/**
	 * View for the Reply Window. </br>
	 * defines reply window layout
	 */
	public class ReplyWindowDisplay extends DisplayObjectContainer
	{
		/** the background of the object */
		private var _background:Quad;
		/** the background of the object */
		private var _textBackground:Quad;
		/** the replytext box */
		private var _replyTA:TextArea;
		
		private static const BACKGROUND_HEIGHT:Number = 75;
		
		public function ReplyWindowDisplay(backgroundColor:uint, textboxColor:uint)
		{
			_background = new Quad(1,1,backgroundColor);
			_textBackground = new Quad(1,1,textboxColor);
			_replyTA = new TextArea();
			_replyTA.text = "Write a reply";
			
			// Add Children
			addChild(_background);
			addChild(_textBackground)
			addChild(_replyTA);
		}
		
		/**
		 * Defines the positioning and size of the reply window
		 */
		public function layout(consoleWidth:Number):void
		{
			_background.width = consoleWidth;
			_background.height = BACKGROUND_HEIGHT;
			
			_textBackground.width = consoleWidth - 20;
			_textBackground.height = BACKGROUND_HEIGHT - 20;
			
			_textBackground.x = (consoleWidth - _textBackground.width) >> 1;
			_textBackground.y = (BACKGROUND_HEIGHT - _textBackground.height) >> 1;
			
			_replyTA.x = _textBackground.x;
			_replyTA.y = _textBackground.y;
			_replyTA.width = _textBackground.width;
			_replyTA.height = _textBackground.height;
		}
	}
}