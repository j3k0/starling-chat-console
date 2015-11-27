package fovea.chat.objects
{
	import fovea.chat.ChatConsole;

	import starling.display.DisplayObjectContainer;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
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
			_text = new TextField(60 * ChatConsole.theme.scaleFactor,
														80 * ChatConsole.theme.scaleFactor,
														"x", "Verdana",
														50 * ChatConsole.theme.scaleFactor, Color.RED, true);
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
