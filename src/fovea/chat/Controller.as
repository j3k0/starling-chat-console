package fovea.chat
{	
	import starling.display.DisplayObjectContainer;
	import starling.events.EventDispatcher;

	/**
	 * Abstract class</br>
	 * Defines convenience functions for an objects view properties. 
	 */
	public class Controller extends EventDispatcher
	{
		protected var _view:DisplayObjectContainer;
		
		/** The x coordinate of the object relative to the local coordinates of the parent. */
		public function set x(value:Number):void {_view.x = value;}
		public function get x():Number {return _view.x;}
		
		/** The y coordinate of the object relative to the local coordinates of the parent. */
		public function get y():Number {return _view.y;}
		public function set y(value:Number):void {_view.y = value;}
		
		/** The width the object relative to the local coordinates of the parent. */
		public function get width():Number {return _view.width;}
		public function set width(value:Number):void {_view.width = value;}
		
		/** The height of the object relative to the local coordinates of the parent. */
		public function get height():Number {return _view.height;}
		public function set height(value:Number):void {_view.height = value;}
		
		public function Controller()
		{}
	}
}