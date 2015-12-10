package fovea.chat.message
{
	import fovea.chat.ChatConsole;
	import fovea.chat.ChatUtil;
	
	import starling.display.Quad;
	import starling.text.TextField;
	import starling.utils.HAlign;

	/**
	 * View for a system chat message
	 */
	public class SystemMessageDisplay extends ChatMessageDisplay
	{
		/** background quad */
		private var _background:Quad;
		/** Message textField */
		private var _messageTF:TextField;
		
		/**
		 * Instantiates a SystemMessageDisplay
		 * @param data:ChatMessageData - Data associated with this chat message
		 * @param config:ChatMessageDisplayConfig - Display Config associated with this chat message
		 */
		public function SystemMessageDisplay(data:ChatMessageData, config:ChatMessageDisplayConfig)
		{
			var message:String = data.message;
			var mdu:MessageDisplayUtil = MessageDisplayUtil.getInstance();
			
			if (message.length > mdu.MAX_CHARACTERS-1)
				message = message.substr(0,MessageDisplayUtil.getInstance().MAX_CHARACTERS-1)+"...";
			
			_background = new Quad(1,1,config.backgroundColor);
			_background.alpha = config.backgroundAlpha;
            _background.visible = false;
			
			_messageTF = new TextField(
                mdu.MESSAGE_SYSTEM_TEXT_WIDTH,
                mdu.MESSAGE_SYSTEM_TEXT_HEIGHT,
                message,
                mdu.MESSAGE_SYSTEM_TEXT_FONT_NAME,
                mdu.MESSAGE_SYSTEM_TEXT_FONT_SIZE,
                mdu.MESSAGE_SYSTEM_TEXT_COLOR);
			_messageTF.hAlign = HAlign.LEFT
			_messageTF.bold = true;
			
			// add the children
			addChild(_background);
			addChild(_messageTF);
		}
		
		/**
		 * Defines the user message layout
		 */
		override public function layout(consoleWidth:Number):void	
		{
			var mdu:MessageDisplayUtil = MessageDisplayUtil.getInstance();
			_messageTF.x = mdu.MESSAGE_SYSTEM_TEXT_X;
			_messageTF.y = mdu.MESSAGE_SYSTEM_TEXT_Y;
			_background.width  = this.width - ChatConsole.theme.borderWidth;
			_background.height = this.height;
		}

		/**
		 * Dipose of this object
		override public function dispose():void
		{
			_messageTF.dispose();
			_background.dispose();
		}
		 */
	}
}
