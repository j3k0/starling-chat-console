package fovea.chat
{
	import flash.display.Stage;
	import flash.geom.Point;
	import flash.system.Capabilities;
	import flash.utils.setTimeout;

	import fovea.chat.interfaces.IChatServer;
	import fovea.chat.interfaces.IChatTheme;
	import fovea.chat.message.ChatMessage;
	import fovea.chat.message.ChatMessageData;
	import fovea.chat.message.ChatMessageDisplayConfig;
	import fovea.chat.objects.ChatMessageContainer;
	import feathers.controls.Button;
	import fovea.chat.objects.NewChatAlert;
	import fovea.chat.objects.Shadow;
	import fovea.chat.reply_window.ReplyWindow;

	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.display.Stage;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	/**
	 * Module that allows for sending and receiving chat messages from a server.</br>
	 * Opens by sliding in from the right the width of the module</br>
	 * Requires an IChatTheme to define its functional and dispaly properties.
	 */
	public class ChatConsole extends Sprite
	{
		/** slide open transition tween **/
		private var _tween:Tween;
		/** Console background */
		private var _background:Quad;
		/** Console border */
		private var _border:Quad;
		/** Chat message container */
		private var _chatMessageContainer:ChatMessageContainer;
		/** Console shadow */
		private var _shadow:Shadow;

		/** Chat Messages */
		private var _chatMessages:Vector.<ChatMessage>;
		/** chat server **/
		private var _server:IChatServer;
		/** display theme **/
		private var _theme:IChatTheme;
		/** the reply window */
		private var _replyWindow:ReplyWindow;
		/** the width of the stage in this space */
		private var _stageDimensions:Point;
		/** the width of the stage in this space's parent */
		private var _parentStageDimensions:Point;
		/** Close button */
		private var _closeButton:Button;
		/** New Chat Alert */
		private var _chatAlert:NewChatAlert;
		/** map of sent messages to chat message objects*/
		private var _sentMessages:Object;
		/** translate function */
		private var _starlingStage:starling.display.Stage;

		/** Current state of the chat console
		    <ul><li>OPEN</li><li>CLOSED</li><li>TRANSITIONING</li>
			<li>OPEN</li><li>CLOSED</li></ul>**/
		private var _state:String;

		/** Current state of the chat console
		 	<ul><li>OPEN</li><li>CLOSED</li><li>TRANSITIONING</li>
		 	<li>OPEN</li><li>CLOSED</li></ul>**/
		public function get state():String
		{
			return _state;
		}

		// FIX: Since layout of child elements depend upon the chatconsole width
		// (which in turn depends on the childs size). We'd better fix one out.
		override public function get width():Number {
			return _theme ? _theme.width : 0;
		}
		override public function get height():Number {
			return stage ? stage.stageHeight : 0;
		}

        public static var boostFPS:Function = function(duration:Number):void {
            // client app can set it's own (if app uses variable frame rate)
        };

		/** the location offset of the close button from tight and top */
		private static const CLOSE_BUTTON_OFFSET:Number = 10;

		public static var theme:IChatTheme = null;

		/**
		 * Instantiate ChatConsole
		 * @param server:IChatServer - Server interface to make and receive server calls
		 * @param theme:IChatTheme - Theme to define ChatConsole Dispaly Properties
		 */
		public function ChatConsole(server:IChatServer, theme:IChatTheme, translate:Function=null)
		{
			// Definitions
			_server = server;
			_theme = theme;
			ChatConsole.theme = theme;
			_state = ChatUtil.CLOSED;
			if(translate)
				ChatUtil.translate = translate;

			// instantiate objects
			_background = new Quad(_theme.width, 1,_theme.backgroundColor);
			_background.alpha = _theme.backgroundAlpha;
			_border = new Quad(_theme.borderWidth, 1,_theme.borderColor);
			_border.alpha = _theme.borderAlpha;
			_shadow = new Shadow(4);
			_shadow.alpha = 0;
			_chatMessageContainer = new ChatMessageContainer();
			_chatMessages = new Vector.<ChatMessage>();
			_replyWindow = new ReplyWindow(theme.replyWindowBackgroundColor, theme.replyWindowTextBoxColor, false /*theme.isAndroid*/);
			_closeButton = theme.closeButtonFactory(); // new Button();
            // _closeButton.padding = 100 * _theme.scaleFactor;
            _closeButton.label = ChatUtil.translate("close_button");
			_chatAlert = new NewChatAlert(this);
			_sentMessages = new Object();

			// customize objects
			_theme.customizeCloseButton(_closeButton);

			// add children
			addChild(_shadow);
			addChild(_background);
			addChild(_border);
			addChild(_chatMessageContainer);
			addChild(_replyWindow.view);
			addChild(_closeButton);

			// add listeners
			_server.addListener(onDataRetrieved);
			_closeButton.addEventListener(Event.TRIGGERED, onClosebuttonTriggered);
			_chatAlert.addEventListener(Event.TRIGGERED, onChatAlertTriggered);
			_chatMessageContainer.addEventListener(ChatUtil.SCROLLER_BOTTOM_REACHED, onScrollBottomReached);
			addEventListener(ChatUtil.SHOW_KEYBOARD, onShowKeyboard);
			addEventListener(ChatUtil.HIDE_KEYBOARD, onHideKeyboard);
			addEventListener(Event.RESIZE, onResize);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(ChatUtil.SEND_REPLY_TEXT, onSendReplyText);

			setTimeout(onDataRetrieved, 50);
		}

		/**
		 * Repositions this objects children
		 */
		private function layout():void
		{
			if (!stage) return;

			// resize the background
			_background.width 	= _theme.width;
			_background.height 	= _stageDimensions.y;

			// resize the border
			_border.width 	= _theme.borderWidth;
			_border.height 	= _stageDimensions.y;

			// layout the shadow
			_shadow.layout(_stageDimensions.x - _background.width, _stageDimensions.y);
			_shadow.x = -_shadow.width;

			// positions chat messages
			var messageY:Number = 0;
			for(var i:int = 0; i < _chatMessages.length; ++i)
			{
				var message:ChatMessage = _chatMessages[i];
				message.layout(this.width);
				message.x = 0;
				message.y = messageY;

				messageY += message.height;
			}

			// position reply window
			_replyWindow.layout(this.width);
			_replyWindow.x = 0;
			_replyWindow.y = _stageDimensions.y - _replyWindow.height;

			// position the close button
			// _closeButton.layout();
			_closeButton.x = width - _closeButton.width - CLOSE_BUTTON_OFFSET;
			_closeButton.y = CLOSE_BUTTON_OFFSET;

			// position the chat message container
			_chatMessageContainer.layout(width, _replyWindow.y);

			// Position the chat alert
			_chatAlert.x = width - _chatAlert.width >> 1;
			_chatAlert.y = _replyWindow.y - _chatAlert.height - NewChatAlert.PADDING;
		}

		/**
		 * Defines the chat console location based upon its position in the stage
		 */
		private function resetStageLoc():void
		{
			// var nativeStage:flash.display.Stage = Starling.current.nativeStage;
			// get the stage dimensions of the parent
			// _parentStageDimensions = ChatUtil.stageDimensions(parent, _theme.isMobile);
			// Define the stage dimensions in this space.
			// _stageDimensions = ChatUtil.stageDimensions(this, _theme.isMobile);

			_parentStageDimensions = new Point(stage.stageWidth, stage.stageHeight);
			_stageDimensions =  new Point(stage.stageWidth, stage.stageHeight);

			// Define console location
			x = _parentStageDimensions.x;
			y = 0;
		}

		/**
		 * slide the message container down
		 * @param location:Number the location to slide the content to
		 */
		private function slideContent(location:Number):void
		{
			// Remove tween if tween exists
			clearTween();

			// Start new transition
			_state = ChatUtil.TRANSITIONING;
			_tween = new Tween(_chatMessageContainer, .25);
			_tween.onComplete = onKeyboardOpenComplete;
			_tween.moveTo(_chatMessageContainer.x, location);
			Starling.juggler.add(_tween);
		}

		/**
		 * Added to stage callback
		 */
		private function onAddedToStage(event:Event):void
		{
			// Resets the position of the and sizing of the console
			resetStageLoc();

			// store off the stage for disposal
			_starlingStage = stage;

			// initialize the close button
			// add a touch quad for the close button
			// _closeButton.validate();
			// var touchQuad:Quad = new Quad(_closeButton.width, _closeButton.height, 0xFF0000);
			// _closeButton.addChild(touchQuad);
			// touchQuad.alpha = 0;


			// call the layout function
			layout();
		}

		/**
		 * Resize event callback
		 */
		private function onResize(event:Event):void
		{
			// Resets the position of the and sizing of the console
			resetStageLoc();

			// Wheh the app resizes call layout
			layout();
		}

		/**
		 * Returns true iff the given chatMessage has already been added to the console.
		 * @param chatMessage:ChatMessage the message to search
		 * @param bestBet:int the index you assume it can be found at (-1 for none)
		 */
		private function hasChatMessage(chatMessage:ChatMessage, bestBet:int = -1):Boolean {

			// Most probably, the chat message already is at the same index.
			// Let's take our chance!
			if (bestBet >= 0 && _chatMessages.length > bestBet && _chatMessages[bestBet].id == chatMessage.id) {
				return true;
			}

			// Now run the expensive tests
			for(var i:int = 0; i < _chatMessages.length; ++i) {
				if (_chatMessages[i].id == chatMessage.id)
					return true;
			}
			return false;
		}

		/**
		 * Data retrieval complete function
		 */
		private function onDataRetrieved():void
		{
			// retrieve chat messages from the server
			var chatMessages:Vector.<ChatMessage> = _server.getData();

			if (chatMessages.length == 0) {
				clearMessages();
				layout();
				return;
			}

			// Don't let the console fill up
			if (_chatMessages.length > 24) {
				clearMessages();
				setTimeout(onDataRetrieved, 50);
				return;
			}

			// add the message list to the console if doesnt exist
			var messageToAdd:ChatMessage = null;
			for(var i:int = 0; i < chatMessages.length; ++i){
				var chatMessage:ChatMessage = chatMessages[i];
				if (!hasChatMessage(chatMessage, i) && chatMessage != messageToAdd) {
					if (messageToAdd)
						addMessage(messageToAdd, false);
					messageToAdd = chatMessage;
				}
			}

			// Relayout on the last added message
			if (messageToAdd) {
				addMessage(messageToAdd, true);
			}
		}

		/**
		 * Sent reply callback
		 */
		private function onSendReplyText(event:Event):void
		{
			// add the chat message
			//var id:String = getUniqueKey();
			//_sentMessages[id] =
			//	addMessageData(new ChatMessageData(id, "Jacob", "http://www.thotkraft.com/test/anime_head_02.jpg", event.data.message, "test"), ChatMessage.STATE_IN_PROGRESS);

			//send the text message to the server
			_server.send(getTimestamp(), event.data.message);
			// _chatMessageContainer.scrollToBottom();
			if(_chatMessageContainer.y > 0)
				slideContent(Math.max(_replyWindow.y - _chatMessageContainer.contentHeight, 0));
		}

		/**
		 * When a new message is received
		private function onReceivedChat(event:Event):void
		{
			// add the message to the message container
			addMessageData(event.data.data, event.data.config);
		}
		 */

		/**
		 * Close button tapped callback
		 */
		private function onClosebuttonTriggered(event:Event):void
		{
			// close the chat console
			hide();
		}

		/**
		 * Show Keyboard callback </br>
		 */
		private function onShowKeyboard(event:Event):void
		{
			// Only open the keyboard when the console is open
			if(_state != ChatUtil.OPEN)
				return;

			event.stopImmediatePropagation();
			// if this is on a mobile platform slide the view up
			if(!_theme.isMobile)
				return;

			// If the chatmessage container is less than the chatmessage containg view area
			// slide it down
			var contentHeight:Number = _chatMessageContainer.contentHeight;
			if(contentHeight < _replyWindow.y)
				slideContent(_replyWindow.y - contentHeight);
		}

		/**
		 * Hide Keyboard callback
		 */
		private function onHideKeyboard(event:Event):void
		{
			// Only close the keyboard when the console is open
			if(_state != ChatUtil.KEYBOARD_OPEN)
				return;

			event.stopImmediatePropagation();
			// if this is a mobile platform slide the view down
			if(!_theme.isMobile)
				return;

			// If the chatmessage container is less than the chatmessage containg view area
			// slide it up to 0
			// Remove tween if tween exists
			clearTween();

			// Start new transition
			_state = ChatUtil.TRANSITIONING;
			_tween = new Tween(_chatMessageContainer, .25);
			_tween.onComplete = onKeyboardCloseComplete;
			_tween.moveTo(_chatMessageContainer.x, 0);
			Starling.juggler.add(_tween);
		}

		/**
		 * Chat alert tapped callback
		 */
		private function onChatAlertTriggered(event:Event):void
		{
			_chatMessageContainer.scrollToBottom();
		}

		/**
		 * Callback for when the scroller reaches the bottom of the display
		 */
		private function onScrollBottomReached(event:Event):void
		{
			_chatAlert.hide();
		}

		/**
		 * Touch Event Listener
		 */
		private function onTouch(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(stage);
			if(!touch)
				return;

			// get the touch point in the local space
			var touchPoint:Point = globalToLocal(new Point(touch.globalX, touch.globalY));
			switch(touch.phase)
			{
				case TouchPhase.ENDED:
					if(_shadow.bounds.contains(touchPoint.x, touchPoint.y))
						hide();
					break;
			}
		}

		/**
		 * Adds a new message to the chat message container
		 * @param data:ChatMessage - Chat message object to be added to the message container
		 */
		public function addMessage(chatMessage:ChatMessage, relayout:Boolean = true):ChatMessage
		{
			// Set this user sent chat message state to success
			if(_sentMessages[chatMessage.id] != "undefined" && _sentMessages[chatMessage.id] != null)
			{
				_chatMessages.splice(_chatMessages.indexOf(_sentMessages[chatMessage.id]), 1);
				_chatMessageContainer.removeItem(_sentMessages[chatMessage.id].view);
				_sentMessages[chatMessage.id] = null;
			}

			// set incoming chats to success
			// chatMessage.state = state;
			// grab the last message's position in relation to the bottom of the container
			var liveFeed:Boolean = false;
			if (relayout) {
				var lastMsgPos:Number = _chatMessageContainer.contentHeight - (_chatMessageContainer.height + _chatMessageContainer.scrollPosition);
				liveFeed =  _chatMessageContainer.isScrollingBottom || !(lastMsgPos > 0);
			}

			// add text to the console
			_chatMessages.push(chatMessage);
			_chatMessageContainer.addItem(chatMessage.view);

			if (relayout)
			{
				layout();

				// Check for auto scroll or new message alert
				if(_chatMessageContainer.contentHeight > _replyWindow.y)
				{
					// if the last message was visible (position before the new message was added > 0),
					// alert a new message has been added otherwise scroll to bottom.
					if(liveFeed)
						_chatMessageContainer.scrollToBottom();
					else
						_chatAlert.show();
				}
			}

			return chatMessage
		}

		/**
		 * Adds a new message to the chat message container
		 * @param data:ChatMessageData - Chat message data to be added to the message container
		 * @param config:ChatMessageDisplayConfig = null - Display configuration of the chat message display
		public function addMessageData(data:ChatMessageData, state:int, config:ChatMessageDisplayConfig = null):ChatMessage
		{
			return addMessage(new ChatMessage(data, config), state);
		}
		 */

		/**
		 * Display Console
		 */
		public function show():void
		{
			// Only show the console when the console is closed
			if(_state != ChatUtil.CLOSED)
				return;

			var openLoc:Number = _parentStageDimensions.x - _theme.width;

			// Remove tween if tween exists
			clearTween();

			_state = ChatUtil.TRANSITIONING;
			_tween = new Tween(this, _theme.openCloseTransitionTime, _theme.openCloseTransitionType);
			_tween.onComplete = onOpenComplete;
			_tween.moveTo(openLoc, y);
			_tween.animate("shadowAlpha", 1);
			Starling.juggler.add(_tween);
			_chatMessageContainer.scrollToBottom();
			stage.addEventListener(TouchEvent.TOUCH, onTouch);
		}

		public function set shadowAlpha(value:Number):void {
			_shadow.alpha = value;
		}
		public function get shadowAlpha():Number {
			return _shadow.alpha;
		}

		/**
		 * Hide Console
		 */
		public function hide():void
		{
			// Only hide the console when the console is open
			if(_state != ChatUtil.OPEN)
				return;

			// Remove tween if tween exists
			clearTween();

			_state = ChatUtil.TRANSITIONING;
			_tween = new Tween(this, _theme.openCloseTransitionTime, _theme.openCloseTransitionType);
			_tween.onComplete = onCloseComplete;
			_tween.moveTo(_parentStageDimensions.x, y);
			_tween.animate("shadowAlpha", 0);
			Starling.juggler.add(_tween);
			// remove the stage touch listener for tapping outside the console
			_starlingStage.removeEventListener(TouchEvent.TOUCH, onTouch);
		}

		/**
		 * Console open Transition callback
		 */
		public function onOpenComplete():void
		{
			_state = ChatUtil.OPEN;
			clearTween();
		}

		/**
		 * Console close Transition callback
		 */
		public function onCloseComplete():void
		{
			_state = ChatUtil.CLOSED;
			clearTween();
		}

		/**
		 * Console open Transition callback
		 */
		public function onKeyboardOpenComplete():void
		{
			_state = ChatUtil.KEYBOARD_OPEN;
			clearTween();
		}

		/**
		 * Console close Transition callback
		 */
		public function onKeyboardCloseComplete():void
		{
			_state = ChatUtil.OPEN;
			clearTween();
		}

		/**
		 * remove the console tween if it exists
		 */
		private function clearTween():void
		{
			if(!_tween)
				return;

			Starling.juggler.remove(_tween);
			_tween = null;
		}

		/**
		 * clear out dispalyed chat messages
		 */
		private function clearMessages():void
		{
			// remove them from the view
			_chatMessageContainer.clearMessages();
			for(var i:int = 0; i < _chatMessages.length; ++i)
				_chatMessages[i].dispose();
			_chatMessages.splice(0, _chatMessages.length);
		}

		private function getTimestamp():String {
			return "" + (new Date()).valueOf();
		}

		/**
		 * returns a reasonably unique-key based on this specific console
		 */
		private function getUniqueKey():String
		{
			return getTimestamp();
			// return ChatUtil.obfuscateString(Capabilities.cpuArchitecture+Capabilities.version+Capabilities.pixelAspectRatio+_chatMessages.length);
		}

		/**
		 * Disposes of the Chat console Window
		 */
		override public function dispose():void
		{
			// clear the messages
			clearMessages();

			// Remove event listeners
			_starlingStage.removeEventListener(TouchEvent.TOUCH, onTouch);
			_closeButton.removeEventListeners();
			_chatAlert.removeEventListeners();
			_chatMessageContainer.removeEventListeners();

			// dispose of the chat messages

			clearTween();
			// Dispose of display objects
			_background.dispose();
			_border.dispose();
			_shadow.dispose();
			_closeButton.dispose();
			_chatMessageContainer.dispose();
			_replyWindow.dispose();
		}
	}
}
