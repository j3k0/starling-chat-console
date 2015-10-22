package fovea.chat.reply_window
{
	import fovea.chat.ChatUtil;
	import fovea.chat.Controller;

	/**
	 * Chat message reply window controller</br>
	 * Handles:
	 * <ul>
	 * 		<li>Displaying the keyboard</li>
	 * 		<li>Passing data to the view </li>
	 * </ul>
	 */
	public class ReplyWindow extends Controller
	{	
		/** ReplyWindow Display */
		public function get view():ReplyWindowDisplay {return _view as ReplyWindowDisplay;}
		
		public function ReplyWindow(backgroundColor:uint, textboxColor:uint)
		{
			_view = new ReplyWindowDisplay(backgroundColor, textboxColor);
		}
		
		/**
		 * Displays a keyboard for chat input
		 */
		public function displayKeyboard():void
		{
			dispatchEventWith(ChatUtil.SHOW_KEYBOARD);
		}
		
		/**
		 * Hides a keyboard for chat input
		 */
		public function hideKeyboard():void
		{
			dispatchEventWith(ChatUtil.HIDE_KEYBOARD);
		}
		
		/**
		 * Defines the positioning and size of the reply window
		 */
		public function layout(consoleWidth:Number):void
		{
			view.layout(consoleWidth);
		}
		
		/**
		 * Disposes of th is object
		 */
		public function dispose():void
		{
			_view.dispose();
		}
	}
}