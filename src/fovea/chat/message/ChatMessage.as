package fovea.chat.message
{	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import fovea.chat.Controller;
	import fovea.chat.configs.DefaultChatMessageDisplayConfig;

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
		/** a timer for a chat message time out */
		private var _timeoutTimer:Timer;
		
		/** The chat Message Display */
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
		public function set state(value:int):void 
		{
			_state = value;
			view.state = value;
		}
		
		/** user that sent this message */
		public function get userName():String {return _data.username;}
		public function set userName(value:String):void {_data.username = value;}
		
		/** URL of the avatar image (always a square)  */
		public function get avatarURL():String {return _data.avatarURL;}
		public function set avatarURL(value:String):void {_data.avatarURL = value;}
		
		/** message text */
		public function get message():String {return _data.message;}
		public function set message(value:String):void {_data.message = value;}
		
		/** message text */
		public function get id():String {return _data.id;}
		public function set id(value:String):void {_data.id = value;}
		
		
		/** Retreiving message data */
		public static const STATE_IN_PROGRESS:int = 0;
		/** Successful retrieval of message data */
		public static const STATE_SUCCESS:int = 1;
		/** Unsuccessful retrieval of message data */
		public static const STATE_FAILED:int = 2;
		
		/**
		 * Instantiate a ChatMessage
		 * @param data:ChatMessageData - Data associated with this chat message
		 * @param config:ChatMessageDisplayConfig - Display Config associated with this chat message
		 */
		public function ChatMessage(data:ChatMessageData, state:int, config:ChatMessageDisplayConfig=null)
		{
			_state = state; // STATE_IN_PROGRESS;
			
			_data = data;
			
			_timeoutTimer = new Timer(5000, 1);
			_timeoutTimer.addEventListener(TimerEvent.TIMER, onTimeOut);
			_timeoutTimer.start();
			
			// If no config defined use default config
			if(!config)
				config = new DefaultChatMessageDisplayConfig();
			
			// If is system message use a system message display
			if(data.isSystemMsg)
			{
				_view = new SystemMessageDisplay(_data, config);
			}else{
				_view = new UserMessageDisplay(_data, config, state);
				(_view as UserMessageDisplay).loadAvatarImage(_data.avatarURL);
			}
		}
		
		/**
		 * Time our timer callback
		 */
		private function onTimeOut(event:TimerEvent):void
		{
			clearTimer();
			// set state to fail if still in_progress
			if(_state == STATE_IN_PROGRESS)
				view.state = STATE_FAILED;
		}
		
		/**
		 * Clears the timer
		 */
		private function clearTimer():void
		{
			_timeoutTimer.stop();
			_timeoutTimer.removeEventListener(TimerEvent.TIMER, onTimeOut);
		}
		
		/**
		 * Defines the message layout
		 * @param consoleWidth:Number - Width of the console used to define positioning of message display objects 
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
			clearTimer();
			_view.removeEventListeners();
			_view.dispose();
		}
	}
}
