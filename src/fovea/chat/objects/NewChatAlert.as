package fovea.chat.objects
{
	import flash.geom.Point;
	
	import fovea.chat.ChatUtil;
	
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.DisplayObjectContainer;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.utils.Color;

	/**
	 * Displays an alert that a new chat has been added to the feed 
	 */
	public class NewChatAlert extends DisplayObjectContainer
	{
		/** background */
		private var _background:Quad
		
		/** text field */
		private var _text:TextField;
		
		/** Container that this object is added to */
		private var _displayParent:DisplayObjectContainer;
		
		/** alpha tween fo this object */
		private var _tween:Tween;
		
		/** the current state of the new text display 
		    <ul><li>OPEN</li><li>CLOSED</li><li>TRANSITIONING</li></ul>*/
		private var _state:String;
		
		/** Background PADDING around the text */
		public static const PADDING:Number = 5;
		/** Background of the NewChatAlert */ 
		private static const BACKGROUND_COLOR:uint = 0xBAC9DE;
		/** String to dispaly in the NewChatAlert */
		private static const DISPLAY_TEXT:String = "new_chat_message";
		
		public function NewChatAlert(displayParent:DisplayObjectContainer)
		{
			// Instantiate objects
			_background = new Quad(1,1,BACKGROUND_COLOR);
			_text = new TextField(100,30,ChatUtil.translate(DISPLAY_TEXT),"Verdana", 12, Color.WHITE, true);
			
			// Initialize Variables
			_displayParent = displayParent;
			_state = ChatUtil.CLOSED;
			
			//alpha = 0;
			// Define the text position
			_text.x = PADDING;
			_text.y = PADDING;
			
			// Define the background size
			_background.width = _text.width + (PADDING * 2);
			_background.height = _text.height + (PADDING * 2); 
			
			//Add children
			addChild(_background);
			addChild(_text);
		}
		
		/**
		 * Display new chat alert
		 */
		public function show():void
		{
			if(_state != ChatUtil.CLOSED)
				return;
			if (!stage)
				return;
			
			clearTween();
			
			_displayParent.addChild(this);
			
			_state = ChatUtil.TRANSITIONING;
			_tween = new Tween(this, .25);
			_tween.fadeTo(1);
			_tween.onComplete = onShowComplete; 
			Starling.current.juggler.add(_tween);
			
			stage.addEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		/**
		 * Display new chat alert
		 */
		public function hide():void
		{	
			if(_state != ChatUtil.OPEN)
				return;
			
			clearTween();
			
			_state = ChatUtil.TRANSITIONING;
			_tween = new Tween(this, .25);
			_tween.fadeTo(0);
			_tween.onComplete = onHideComplete;
			Starling.current.juggler.add(_tween);
			
			stage.removeEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		/**
		 * Show transition complete callback
		 */
		private function onShowComplete():void
		{
			_state = ChatUtil.OPEN;
		}
		
		/**
		 * Hide transition complete callback
		 */
		private function onHideComplete():void
		{
			_state = ChatUtil.CLOSED;
			if(_displayParent.contains(this))
				_displayParent.removeChild(this);
		}
		
		/**
		 * Stage touch event callback</br>
		 * Checks to see of the aler has been tapped
		 */
		private function onTouch(event:TouchEvent):void
		{
			if(_state != ChatUtil.OPEN)
				return;
			
			var touch:Touch = event.getTouch(stage);
			if(touch)
			{
				var touchPoint:Point = parent.globalToLocal(new Point(touch.globalX, touch.globalY)); 
				// if the user touches and the point is in this obect confines dispatch troggered
				if(touch.phase == TouchPhase.BEGAN && bounds.contains(touchPoint.x, touchPoint.y))
				{
					dispatchEventWith(Event.TRIGGERED);
				}
			}
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
		 * Dispose of this object
		 */
		override public function dispose():void
		{
			_displayParent = null;
			
			clearTween();
			_background.dispose();
			_text.dispose();
			
			super.dispose();
		}
	}
}
