package fovea.chat.reply_window
{
	CONFIG::MOBILE {
		import flash.text.ReturnKeyLabel;
	}

	import feathers.controls.TextInput;
	import feathers.events.FeathersEventType;

	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	import flash.utils.setTimeout;
	
	import fovea.chat.ChatConsole;
	import fovea.chat.ChatUtil;
	import fovea.chat.message.MessageDisplayUtil;

	import fovea.utils.NativeController;
	// import fovea.ui.InputViewportScroller;

	import starling.core.Starling;
	import starling.display.DisplayObjectContainer;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.Color;
	import starling.utils.HAlign;
	import feathers.controls.Button;
	
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
		/** the send button */
		private var _replyButton:Button;
		// force the text input to keep focus (fix issues with android)
		private var _forceFocus:Boolean = false;
		
		private static const DEFAULT_TEXT:String = "chat_your_message";
		
		/**
		 * Instantiates a ReplyWindow controller
		 * @param backgroundColor:uint - Background color of the ReplyWindow
		 * @param textboxColor:uint - Background color of the ReplyWindow TextArea
		 */
		public function ReplyWindowDisplay(backgroundColor:uint, textboxColor:uint, forceFocus:Boolean)
		{
			trace("ReplyWindowDisplay()");
			_forceFocus = forceFocus;
			// Instantiate 
			_background = new Quad(1,1,backgroundColor);
			_textBackgroundBorder = new Quad(1,1,getDarkerColor(backgroundColor));
			_textBackground = new Quad(1,1,textboxColor);

			var fontSizeFix:Number = 1.0;
			var nativeController:NativeController = new NativeController({});
			if (nativeController.isWeb || nativeController.isDesktop)
				fontSizeFix = 1.0 / Starling.current.contentScaleFactor;

			_replyTI = new TextInput();
			_replyTI.textEditorProperties.fontFamily = MessageDisplayUtil.getInstance().MESSAGE_TEXT_FONT_NAME;
			_replyTI.textEditorProperties.fontSize = MessageDisplayUtil.getInstance().MESSAGE_TEXT_FONT_SIZE * fontSizeFix; // 28 * ChatConsole.theme.scaleFactor;
			_replyTI.textEditorProperties.color = MessageDisplayUtil.getInstance().MESSAGE_TEXT_COLOR; // 0x444444;
            CONFIG::MOBILE {
                _replyTI.textEditorProperties.returnKeyLabel = ReturnKeyLabel.DONE;
            }
			_replyButton = ChatConsole.theme.sendButtonFactory();
			
			// Initialize objects
			setReplyText(null);
			var isAndroid:Boolean = Capabilities.manufacturer.indexOf('Android') > -1;
			if (isAndroid) {
				_replyTI.verticalAlign = TextInput.VERTICAL_ALIGN_TOP;
				_replyTI.textEditorProperties.multiline = true;
			}
			else {
				_replyTI.verticalAlign = TextInput.VERTICAL_ALIGN_MIDDLE;
			}
			_replyTI.padding = 5 * ChatConsole.theme.scaleFactor;
			_replyTI.maxChars = MessageDisplayUtil.getInstance().MAX_CHARACTERS;
			
			_charCountTF = new TextField(
				200 * ChatConsole.theme.scaleFactor,
				50 * ChatConsole.theme.scaleFactor,
				charCountText(),
				MessageDisplayUtil.getInstance().TIME_TEXT_FONT_NAME,
				MessageDisplayUtil.getInstance().TIME_TEXT_FONT_SIZE,
				MessageDisplayUtil.getInstance().TIME_TEXT_COLOR);
			_charCountTF.hAlign = HAlign.RIGHT;

			_replyButton.label = "";
			_replyButton.validate();
			
			// Add listeners
			_replyTI.addEventListener(FeathersEventType.FOCUS_IN, onTextAreaFocusIn);
			_replyTI.addEventListener(FeathersEventType.FOCUS_OUT, onTextAreaFocusOut);
			_replyTI.addEventListener(FeathersEventType.ENTER, onTextEnter);
			_replyTI.addEventListener(Event.CHANGE, onTextChanged);
			_replyButton.addEventListener(Event.TRIGGERED, onReplyTriggered);

			// Add Children
			addChild(_background);
			addChild(_textBackgroundBorder);
			addChild(_textBackground)
			addChild(_replyTI);
			addChild(_charCountTF);
			addChild(_replyButton);

			//new InputViewportScroller(new <FoveaTextInput>[
			//	_replyTI
			//]).setup();
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		private function onAddedToStage(e:Event):void {
			if (_forceFocus)
				_replyTI.setFocus();
		}
		
		/**
		 * Defines the positioning and size of the reply window
		 * @param consoleWidth:Number - The width of the chat console used for children sizig and positioning
		 */
		public function layout(consoleWidth:Number):void
		{
			// Set teh background size
			_background.width = consoleWidth;
			_background.height = ChatConsole.theme.replyHeight;

			_replyButton.x = consoleWidth - _replyButton.width - ChatConsole.theme.borderWidth;
			_replyButton.y = ChatConsole.theme.borderWidth;
			
			// Set the textbox background size and position
			_textBackground.width = consoleWidth - ChatConsole.theme.borderWidth * 3 - _replyButton.width;
			_textBackground.height = ChatConsole.theme.replyHeight - ChatConsole.theme.borderWidth * 2;
			
			_textBackground.x = ChatConsole.theme.borderWidth; //(consoleWidth - _textBackground.width) * 0.5;
			_textBackground.y = (ChatConsole.theme.replyHeight - _textBackground.height) * 0.5;
			
			// Define the textbox border
			_textBackgroundBorder.x = _textBackground.x - 2 * ChatConsole.theme.scaleFactor;
			_textBackgroundBorder.y = _textBackground.y - 2 * ChatConsole.theme.scaleFactor;
			_textBackgroundBorder.width = _textBackground.width + 4 * ChatConsole.theme.scaleFactor;
			_textBackgroundBorder.height = _textBackground.height + 4 * ChatConsole.theme.scaleFactor;
			
			// Set the text input position and size
			_replyTI.x = _textBackground.x + 10 * ChatConsole.theme.scaleFactor;
			_replyTI.y = _textBackground.y + 5 * ChatConsole.theme.scaleFactor;
			_replyTI.width = _textBackground.width - 100 * ChatConsole.theme.scaleFactor;
			_replyTI.height = _textBackground.height - 10 * ChatConsole.theme.scaleFactor;
			
			// Set the character count display position
			_charCountTF.x = _textBackground.bounds.right - _charCountTF.width - 20 * ChatConsole.theme.scaleFactor;
			_charCountTF.y = _textBackgroundBorder.bounds.bottom - _charCountTF.height;
		}

		/**
		 * Change the viewport
		 */
		private function set viewPortY(value:Number):void
		{
			var vp:Rectangle = Starling.current.viewPort;
			if (value !== vp.y) {
                vp = vp.clone();
				vp.y = value;
				Starling.current.viewPort = vp;
			}
		}
		
		/**
		 * Text Gained focus callback 
		 */
		private function onTextAreaFocusIn(event:Event):void
		{
			trace("onTextAreaFocusIn");
            ChatConsole.boostFPS(1);
			// If the text box is using the default text clear it.
			if(_replyTI.text == ChatUtil.translate(DEFAULT_TEXT))
				setReplyText("");
			
			dispatchEventWith(ChatUtil.SHOW_KEYBOARD, true);
			forceRefreshViewport();
		}
		
		/**
		 * Text Loast focus callback 
		 */
		private function onTextAreaFocusOut(event:Event):void
		{
            ChatConsole.boostFPS(1);
			// If the text box is empty return it to the default text
			if(_replyTI.text == "")
				setReplyText(null);
			
			dispatchEventWith(ChatUtil.HIDE_KEYBOARD, true);
			forceRefreshViewport();
		}

		private function setReplyText(txt:String):void
		{
			if (txt === null) {
				_replyTI.text = ChatUtil.translate(DEFAULT_TEXT);
				_replyTI.alpha = 0.4;
			}
			else {
				if(txt.length > MessageDisplayUtil.getInstance().MAX_CHARACTERS - 1)
					_replyTI.text = txt.substring(0, txt.length - 1);
				else
					_replyTI.text = txt;
				_replyTI.alpha = 1.0;
			}
		}

		/**
		 * Trigger f every 100ms for `timeout` milliseconds.
		 */
		private function multiTimeout(f:Function, from:int, to:int):void {
			for (var i:int = from; i <= to; i += 100)
				setTimeout(f, i);
		}
		
		/**
		 * Pull soft keyboard visibility for 1500ms, to update the viewport.
		 *
		 * HAX: because softKeyboardRect isn't always updated right after the focus event.
		 */
		private function forceRefreshViewport():void {
			if (ChatConsole.theme.isAndroid)
				return;
			multiTimeout(function():void {
                trace("[ReplyWindowDisplay] softKeyboardRect x=" + Starling.current.nativeStage.softKeyboardRect.x + " width=" + Starling.current.nativeStage.softKeyboardRect.width);
                trace("[ReplyWindowDisplay] softKeyboardRect y=" + Starling.current.nativeStage.softKeyboardRect.y + " height=" + Starling.current.nativeStage.softKeyboardRect.height);
                if (_replyTI.hasFocus)
                    viewPortY = -Starling.current.nativeStage.softKeyboardRect.height;
                else
                    viewPortY = 0;
			}, 50, 1500);
		}

		private var _disableReply:Boolean = false;
		private function onReplyTriggered(event:Event):void
		{
			if (_disableReply) return;
			_disableReply = true;
			_replyTI.clearFocus();
			_replyTI.alpha = 0;
			setTimeout(function():void {
				_replyTI.alpha = 1;
				_disableReply = false;
				onTextEnter(event);
				if (_forceFocus)
					setTimeout(_replyTI.setFocus, 250);
			}, 1000);
		}

		private function onTextEnter(event:Event):void
		{
			// remove the carraige return from the string (if any)
			var txt:String = _replyTI.text;
			if(txt === ChatUtil.translate(DEFAULT_TEXT))
				return;
			if(txt.indexOf("\n") > -1 || txt.indexOf("\r") > -1) {
				/* if (ChatConsole.theme.isAndroid)
					_replyTI.clearFocus(); */
				txt = txt.replace("\n", "").replace("\r","");
			}
			// if there is text to send, send text
			sendText(txt);
		}
		
		/**
		 * Text Changed callback function
		 */
		private function onTextChanged(event:Event):void
		{
			_replyTI.alpha = 1.0;
			if(_replyTI.text.indexOf("\n") > -1 || _replyTI.text.indexOf("\r") > -1)
			{
				// HAX: because the enter listener doesnt work on certain android devices,
				// check for a carraige return and send when heard
				onTextEnter(event);
			}else{
				if(_replyTI.text.length > (MessageDisplayUtil.getInstance().MAX_CHARACTERS - 1))
					setReplyText(_replyTI.text);
				
				// Sets the character left
				if(_replyTI.hasFocus)
					updateCharCount(_replyTI.maxChars - (_replyTI.text.length + 1));
				else
					updateCharCount();
			}
		}

		/**
		 * Return what should be the _charCountTF text
		 */
		private function charCountText(value:int = -123456):String {
			if (value === -123456)
				value = MessageDisplayUtil.getInstance().MAX_CHARACTERS - 1;
			return "" + value;
		}

		/**
		 * Update _charCountTF text
		 */
		private function updateCharCount(value:int = -123456):void {
			if (_charCountTF)
				_charCountTF.text = charCountText(value);
		}
		
		/**
		 * Dispatches a SEND_REPLY_TEXT event with the _repyTI.text as the message</br>
		 */
		private function sendText(txt:String):void
		{
			setReplyText("");
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
			_replyButton.dispose();
		}
	}
}
