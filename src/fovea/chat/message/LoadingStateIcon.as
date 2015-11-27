package fovea.chat.message
{
	import fovea.chat.ChatConsole;
	import fovea.chat.objects.FailedLoadIcon;
	import fovea.chat.objects.LoadingIcon;
	
	import starling.display.DisplayObjectContainer;
	import starling.display.Quad;
	import starling.utils.Color;

	/**
	 * An icon to denote the loading state of sent messages
	 */
	public class LoadingStateIcon extends DisplayObjectContainer
	{
		/** the background of this object */
		private var _backgroundQuad:Quad;
		/** an icon denoting IN_PROGRESS state */
		private var _loadingIcon:LoadingIcon;
		/** an icon denoting FAILED state */
		private var _loadFailedIcon:FailedLoadIcon;
		/** Current state of the icon */
		private var _state:int;
		
		private var _imageLoaded:Boolean;
		
		
		/**
		 * Sets the state of the avatar image
		 */
		public function set state(value:int):void 
		{
			_state = value;
			setVisualState();
		}
		
		private static function get LOADING_ICON_RADIUS():Number {
			return ChatConsole.theme.avatarSize() * 0.5;
		}
		
		public function LoadingStateIcon()
		{	
			// Instantiate objects
			_loadingIcon = new LoadingIcon(ChatConsole.theme.borderColor, ChatConsole.theme.backgroundColor, LOADING_ICON_RADIUS);
			_backgroundQuad = new Quad(LOADING_ICON_RADIUS, LOADING_ICON_RADIUS, Color.BLACK);
			
			// Initialize objects
			_state = ChatMessage.STATE_IN_PROGRESS;
			_imageLoaded = false;
			_backgroundQuad.alpha = 0;
			_backgroundQuad.visible = false;
			
			// Set position
			//_loadingIcon.x = LOADING_ICON_RADIUS;
			//_loadingIcon.y = LOADING_ICON_RADIUS;
			
			// Add Children
			addChild(_backgroundQuad);
			addChild(_loadingIcon);
		}
		
		/**
		 * Sets the visual state of the chat message based upon the load state
		 */
		private function setVisualState():void
		{
			switch(_state)
			{
				case ChatMessage.STATE_SUCCESS:
					// Remove the loading icon
					removeChild(_loadingIcon);
					break;
				case ChatMessage.STATE_FAILED:
					// Add a load failed icon
					_loadFailedIcon = new FailedLoadIcon();
					addChild(_loadFailedIcon);
					
					// Remove the loading icon
					removeChild(_loadingIcon);
			}
		}
		
		/**
		 * Disposes of this object
		 */
		override public function dispose():void
		{
			_loadFailedIcon.dispose();
			_loadingIcon.dispose();
		}
	}
}
