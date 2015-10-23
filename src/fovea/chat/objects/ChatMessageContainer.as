package fovea.chat.objects
{
	import flash.geom.Rectangle;
	
	import feathers.controls.ScrollContainer;
	import feathers.events.FeathersEventType;
	
	import fovea.chat.ChatUtil;
	
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.events.Event;

	/**
	 * A scroll container wrapper class</br>
	 * Handles convenience methods like scrollToBottom</br>
	 * Contains getters and setters for content height and width.
	 */
	public class ChatMessageContainer extends DisplayObjectContainer
	{
		/** Scroller for the message objects */
		private var _scrollContainer:ScrollContainer;
		
		/** 
		 * content width </br>
		 * heavy function use sparingly 
		 */
		public function get contentWidth():Number
		{
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
			_scrollContainer = new ScrollContainer();
			_scrollContainer.hasElasticEdges = true;
			
			addChild(_scrollContainer);
			
			_scrollContainer.addEventListener(FeathersEventType.SCROLL_COMPLETE, onScrollComplete);
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
		 * Set the scroll containers viewport width and height 
		 * @param width:Number - viewport width
		 * @param height:Number - viewport height
		 */
		public function layout(width:Number, height:Number):void
		{
			_scrollContainer.width = width;
			_scrollContainer.height = height;
		}
		
		/** 
		 * Scroll the container to the bottom most item
		 */
		public function scrollToBottom():void
		{
			_scrollContainer.validate();
			_scrollContainer.scrollToPosition(_scrollContainer.horizontalScrollPosition, _scrollContainer.maxVerticalScrollPosition, .5);
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
			
			_scrollContainer.dispose();
		}
	}
}