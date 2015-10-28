package fovea.chat.reply_window
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import feathers.controls.TextInput;
	import feathers.controls.text.StageTextTextEditor;
	import feathers.core.ITextEditor;
	import feathers.events.FeathersEventType;
	
	import fovea.chat.ChatUtil;
	import fovea.chat.message.MessageDisplayUtil;
	
	import starling.core.Starling;
	import starling.display.DisplayObjectContainer;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.events.KeyboardEvent;
	import starling.events.TouchEvent;
	import starling.text.TextField;
	import starling.utils.Color;
	import starling.utils.HAlign;
	
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
		/** the background of the object */
		private var _textBackgroundBorder:Quad;
		/** the replytext box */
		private var _replyTI:TextInput;
		/** display the amount of charcters left */
		private var _charCountTF:TextField;
		
		private static const CHARS_LEFT_TEXT:String = "Left: ";
		private static const BACKGROUND_HEIGHT:Number = 75;
		private static const DEFAULT_TEXT:String = "Write a reply";
		
		
		/**
		 * Instantiates a ReplyWindow controller
		 * @param backgroundColor:uint - Background color of the ReplyWindow
		 * @param textboxColor:uint - Background color of the ReplyWindow TextArea
		 */
		public function ReplyWindowDisplay(backgroundColor:uint, textboxColor:uint)
		{
			// Instantiate 
			_background = new Quad(1,1,backgroundColor);
			_textBackgroundBorder = new Quad(1,1,getDarkerColor(backgroundColor));
			_textBackground = new Quad(1,1,textboxColor);
			
			// Initialize objects
			_replyTI = new TextInput();
			_replyTI.text = DEFAULT_TEXT;
			_replyTI.verticalAlign = TextInput.VERTICAL_ALIGN_TOP;
			_replyTI.textEditorProperties.multiline = true;
			_replyTI.padding = 5;
			_replyTI.maxChars = MessageDisplayUtil.MAX_CHARACTERS;
			
			_charCountTF = new TextField(100, 15, CHARS_LEFT_TEXT+(MessageDisplayUtil.MAX_CHARACTERS - 1), "Verdana", 8);
			_charCountTF.hAlign = HAlign.RIGHT;
			
			// Add listeners
			_replyTI.addEventListener(FeathersEventType.FOCUS_IN, onTextAreaFocusIn);
			_replyTI.addEventListener(FeathersEventType.FOCUS_OUT, onTextAreaFocusOut);
			_replyTI.addEventListener(Event.CHANGE, onTextChanged);

			// Add Children
			addChild(_background);
			addChild(_textBackgroundBorder);
			addChild(_textBackground)
			addChild(_replyTI);
			addChild(_charCountTF);
		}
		
		/**
		 * Defines the positioning and size of the reply window
		 * @param consoleWidth:Number - The width of the chat console used for children sizig and positioning
		 */
		public function layout(consoleWidth:Number):void
		{
			// Set teh background size
			_background.width = consoleWidth;
			_background.height = BACKGROUND_HEIGHT;
			
			// Set the textbox background size and position
			_textBackground.width = consoleWidth - 20;
			_textBackground.height = BACKGROUND_HEIGHT - 20;
			
			_textBackground.x = (consoleWidth - _textBackground.width) >> 1;
			_textBackground.y = (BACKGROUND_HEIGHT - _textBackground.height) >> 1;
			
			// Define the textbox border
			_textBackgroundBorder.x = _textBackground.x - 2;
			_textBackgroundBorder.y = _textBackground.y - 2;
			_textBackgroundBorder.width = _textBackground.width + 4;
			_textBackgroundBorder.height = _textBackground.height + 4;
			
			// Set the text input position and size
			_replyTI.x = _textBackground.x;
			_replyTI.y = _textBackground.y;
			_replyTI.width = _textBackground.width;
			_replyTI.height = _textBackground.height;
			
			// Set the character count display position
			_charCountTF.x = _replyTI.bounds.right - _charCountTF.width;
			_charCountTF.y = _replyTI.bounds.bottom - _charCountTF.height;
		}
		
		/**
		 * Text Gained focus callback 
		 */
		private function onTextAreaFocusIn(event:Event):void
		{
			// If the text box is using the default text clear it.
			if(_replyTI.text == DEFAULT_TEXT)
				_replyTI.text = "";
			
			dispatchEventWith(ChatUtil.SHOW_KEYBOARD, true);
		}
		
		/**
		 * Text Loast focus callback 
		 */
		private function onTextAreaFocusOut(event:Event):void
		{
			// If the text box is empty return it to the default text
			if(_replyTI.text == "")
				_replyTI.text = DEFAULT_TEXT;
			
			dispatchEventWith(ChatUtil.HIDE_KEYBOARD, true);
		}
		
		/**
		 * Text Changed callback function
		 * HAX: because the enter listener doesnt work on certain android devices, check for a carraige return and send when heard
		 */
		private function onTextChanged(event:Event):void
		{
			if(_replyTI.text.indexOf("\n") > -1 || _replyTI.text.indexOf("\r") > -1)
			{
				// remove the carraige return from the string.
				_replyTI.text = _replyTI.text.substring(0,_replyTI.text.length - 1);
				// if there is text to send, send text
				if(_replyTI.text != "")
					sendText();
			}else{
				if(_replyTI.text.length > (MessageDisplayUtil.MAX_CHARACTERS - 1))
					_replyTI.text = _replyTI.text.substring(0, _replyTI.text.length - 1);
				
				// Sets the character left
				if(_replyTI.hasFocus)
					_charCountTF.text = CHARS_LEFT_TEXT+(_replyTI.maxChars - (_replyTI.text.length + 1));
				else
					_charCountTF.text = CHARS_LEFT_TEXT+(MessageDisplayUtil.MAX_CHARACTERS - 1);
			}
		}
		
		/**
		 * Dispatches a SEND_REPLY_TEXT event with the _repyTI.text as the message</br>
		 */
		private function sendText():void
		{
			if(_replyTI.text == "")
			{
				_replyTI.text = DEFAULT_TEXT;
				return;
			}
			
			dispatchEventWith(ChatUtil.SEND_REPLY_TEXT, true, {message:_replyTI.text});
			_replyTI.text = "";
		}
		
		/**
		 * Defines a color as a slightly darker color than the base color
		 * @param baseColor:uint - The Background Color
		 */
		private function getDarkerColor(baseColor:uint):uint
		{
			var r:uint = Color.getRed(baseColor);
			var g:uint = Color.getGreen(baseColor);
			var b:uint = Color.getBlue(baseColor);
			
			return Color.rgb(
				Math.max(r - 25, 0), 
				Math.max(g - 25, 0), 
				Math.max(b - 25, 0));
		}
			
		
		/**
		 * Disposes of this object
		 */
		override public function dispose():void
		{
			_replyTI.removeEventListeners();
			_replyTI.dispose();
		}
	}
}