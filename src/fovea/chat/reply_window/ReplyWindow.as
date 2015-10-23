package fovea.chat.reply_window
{
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
		
		/**
		 * Instantiates a ReplyWindow controller
		 * @param backgroundColor:uint - Background color of the ReplyWindow
		 * @param textboxColor:uint - Background color of the ReplyWindow TextArea
		 */
		public function ReplyWindow(backgroundColor:uint, textboxColor:uint)
		{
			_view = new ReplyWindowDisplay(backgroundColor, textboxColor);
		}
		
		/**
		 * Defines the positioning and size of the reply window
		 * @param consoleWidth:Number - The width of the chat console used for children sizig and positioning
		 */
		public function layout(consoleWidth:Number):void
		{
			view.layout(consoleWidth);
		}
		
		/**
		 * Disposes of this object
		 */
		public function dispose():void
		{
			_view.dispose();
		}
	}
}