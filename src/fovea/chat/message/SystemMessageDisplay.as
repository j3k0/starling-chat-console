package fovea.chat.message
{
	import fovea.chat.ChatUtil;
	
	import starling.display.Quad;
	import starling.text.TextField;
	import starling.utils.HAlign;

	public class SystemMessageDisplay extends ChatMessageDisplay
	{
		/** background quad */
		private var _background:Quad;
		/** Message textField */
		private var _messageTF:TextField;
		
		public function SystemMessageDisplay(data:ChatMessageData, config:ChatMessageDisplayConfig)
		{
			_background = new Quad(1,1,config.backgroundColor);
			_background.alpha = config.backgroundAlpha;
			
			_messageTF = new TextField(620,70,data.message);
			_messageTF.hAlign = HAlign.LEFT
			_messageTF.color = ChatUtil.GREY_TEXT_COLOR;
			_messageTF.bold = true;
			
			// add the children
			addChild(_background);
			addChild(_messageTF);
		}
		
		/**
		 * redefines the user message layout
		 */
		override public function layout(consoleWidth:Number):void	
		{
			_messageTF.x = MessageDisplayUtil.MESSAGE_TEXT_X;
			
			_background.width = this.width;
			_background.height = this.height;
		}
	}
}