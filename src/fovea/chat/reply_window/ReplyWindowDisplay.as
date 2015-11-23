package fovea.chat.reply_window
{
	import feathers.controls.FoveaTextInput;
	import feathers.controls.TextInput;
	import feathers.events.FeathersEventType;

	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	import flash.utils.setTimeout;
	
	import fovea.chat.ChatConsole;
	import fovea.chat.ChatUtil;
	import fovea.chat.message.MessageDisplayUtil;

	import fovea.ui.InputViewportScroller;

	import starling.core.Starling;
	import starling.display.DisplayObjectContainer;
	import starling.display.Quad;
	import starling.events.Event;
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
		private var _replyTI:FoveaTextInput;
		/** display the amount of charcters left */
		private var _charCountTF:TextField;
		
		//private static const CHARS_LEFT_TEXT:String = "chat_chars_left";
		private static const DEFAULT_TEXT:String = "chat_your_message";
		private static function get BACKGROUND_HEIGHT():Number {
			return 150 * ChatConsole.theme.scaleFactor;
		}
		
		
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
			_replyTI = new FoveaTextInput();
			_replyTI.textEditorProperties.fontFamily = "Verdana";
			_replyTI.textEditorProperties.fontSize = 28;// * ChatConsole.theme.scaleFactor;
			_replyTI.textEditorProperties.color = 0x444444;
			
			// Initialize objects
			_replyTI.text = ChatUtil.translate(DEFAULT_TEXT);
			_replyTI.verticalAlign = TextInput.VERTICAL_ALIGN_TOP;
			var isAndroid:Boolean = Capabilities.manufacturer.indexOf('Android') > -1;
			if (isAndroid)
				_replyTI.textEditorProperties.multiline = true;
			_replyTI.padding = 5 * ChatConsole.theme.scaleFactor;
			_replyTI.maxChars = MessageDisplayUtil.getInstance().MAX_CHARACTERS;
			
			_charCountTF = new TextField(
				200 * ChatConsole.theme.scaleFactor,
				50 * ChatConsole.theme.scaleFactor,
				/*ChatUtil.translate(CHARS_LEFT_TEXT)+" "+*/(MessageDisplayUtil.getInstance().MAX_CHARACTERS - 1),
				"Verdana", 20 * ChatConsole.theme.scaleFactor,
				MessageDisplayUtil.getInstance().TIME_TEXT_COLOR);
			_charCountTF.hAlign = HAlign.RIGHT;
			
			// Add listeners
			_replyTI.addEventListener(FeathersEventType.FOCUS_IN, onTextAreaFocusIn);
			_replyTI.addEventListener(FeathersEventType.FOCUS_OUT, onTextAreaFocusOut);
			_replyTI.addEventListener(FeathersEventType.ENTER, onTextEnter);
			_replyTI.addEventListener(Event.CHANGE, onTextChanged);

			// Add Children
			addChild(_background);
			addChild(_textBackgroundBorder);
			addChild(_textBackground)
			addChild(_replyTI);
			addChild(_charCountTF);

			//new InputViewportScroller(new <FoveaTextInput>[
			//	_replyTI
			//]).setup();
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
			_textBackground.width = consoleWidth - 20 * ChatConsole.theme.scaleFactor;
			_textBackground.height = BACKGROUND_HEIGHT - 20 * ChatConsole.theme.scaleFactor;
			
			_textBackground.x = (consoleWidth - _textBackground.width) >> 1;
			_textBackground.y = (BACKGROUND_HEIGHT - _textBackground.height) >> 1;
			
			// Define the textbox border
			_textBackgroundBorder.x = _textBackground.x - 2 * ChatConsole.theme.scaleFactor;
			_textBackgroundBorder.y = _textBackground.y - 2 * ChatConsole.theme.scaleFactor;
			_textBackgroundBorder.width = _textBackground.width + 4 * ChatConsole.theme.scaleFactor;
			_textBackgroundBorder.height = _textBackground.height + 4 * ChatConsole.theme.scaleFactor;
			
			// Set the text input position and size
			_replyTI.x = _textBackground.x + 10 * ChatConsole.theme.scaleFactor;
			_replyTI.y = _textBackground.y + 5 * ChatConsole.theme.scaleFactor;
			_replyTI.width = _textBackground.width - 10 * ChatConsole.theme.scaleFactor;
			_replyTI.height = _textBackground.height - 10 * ChatConsole.theme.scaleFactor;
			
			// Set the character count display position
			_charCountTF.x = _replyTI.bounds.right - _charCountTF.width - 10 * ChatConsole.theme.scaleFactor;
			_charCountTF.y = _textBackgroundBorder.bounds.bottom - _charCountTF.height;
		}

		/**
		 * Change the viewport
		 */
		public function set viewPortY(value:Number):void
		{
			var vp:Rectangle = Starling.current.viewPort;
			if (value !== vp.y) {
				vp.y = value;
				Starling.current.viewPort = vp;
			}
		}
		
		/**
		 * Text Gained focus callback 
		 */
		private function onTextAreaFocusIn(event:Event):void
		{
			// If the text box is using the default text clear it.
			if(_replyTI.text == ChatUtil.translate(DEFAULT_TEXT))
				_replyTI.text = "";
			
			dispatchEventWith(ChatUtil.SHOW_KEYBOARD, true);
			forceRefreshViewport();
		}
		
		/**
		 * Text Loast focus callback 
		 */
		private function onTextAreaFocusOut(event:Event):void
		{
			// If the text box is empty return it to the default text
			if(_replyTI.text == "")
				_replyTI.text = ChatUtil.translate(DEFAULT_TEXT);
			
			dispatchEventWith(ChatUtil.HIDE_KEYBOARD, true);
			forceRefreshViewport();
		}

		private function multiTimeout(f:Function, timeout:int):void {
			for (var i:int = 0; i <= timeout; i += 100)
				setTimeout(f, i);
		}
		
		private function forceRefreshViewport():void {
			multiTimeout(function():void {
				viewPortY = -Starling.current.nativeStage.softKeyboardRect.y;
			}, 1500);
		}

		private function onTextEnter(event:Event):void
		{
			// remove the carraige return from the string (if any)
			var txt:String = _replyTI.text;
			if(txt.indexOf("\n") > -1 || txt.indexOf("\r") > -1)
				txt = txt.substring(0, txt.length - 1);
			// if there is text to send, send text
			sendText(txt);
		}
		
		/**
		 * Text Changed callback function
		 */
		private function onTextChanged(event:Event):void
		{
			if(_replyTI.text.indexOf("\n") > -1 || _replyTI.text.indexOf("\r") > -1)
			{
				// HAX: because the enter listener doesnt work on certain android devices,
				// check for a carraige return and send when heard
				onTextEnter(event);
			}else{
				if(_replyTI.text.length > (MessageDisplayUtil.getInstance().MAX_CHARACTERS - 1))
					_replyTI.text = _replyTI.text.substring(0, _replyTI.text.length - 1);
				
				// Sets the character left
				if(_replyTI.hasFocus)
					_charCountTF.text = /*ChatUtil.translate(CHARS_LEFT_TEXT)+" "+*/(_replyTI.maxChars - (_replyTI.text.length + 1));
				else
					_charCountTF.text = /*ChatUtil.translate(CHARS_LEFT_TEXT)+" "+*/(MessageDisplayUtil.getInstance().MAX_CHARACTERS - 1);
			}
		}
		
		/**
		 * Dispatches a SEND_REPLY_TEXT event with the _repyTI.text as the message</br>
		 */
		private function sendText(txt:String):void
		{
			if(_replyTI.text == "")
				_replyTI.text = ChatUtil.translate(DEFAULT_TEXT);
			else
				_replyTI.text = "";
			if (txt != "")
				dispatchEventWith(ChatUtil.SEND_REPLY_TEXT, true, { message:txt });
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
