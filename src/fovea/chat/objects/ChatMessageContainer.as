package fovea.chat.objects
{
	import com.alanmacdougall.underscore._;

	import flash.geom.Rectangle;
	
	import feathers.controls.ScrollContainer;
	import feathers.events.FeathersEventType;
	
	import fovea.chat.ChatConsole;
	import fovea.chat.ChatUtil;
	
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.events.Event;
	import feathers.controls.ScrollPolicy;

	/**
	 * A scroll container wrapper class</br>
	 * Handles convenience methods like scrollToBottom</br>
	 * Contains getters and setters for content height and width.
	 */
	public class ChatMessageContainer extends DisplayObjectContainer
	{
		/** Scroller for the message objects */
		private var _scrollContainer:ScrollContainer;
		
		/** the current scroll position on the y - axis */
		public function get scrollPosition():Number
		{
			return _scrollContainer.verticalScrollPosition;
		}
		
		/** the maximum scroll position on the y - axis */
		public function get maxScrollPosition():Number
		{
			return _scrollContainer.maxVerticalScrollPosition;
		}
		
		/** 
		 * content width </br>
		 * heavy function use sparingly 
		 */
		public function get contentWidth():Number
		{
			return ChatConsole.theme.width;
			/*
			var contentRect:Rectangle = new Rectangle();
			for (var i:int = 0; i < _scrollContainer.numChildren; ++i)
			{
				var child:DisplayObject = _scrollContainer.getChildAt(i);
				if(child.x < contentRect.x)
					contentRect.left = child.x;
				if(child.x + child.width > contentRect.right)
					contentRect.right = child.x + child.width;
			}
			return contentRect.width;
			*/
		}
		
		/** 
		 * content height </br>
		 * heavy function use sparingly
		 */
		public function get contentHeight():Number
		{
			var contentRect:Rectangle = new Rectangle();
			for (var i:int = 0; i < _scrollContainer.numChildren; ++i)
			{
				var child:DisplayObject = _scrollContainer.getChildAt(i);
				if(child.y < contentRect.y)
					contentRect.top = child.y;
				if(child.y + child.height > contentRect.bottom)
					contentRect.bottom = child.y + child.height;
			}
			return contentRect.height;
		}
		
		/**
		 * Instantiate ChatMessageContainer
		 */
		public function ChatMessageContainer()
		{
			scrollToBottom = _.throttle(_scrollToBottom, millis(SCROLL_BOTTOM_DURATION + 0.1));
			_scrollContainer = new ScrollContainer();
			_scrollContainer.hasElasticEdges = true;
			_scrollContainer.horizontalScrollPolicy = ScrollPolicy.OFF;
			
			// Add the scroll window
			addChild(_scrollContainer);
			
			_scrollContainer.addEventListener(FeathersEventType.SCROLL_COMPLETE, onScrollComplete);
			_scrollContainer.addEventListener(FeathersEventType.SCROLL_START, function(event:Event):void {
                ChatConsole.boostFPS(3);
            });
		}
		
		/** 
		 * Adds an object to the scroll container 
		 * @param child:DisplayObject - child to add to the scroller
		 */
		public function addItem(child:DisplayObject):void
		{
			_scrollContainer.addChild(child);
		}
		
		/** 
		 * Removes an object from the scroll container 
		 * @param child:DisplayObject - child to add to the scroller
		 */
		public function removeItem(child:DisplayObject):void
		{
			_scrollContainer.removeChild(child);
		}
		
		/** 
		 * Set the scroll containers viewport width and height 
		 * @param width:Number - viewport width
		 * @param height:Number - viewport height
		 */
		public function layout(width:Number, height:Number):void
		{
			_scrollContainer.width = width;
			_scrollContainer.height = height;
			_scrollContainer.validate();
			_scrollContainer.readjustLayout();
		}

		private const SCROLL_BOTTOM_DURATION:Number = 0.5;
		private var _isScrollingBottom:int = 0;
		public function get isScrollingBottom():Boolean {
			return _isScrollingBottom > 0;
		}
		
		/** 
		 * Scroll the container to the bottom most item
		 */
		private function _scrollToBottom():void
		{
			_scrollContainer.validate();
			_scrollContainer.scrollToPosition(_scrollContainer.horizontalScrollPosition, _scrollContainer.maxVerticalScrollPosition, SCROLL_BOTTOM_DURATION);
			_.delay(function():void {
				_isScrollingBottom --;
			}, millis(SCROLL_BOTTOM_DURATION));
			_isScrollingBottom ++;
		}

		/**
		 * Scroll the container to the bottom most item, debounced
		 *
		 * Initialized in the constructor
		 */
		public var scrollToBottom:Function;
		
		/**
		 * Remove all messages from the view
		 */
		public function clearMessages():void
		{
			_scrollContainer.removeChildren();
		}
		
		/**
		 * Scroll Complete callback
		 */
		private function onScrollComplete(event:Event):void
		{
			if(_scrollContainer.verticalScrollPosition >= _scrollContainer.maxVerticalScrollPosition)
				dispatchEventWith(ChatUtil.SCROLLER_BOTTOM_REACHED);
		}
		
		/**
		 * Disposes of this object
		 */
		override public function dispose():void
		{
			_scrollContainer.removeEventListeners();
			super.dispose();
			//_scrollContainer.dispose();
		}

		private function millis(s:Number):Number { return s * 1000; }
	}
}
