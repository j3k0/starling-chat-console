package fovea.chat.message
{
	/**
	 * Chat Message data</br>
	 * <ul>
	 * 		<li>username - user that sent this message</li>
	 * 		<li>avatarURL- URL of the avatar image (always a square)</li>
	 * 		<li>message - message text</li>
	 * 		<li>time - the time that this message was sent</li>
	 * 		<li>isSystemMsg - Whether the message is a system message</li>
	 * </ul>
	 */
	public class ChatMessageData
	{
		/** user that sent this message */
		public var username:String;
		/** URL of the avatar image (always a square)  */
		public var avatarURL:String;
		/** message text */
		public var message:String;
		/** message text */
		public var time:String;
		/** Defines whether the message is a system message */
		public var isSystemMsg:Boolean;
		
		
		public function ChatMessageData(username:String, avatarURL:String, message:String, time:String)
		{
			this.username = username;
			this.avatarURL = avatarURL;
			this.message = message;
			this.time = time;
			this.isSystemMsg = username == "" || username == null ? true : false;
		}
	}
}