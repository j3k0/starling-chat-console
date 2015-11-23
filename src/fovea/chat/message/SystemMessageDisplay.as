package fovea.chat.message
{
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
			
			if (message.length > MessageDisplayUtil.getInstance().MAX_CHARACTERS-1)
				message = message.substr(0,MessageDisplayUtil.getInstance().MAX_CHARACTERS-1)+"...";
			
			_background = new Quad(1,1,config.backgroundColor);
			_background.alpha = config.backgroundAlpha;
			
			_messageTF = new TextField(620,70,message);
			_messageTF.hAlign = HAlign.LEFT
			_messageTF.color = ChatUtil.GREY_TEXT_COLOR;
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
			_messageTF.x = MessageDisplayUtil.getInstance().MESSAGE_TEXT_X;
			
			_background.width = this.width;
			_background.height = this.height;
		}
	}
}
