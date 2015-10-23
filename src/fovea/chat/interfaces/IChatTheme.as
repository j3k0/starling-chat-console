package fovea.chat.interfaces
{
	/**
	 * Interface for the functional and visual porperties of a ChatConsole.</br>
	 * Properties:
	 * <ul>
	 * 	<li>isMobile</li>
	 * 	<li>backgroundColor</li>
	 * 	<li>width</li>
	 * 	<li>openCloseTransitionTime</li>
	 * 	<li>openCloseTransitionType</li>
	 * 	<li>replyWindowBackgroundColor</li>
	 * 	<li>replyWindowTextBoxColor</li>
	 * </ul> 
	 */
	public interface IChatTheme
	{	
		/**
		 * Define if the platform is mobile
		 */
		function get isMobile():Boolean;
		
		/**
		 * Background Color of the chat console window
		 */
		function get backgroundColor():uint;
		
		/**
		 * Width of the chat console, defines where the chat rests when opened.
		 */
		function get width():Number;
		
		
		/**
		 * Length of time for the open and close transition animations</br>
		 *  (in Seconds)
		 */
		function get openCloseTransitionTime():Number;
		
		
		/**
		 * Type of Ease used in the open and close animations
		 * <ul>
		 * 	<li>linear</li>
		 * 	<li>easeIn</li>
		 * 	<li>easeOut</li>
		 * 	<li>easeInOut</li>
		 * 	<li>easeOutIn</li>
		 * 	<li>easeInBack</li>
		 * 	<li>easeOutBack</li>
		 * 	<li>easeInOutBack</li>
		 * 	<li>easeOutInBack</li>
		 * 	<li>easeInBounce</li>
		 * 	<li>easeOutBounce</li>
		 * 	<li>easeInOutBounce</li>
		 * 	<li>easeOutInBounce</li>
		 * 	<li>easeInElastic</li>
		 * 	<li>easeOutElastic</li>
		 * 	<li>easeInOutElastic</li>
		 * 	<li>easeOutInElastic</li>
		 * </ul>
		 */
		function get openCloseTransitionType():String;
		
		/**
		 * Background color of the reply window
		 */
		function get replyWindowBackgroundColor():uint;
		
		/**
		 * Background color of the reply window text area
		 */
		function get replyWindowTextBoxColor():uint;
	}
}