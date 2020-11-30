package fovea.chat.message
{	
	import fovea.chat.ChatConsole;
	import fovea.chat.ChatUtil;
	import fovea.chat.message.ChatMessage;
	
	import starling.display.Quad;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.utils.Align;

	public class UserMessageDisplay extends ChatMessageDisplay
	{
		/** background quad */
		private var _background:Quad;
		/** avatar image */
		private var _avatarImage:AvatarImage;
		/** Message textField */
		private var _messageTF:TextField;
		/** Time textField */
		private var _timeTF:TextField;
		/** state icon container */
		private var _loadingStateIcon:LoadingStateIcon;
		/** Display configuration */
		private var _config:ChatMessageDisplayConfig;
		
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
			_config = config;
			var message:String = data.message;
			var mdu:MessageDisplayUtil = MessageDisplayUtil.getInstance();
			
			if (message.length > mdu.MAX_CHARACTERS-1)
				message = message.substr(0,mdu.MAX_CHARACTERS-1)+"...";
			
			// Instantiates Objects
			_background = new Quad(1,1,config.backgroundColor);
			_background.alpha = config.backgroundAlpha;
			_background.visible = false;
			_loadingStateIcon = new LoadingStateIcon();
			
			_avatarImage = new AvatarImage(config.avatarLoadFailedTexture, config.avatarLoadingTexture, config.enableAvatar ? 1.0 : 0.5);
			_messageTF = new TextField(mdu.MESSAGE_TEXT_WIDTH, mdu.MESSAGE_TEXT_HEIGHT);
			_messageTF.text = message;
			_messageTF.format.setTo(mdu.MESSAGE_TEXT_FONT_NAME, mdu.MESSAGE_TEXT_FONT_SIZE, mdu.MESSAGE_TEXT_COLOR);
			_timeTF = new TextField(mdu.TIME_TEXT_WIDTH, mdu.TIME_TEXT_HEIGHT);
			_timeTF.text = data.time;
			_timeTF.format.setTo(mdu.TIME_TEXT_FONT_NAME, mdu.TIME_TEXT_FONT_SIZE, mdu.TIME_TEXT_COLOR);
			
			// initialize objects
			_loadingStateIcon.width = _loadingStateIcon.height = mdu.LOADING_STATE_ICON_SIZE;
			//scaleX = .3;
			//_loadingStateIcon.scaleY = .3; 
			
			// set text field vars
			
			_messageTF.format.horizontalAlign = Align.LEFT
			_messageTF.autoSize = TextFieldAutoSize.VERTICAL;
			if (_config.isFromMe)
				_messageTF.alpha = 0.7;
			
			_timeTF.format.horizontalAlign = Align.RIGHT;
			_timeTF.format.bold = true;
			_timeTF.alpha = 0.5;
			
			// add the children
			addChild(_background);
			if (_avatarImage)
				addChild(_avatarImage);
			addChild(_messageTF);
			addChild(_timeTF);
			if (state == ChatMessage.STATE_IN_PROGRESS)
				addChild(_loadingStateIcon);

			// add event listeners
			if (_avatarImage)
				_avatarImage.addEventListener(ChatUtil.LOAD_SUCCESS, onAvatarImageLoaded);
		}
		
		/**
		 * Loads an avatar image
		 * @param url:string - url of the loaded image
		 */
		public function loadAvatarImage(url:String):void
		{
			if (_avatarImage)
				_avatarImage.load(url);
		}
		
		/**
		 * Defines the chat message layout
		 */
		override public function layout(consoleWidth:Number):void	
		{
			var mdu:MessageDisplayUtil = MessageDisplayUtil.getInstance();
			
			// Define the message location
			_timeTF.x = consoleWidth - _timeTF.width - _loadingStateIcon.width;
			_timeTF.y = mdu.TIME_TEXT_Y;

			// Define the message location
			var offsetX:Number = _config.isFromMe ? mdu.BOTTOM_PADDING : 0;
			_messageTF.x = mdu.MESSAGE_TEXT_X + offsetX;
			_messageTF.y = mdu.MESSAGE_TEXT_Y;
			_messageTF.width = mdu.MESSAGE_TEXT_WIDTH - offsetX;
			
			_background.x = this.width - ChatConsole.theme.borderWidth;
			_background.width = this.width - ChatConsole.theme.borderWidth;
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
			if (_avatarImage) {
				_avatarImage.x = MessageDisplayUtil.getInstance().AV_IMAGE_X;
				var top:Number = _messageTF.bounds.top;
				var bottom:Number = _messageTF.bounds.bottom;
				_avatarImage.y = (bottom + top) * 0.5 - _avatarImage.height * 0.5;
			}
		}
		
		/**
		 * Dipose of this object
		 */
		override public function dispose():void
		{
			if (_avatarImage) {
				_avatarImage.removeEventListeners();
				// _avatarImage.dispose();
			}
			//_messageTF.dispose();
			//_background.dispose();
            super.dispose();
		}
	}
}
