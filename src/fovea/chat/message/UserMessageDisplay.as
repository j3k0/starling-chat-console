package fovea.chat.message
{	
	import fovea.chat.ChatConsole;
	import fovea.chat.ChatUtil;
	import fovea.chat.message.ChatMessage;
    import fovea.utils.Locale;
	
    import flash.globalization.DateTimeStyle;

	import starling.display.Quad;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.utils.Align;
	import feathers.controls.text.StageTextTextEditor;
	import starling.events.TouchEvent;
	import flash.text.TextFormatAlign;

	public class UserMessageDisplay extends ChatMessageDisplay
	{
		/** background quad */
		private var _background:Quad;
		/** avatar image */
		private var _avatarImage:AvatarImage;
		/** Username textField */
		private var _usernameTF:TextField;
		/** Message textField */
		private var _messageTF:StageTextTextEditor;
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
			
			if(config.enableAvatar) {
				_avatarImage = new AvatarImage(config.avatarLoadFailedTexture, config.avatarLoadingTexture, config.enableAvatar ? 1.0 : 0.5);

				_usernameTF = new TextField(mdu.MESSAGE_TEXT_WIDTH, mdu.MESSAGE_TEXT_HEIGHT);
				_usernameTF.text = data.userDisplaName;//xxxx
				_usernameTF.format.setTo(mdu.NAME_TEXT_FONT_NAME, mdu.NAME_TEXT_FONT_SIZE, mdu.NAME_TEXT_COLOR);
				_usernameTF.format.bold = false;
				_usernameTF.format.horizontalAlign = Align.CENTER;
				_usernameTF.format.verticalAlign = Align.TOP;
				_usernameTF.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
			}
			const stte:StageTextTextEditor = new StageTextTextEditor();
			_messageTF = stte;
			stte.text = message; // formatMessage(message);
			stte.fontFamily = 'Helvetica';
			stte.fontSize = mdu.MESSAGE_TEXT_FONT_SIZE;
			stte.multiline = true;
			stte.isEditable = false;
			if (_config.isFromMe) {
				stte.textAlign = TextFormatAlign.RIGHT;
				stte.color = mdu.MESSAGE_TEXT_COLOR;
			}
			else {
				stte.textAlign = TextFormatAlign.START;
				stte.color = mdu.REPLY_TEXT_COLOR;
			}
			stte.validate();
			/*
			_messageTF = new TextField(mdu.MESSAGE_TEXT_WIDTH, mdu.MESSAGE_TEXT_HEIGHT);
			_messageTF.text = message;
						_messageTF.format.bold = false;
			if (_config.isFromMe){
				_messageTF.format.setTo(mdu.MESSAGE_TEXT_FONT_NAME, mdu.MESSAGE_TEXT_FONT_SIZE, mdu.REPLY_TEXT_COLOR);
				_messageTF.format.horizontalAlign = Align.RIGHT;
			}
			else {
				_messageTF.format.setTo(mdu.MESSAGE_TEXT_FONT_NAME, mdu.MESSAGE_TEXT_FONT_SIZE, mdu.MESSAGE_TEXT_COLOR);
				_messageTF.format.horizontalAlign = Align.LEFT;
			}
			*/

			_timeTF = new TextField(mdu.TIME_TEXT_WIDTH, mdu.TIME_TEXT_HEIGHT);
			_timeTF.autoSize = TextFieldAutoSize.VERTICAL;

			var date:Date = new Date(data.time);
			var dateString:String = Locale.instance().dateFormatter.format(date);
			// if date.time (sent by the server) includes only an hour, print it as is
			if (dateString) {
				_timeTF.text = dateString;
			}
			else {
				_timeTF.text = data.time;
			}
			_timeTF.format.setTo(mdu.TIME_TEXT_FONT_NAME, mdu.TIME_TEXT_FONT_SIZE, mdu.TIME_TEXT_COLOR);
			if (_config.isFromMe){
				_timeTF.format.horizontalAlign = Align.RIGHT;
			}
			else {
				_timeTF.format.horizontalAlign = Align.LEFT;
			}

			// initialize objects
			_loadingStateIcon.width = _loadingStateIcon.height = mdu.LOADING_STATE_ICON_SIZE;
			// scaleX = .3;
			// _loadingStateIcon.scaleY = .3; 
			
			// set text field vars
			// _messageTF.autoSize = TextFieldAutoSize.VERTICAL;
			/*if (_config.isFromMe)
				_messageTF.alpha = 0.7;*/
			
			_timeTF.format.bold = false;
			_timeTF.alpha = 0.3;
			
			// add the children
			addChild(_background);
			if (_avatarImage){
				addChild(_avatarImage);
				addChild(_usernameTF);
			}
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
			var offsetX:Number = /* _config.isFromMe ? mdu.BOTTOM_PADDING : */ 0;
			_messageTF.x = mdu.MESSAGE_TEXT_X + offsetX;
			_messageTF.y = mdu.MESSAGE_TEXT_Y;
			_messageTF.width = mdu.MESSAGE_TEXT_WIDTH - offsetX;
			_messageTF.height = undefined;
			_messageTF.validate();
			// _messageTF.height += 5;
			
			_background.x = this.width - ChatConsole.theme.borderWidth;
			_background.width = this.width - ChatConsole.theme.borderWidth;
			_background.height = _messageTF.bounds.bottom + mdu.BOTTOM_PADDING;
			
			// Define the message location
			_timeTF.x = mdu.MESSAGE_TEXT_X + offsetX;//consoleWidth - _timeTF.width - _loadingStateIcon.width;
			_timeTF.width = mdu.MESSAGE_TEXT_WIDTH - offsetX;
			_timeTF.y = _messageTF.y + _messageTF.height;

			// position the loading state icon
			_loadingStateIcon.x = _timeTF.x;
			_loadingStateIcon.y = _timeTF.y;
			
			// Position the avatar image
			positionAvatarImage();
			positionUsername();
		}
		
		/**
		 * Avatar image loaded callback
		 */
		private function onAvatarImageLoaded(event:Event):void
		{
			positionAvatarImage();
			positionUsername();
		}

		/**
		 * Positions the avatar image based upon the image height and text height.
		 */
		private function positionAvatarImage():void
		{
			var mdu:MessageDisplayUtil = MessageDisplayUtil.getInstance();
			// Define the avatar image location
			if (_avatarImage) {
				if (_config.isFromMe){
					_avatarImage.x = mdu.AV_IMAGE_RIGHT_X + mdu.AV_IMAGE_WIDTH - _avatarImage.width; // mdu.MESSAGE_TEXT_X + mdu.MESSAGE_TEXT_WIDTH + MessageDisplayUtil.getInstance().AV_IMAGE_LEFT_X;
				}
				else {
					_avatarImage.x = mdu.AV_IMAGE_LEFT_X;
				}
				var top:Number = _messageTF.bounds.top;
				var bottom:Number = _messageTF.bounds.bottom;
				_avatarImage.y = (bottom + top) * 0.5 - _avatarImage.height * 0.5;
			}
		}


		/**
		 * Positions the avatar image based upon the image height and text height.
		 */
		private function positionUsername():void
		{
			var mdu:MessageDisplayUtil = MessageDisplayUtil.getInstance();
			// Define the avatar image location
			if (_avatarImage) {
				_usernameTF.y = _avatarImage.y + _avatarImage.height;
				// trace(_avatarImage.y);
				// trace(_avatarImage.height * 0.5);
				// trace(mdu.NAME_TEXT_HEIGHT);
				// trace("------------------");
				// _usernameTF.width = mdu.NAME_TEXT_WIDTH;
				// if (_config.isFromMe){
					_usernameTF.x = _avatarImage.x + _avatarImage.width * 0.5 - _usernameTF.width * 0.5;
				// }
				// else {
					// _usernameTF.x = mdu.NAME_TEXT_X ;
				// }
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
