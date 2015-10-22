package fovea.chat
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import fovea.chat.interfaces.IChatServer;
	import fovea.chat.interfaces.IChatTheme;
	import fovea.chat.message.ChatMessage;
	import fovea.chat.reply_window.ReplyWindow;
	
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class ChatConsole extends Sprite
	{
		/** slide open transition tween **/
		private var _tween:Tween;
		/** Console background */
		private var _background:Quad;
		/** Chat message container */
		private var _chatMessageContainer:Sprite;
		
		/** Chat Messages */
		private var _chatMessages:Vector.<ChatMessage>;
		/** chat server **/
		private var _server:IChatServer;
		/** display theme **/
		private var _theme:IChatTheme;
		/** the reply window */
		private var _replyWindow:ReplyWindow;
		/** the width of the stage */
		private var _stageDimensions:Point;
		
		
		/** Current state of the chat console <ul><li>OPEN</li><li>CLOSED</li><li>TRANSITIONING</li><li>KEYBOARD_OPEN</li><li>KEYBOARD_CLOSED</li></ul>**/
		private var _state:String;
		
		public function ChatConsole(server:IChatServer, theme:IChatTheme)
		{	
			// Definitions
			_server = server;
			_theme = theme;
			_state = ChatUtil.CLOSED;

			// instantiate objects
			_chatMessageContainer = new Sprite();
			_chatMessages = new Vector.<ChatMessage>();
			_replyWindow = new ReplyWindow(theme.replyWindowBackgroundColor, theme.replyWindowTextBoxColor);
			
			// add listeners
			_replyWindow.addEventListener(ChatUtil.SHOW_KEYBOARD, onShowKeyboard);
			_replyWindow.addEventListener(ChatUtil.HIDE_KEYBOARD, onHideKeyboard);
			_server.addListener(onDataRetrieved);
			addEventListener(Event.RESIZE, onResize);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		/**
		 * Added to stage callback
		 */
		private function onAddedToStage(event:Event):void
		{	
			// Resets the position of the and sizing of the console
			resetStageLoc();
			
			// add children
			addChild(_background);
			addChild(_chatMessageContainer);
			addChild(_replyWindow.view);
			
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
		 * Repositions this objects children
		 */
		private function layout():void
		{
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
			_replyWindow.y = height - _replyWindow.height;// - 480;
		}
		
		private function resetStageLoc():void
		{
			// get the stage dimensions of the parent
			var parentStageDimensions:Point = ChatUtil.stageDimensions(parent);
			// add obects to the stage here to correctly acquire dimensions in this space.
			_stageDimensions = ChatUtil.stageDimensions(this);
			
			// Define console location
			x = parentStageDimensions.x;
			y = 0;
			
			// add a background to the console
			_background = new Quad(_theme.width, _stageDimensions.y,_theme.backgroundColor);
		}
		
		
		/**
		 * Data retrieval complete function 
		 */
		private function onDataRetrieved():void
		{
			_chatMessages = _server.getData();
			
			// add the messages to the console
			for(var i:int = 0; i < _chatMessages.length; ++i)
				_chatMessageContainer.addChild(_chatMessages[i].view);
			
			// reorganize the layout when new chatmessages are received 
			layout();
		}
		
		/**
		 * Show Keyboard callback 
		 */
		private function onShowKeyboard(event:Event):void
		{
			// Remove tween if tween exists
			clearTween();
			
			// slide console up
			_state = ChatUtil.TRANSITIONING;
			_tween = new Tween(this, .75);
			_tween.onComplete = onKeyboardOpenComplete;
			//_tween.moveTo(_theme.openLoc, y);
		}
		
		/**
		 * hide Keyboard callback 
		 */
		private function onHideKeyboard(event:Event):void
		{
			// Remove tween if tween exists
			clearTween();
			
			// slide console down
			_state = ChatUtil.TRANSITIONING;
			_tween = new Tween(this, .75);
			_tween.onComplete = onKeyboardCloseComplete;
			//_tween.moveTo(_theme.openLoc, y);
		}
		
		/**
		 * Display Console
		 */
		public function show():void
		{
			var openLoc:Number = _stageDimensions.x - _theme.width;
			
			// Remove tween if tween exists
			clearTween();
			
			_state = ChatUtil.TRANSITIONING;
			_tween = new Tween(this, _theme.openCloseTransitionTime, _theme.openCloseTransitionType);
			_tween.onComplete = onOpenComplete;
			_tween.moveTo(openLoc, y);
			Starling.juggler.add(_tween);
		}
		
		/**
		 * Hide Console
		 */
		public function hide():void
		{	
			// Remove tween if tween exists
			clearTween();
			
			_state = ChatUtil.TRANSITIONING;
			_tween = new Tween(this, _theme.openCloseTransitionTime, _theme.openCloseTransitionType);
			_tween.onComplete = onCloseComplete;
			_tween.moveTo(_stageDimensions.x, y);
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
			_state = ChatUtil.KEYBOARD_CLOSED;
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
		 * Disposes of the Chat console Window
		 */
		override public function dispose():void
		{
			var i:int = 0;
			for(i = 0; i < _chatMessages.length; ++i)
			{
				_chatMessages[i].dispose()
			}
			
			_chatMessageContainer.dispose();
			_replyWindow.dispose();
		}
	}
}