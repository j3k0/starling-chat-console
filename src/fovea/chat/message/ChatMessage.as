package fovea.chat.message
{	
	import fovea.chat.ChatUtil;
	import fovea.chat.Controller;
	
	import starling.events.Event;

	/**
	 * Controller for a specific chat message instance</br>
	 * Handles:
	 *  <ul>
	 * 		<li>Interface to the view</li>
	 *  </ul>
	 */
	public class ChatMessage extends Controller
	{
		/** The data associated with the chat message */
		private var _data:ChatMessageData;
		/** current state of the message */
		private var _state:int;
		
		public function get view():ChatMessageDisplay
		{
			return _view as ChatMessageDisplay;
		}
		
		/** 
		 * current state of the message</br>
		 *  STATE_IN_PROGRESS - Retreiving message data</br>
		 *  STATE_SUCCESS     - Successful retrieval of message data</br>
		 *  STATE_FAILED      - Unsuccessful retrieval of message data
		 */
		public function get state():int {return _state;}
		public function set state(value:int):void {_state = value;}
		
		/** user that sent this message */
		public function get userName():String {return _data.username;}
		public function set userName(value:String):void {_data.username = value;}
		
		/** URL of the avatar image (always a square)  */
		public function get avatarURL():String {return _data.avatarURL;}
		public function set avatarURL(value:String):void {_data.avatarURL = value;}
		
		/** message text */
		public function get message():String {return _data.message;}
		public function set message(value:String):void {_data.message = value;}
		
		
		/** Retreiving message data */
		public static const STATE_IN_PROGRESS:int = 0;
		/** Successful retrieval of message data */
		public static const STATE_SUCESS:int = 1;
		/** Unsuccessful retrieval of message data */
		public static const STATE_FAILED:int = 2;
		
		public function ChatMessage(data:ChatMessageData, config:ChatMessageDisplayConfig=null)
		{
			_state = STATE_IN_PROGRESS;
			
			_data = data;
			if(data.isSystemMsg)
			{
				_view = new SystemMessageDisplay(_data, config);
			}else{
				_view = new UserMessageDisplay(_data, config);
				(_view as UserMessageDisplay).loadAvatarImage(_data.avatarURL);
			}
			_view.addEventListener(ChatUtil.LOAD_SUCCESS, onLoadSuccess);
			_view.addEventListener(ChatUtil.LOAD_FAIL, onLoadFail);
		}
		
		public function layout(consoleWidth:Number):void
		{
			view.layout(consoleWidth);
		}
		
		private function onLoadSuccess(event:Event):void
		{
			event.stopImmediatePropagation();
			_state = STATE_SUCESS;
		}
		
		private function onLoadFail(event:Event):void
		{
			event.stopImmediatePropagation();
			_state = STATE_FAILED;
		}
		
		public function dispose():void
		{
			_view.removeEventListeners();
			_view.dispose();
		}
	}
}