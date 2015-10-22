package fovea.chat.message
{
	import starling.display.DisplayObjectContainer;
	import starling.display.Quad;
	import starling.text.TextField;
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
		
		public function UserMessageDisplay(data:ChatMessageData, config:ChatMessageDisplayConfig)
		{
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
			
			_timeTF.hAlign = HAlign.LEFT
			_timeTF.bold = true;
			
			// add the children
			addChild(_background);
			addChild(_avatarImage);
			addChild(_userNameTF);
			addChild(_messageTF);
			addChild(_timeTF);
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
		 * redefines the chat message layout
		 */
		override public function layout(consoleWidth:Number):void	
		{
			// Define the avatar image location
			_avatarImage.x = MessageDisplayUtil.AV_IMAGE_X;
			_avatarImage.y = MessageDisplayUtil.AV_IMAGE_Y;
			
			// Define the username location
			_userNameTF.x = MessageDisplayUtil.NAME_TEXT_X;
			_userNameTF.y = MessageDisplayUtil.NAME_TEXT_Y;
			
			// Define the message location
			_messageTF.x = MessageDisplayUtil.MESSAGE_TEXT_X;
			_messageTF.y = MessageDisplayUtil.MESSAGE_TEXT_Y;
			
			// Define the message location
			_timeTF.x = consoleWidth - _timeTF.width;
			_timeTF.y = MessageDisplayUtil.TIME_TEXT_Y;
			
			_background.width = this.width;
			_background.height = this.height;
		}
		
		/**
		 * Dipose of this object children
		 */
		override public function dispose():void
		{
			_userNameTF.dispose();
			_messageTF.dispose();
			_avatarImage.dispose();
			_background.dispose();
		}
	}
}