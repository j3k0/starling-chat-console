package fovea.chat.objects
{
	import starling.display.DisplayObjectContainer;
	import starling.text.TextField;
	import starling.utils.Color;
	import starling.utils.VAlign;

	/**
	 * Icon for a failed avatar image load 
	 */
	public class FailedLoadIcon extends DisplayObjectContainer
	{
		/** Textfield used to display an x */
		private var _text:TextField;
		
		public function FailedLoadIcon()
		{
			_text = new TextField(40,60,"X","Verdana",40, Color.RED,true);
			_text.vAlign = VAlign.TOP;
			
			addChild(_text);
		}
		
		/**
		 * Dispose of this object
		 */
		override public function dispose():void
		{
			_text.dispose();
			super.dispose();
		}
	}
}