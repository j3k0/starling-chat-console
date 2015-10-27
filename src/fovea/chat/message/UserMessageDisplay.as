package fovea.chat.message
{	
	import fovea.chat.ChatUtil;
	
	import starling.display.Quad;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.utils.HAlign;

	public class UserMessageDisplay extends ChatMessageDisplay
	{
		/** background quad */
		private var _background:Quad;
		/** background alpha */
		private var _backgroundAlpha:Number;
		/** avatar image */
		private var _avatarImage:AvatarImage;
		/** Avatar Name textField */
		private var _userNameTF:TextField;
		/** Message textField */
		private var _messageTF:TextField;
		/** Time textField */
		private var _timeTF:TextField;
		
		/**
		 * Instantiates a UserMessageDisplay
		 * @param data:ChatMessageData - Data associated with this chat message
		 * @param config:ChatMessageDisplayConfig - Display Config associated with this chat message
		 */
		public function UserMessageDisplay(data:ChatMessageData, config:ChatMessageDisplayConfig)
		{
			// Instantiates Objects
			_background = new Quad(1,1,config.backgroundColor);
			_background.alpha = config.backgroundAlpha;
			
			_avatarImage = new AvatarImage();
			_userNameTF = new TextField(620,30,data.username);
			_messageTF = new TextField(620,70,data.message);
			_timeTF = new TextField(66, 30, data.time);
			
			// set text field vars
			_userNameTF.hAlign = HAlign.LEFT
			_userNameTF.bold = true;
			
			_messageTF.hAlign = HAlign.LEFT
			_messageTF.autoSize = TextFieldAutoSize.VERTICAL;
			
			_timeTF.hAlign = HAlign.RIGHT;
			_timeTF.bold = true;
			
			// add the children
			addChild(_background);
			addChild(_avatarImage);
			addChild(_userNameTF);
			addChild(_messageTF);
			addChild(_timeTF);
			
			// add event listeners
			_avatarImage.addEventListener(ChatUtil.LOAD_SUCCESS, onAvatarImageLoaded);
		}
		
		/**
		 * Loads an avatar image
		 * @param url:string - url of the loaded image
		 */
		public function loadAvatarImage(url:String):void
		{
			_avatarImage.load(url);
		}
		
		/**
		 * Defines the chat message layout
		 */
		override public function layout(consoleWidth:Number):void	
		{
			
			// Define the username location
			_userNameTF.x = MessageDisplayUtil.NAME_TEXT_X;
			_userNameTF.y = MessageDisplayUtil.NAME_TEXT_Y;
			
			// Define the message location
			_messageTF.x = MessageDisplayUtil.MESSAGE_TEXT_X;
			_messageTF.y = MessageDisplayUtil.MESSAGE_TEXT_Y;
			_messageTF.width = consoleWidth - _messageTF.x;
			
			// Define the message location
			_timeTF.x = consoleWidth - _timeTF.width;
			_timeTF.y = MessageDisplayUtil.TIME_TEXT_Y;
			
			_background.width = this.width;
			_background.height = _messageTF.bounds.bottom + MessageDisplayUtil.BOTTOM_PADDING;
			
			// Position the avatar image
			positionAvatarImage();
		}
		
		/**
		 * Avatar image loaded callback
		 */
		private function onAvatarImageLoaded(event:Event):void
		{
			positionAvatarImage()
		}
		
		/**
		 * Positions the avatar image based upon the image height and text height.
		 */
		private function positionAvatarImage():void
		{
			// Define the avatar image location
			_avatarImage.x = MessageDisplayUtil.AV_IMAGE_X;
			_avatarImage.y = ((_messageTF.bounds.bottom - _userNameTF.bounds.top) >> 1);
		}
		
		/**
		 * Dipose of this object
		 */
		override public function dispose():void
		{
			_avatarImage.removeEventListeners();
			
			_userNameTF.dispose();
			_messageTF.dispose();
			_avatarImage.dispose();
			_background.dispose();
		}
	}
}