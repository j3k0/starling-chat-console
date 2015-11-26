package fovea.chat.message
{	
	import fovea.chat.ChatUtil;
	import fovea.chat.message.ChatMessage;
	
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
		/** state icon container */
		private var _loadingStateIcon:LoadingStateIcon;
		
		/**
		 * Sets the state of the avatar image
		 */
		override public function set state(value:int):void 
		{
			_loadingStateIcon.state = value;
		}
		
		/**
		 * Instantiates a UserMessageDisplay
		 * @param data:ChatMessageData - Data associated with this chat message
		 * @param config:ChatMessageDisplayConfig - Display Config associated with this chat message
		 */
		public function UserMessageDisplay(data:ChatMessageData, config:ChatMessageDisplayConfig, state:int)
		{
			var message:String = data.message;
			var mdu:MessageDisplayUtil = MessageDisplayUtil.getInstance();
			
			if (message.length > mdu.MAX_CHARACTERS-1)
				message = message.substr(0,mdu.MAX_CHARACTERS-1)+"...";
			
			// Instantiates Objects
			_background = new Quad(1,1,config.backgroundColor);
			_background.alpha = config.backgroundAlpha;
			_loadingStateIcon = new LoadingStateIcon();
			
			_avatarImage = new AvatarImage(config.avatarLoadFailedTexture, config.avatarLoadingTexture);
			_userNameTF = new TextField(mdu.NAME_TEXT_WIDTH, mdu.NAME_TEXT_HEIGHT, data.username, mdu.NAME_TEXT_FONT_NAME, mdu.NAME_TEXT_FONT_SIZE, mdu.NAME_TEXT_COLOR);
			_messageTF = new TextField(mdu.MESSAGE_TEXT_WIDTH, mdu.MESSAGE_TEXT_HEIGHT, message, mdu.MESSAGE_TEXT_FONT_NAME, mdu.MESSAGE_TEXT_FONT_SIZE, mdu.MESSAGE_TEXT_COLOR);
			_timeTF = new TextField(mdu.TIME_TEXT_WIDTH, mdu.TIME_TEXT_HEIGHT, data.time, mdu.TIME_TEXT_FONT_NAME, mdu.TIME_TEXT_FONT_SIZE, mdu.TIME_TEXT_COLOR);
			
			// initialize objects
			_loadingStateIcon.width = _loadingStateIcon.height = mdu.LOADING_STATE_ICON_SIZE;
			//scaleX = .3;
			//_loadingStateIcon.scaleY = .3; 
			
			// set text field vars
			_userNameTF.hAlign = HAlign.LEFT
			_userNameTF.bold = true;
			
			_messageTF.hAlign = HAlign.LEFT
			_messageTF.autoSize = TextFieldAutoSize.VERTICAL;
			
			_timeTF.hAlign = HAlign.RIGHT;
			_timeTF.bold = true;
			_timeTF.alpha = 0.5;
			
			// add the children
			addChild(_background);
			addChild(_avatarImage);
			addChild(_userNameTF);
			addChild(_messageTF);
			addChild(_timeTF);
			if (state == ChatMessage.STATE_IN_PROGRESS)
				addChild(_loadingStateIcon);

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
			var mdu:MessageDisplayUtil = MessageDisplayUtil.getInstance();
			
			// Define the username location
			_userNameTF.x = mdu.NAME_TEXT_X;
			_userNameTF.y = mdu.NAME_TEXT_Y;
			
			// Define the message location
			_timeTF.x = consoleWidth - _timeTF.width - _loadingStateIcon.width;
			_timeTF.y = mdu.TIME_TEXT_Y;

			// Define the message location
			_messageTF.x = mdu.MESSAGE_TEXT_X;
			_messageTF.y = mdu.MESSAGE_TEXT_Y;
			_messageTF.width = mdu.MESSAGE_TEXT_WIDTH;
			//_messageTF.width = _timeTF.x - _messageTF.x;
			
			_background.width = this.width;
			_background.height = _messageTF.bounds.bottom + mdu.BOTTOM_PADDING;
			
			// position the loading state icon
			_loadingStateIcon.x = consoleWidth - _loadingStateIcon.width;
			_loadingStateIcon.y = mdu.TIME_TEXT_Y;
			
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
			_avatarImage.x = MessageDisplayUtil.getInstance().AV_IMAGE_X;
			_avatarImage.y = (_messageTF.bounds.bottom - _userNameTF.bounds.top) * 0.5/* - _avatarImage.height * 0.5*/;
		}
		
		/**
		 * Dipose of this object
		 */
		override public function dispose():void
		{
			_avatarImage.removeEventListeners();
			_avatarImage.dispose();
			
			_userNameTF.dispose();
			_messageTF.dispose();
			_background.dispose();
		}
	}
}
