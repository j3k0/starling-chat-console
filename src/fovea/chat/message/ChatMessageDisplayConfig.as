package fovea.chat.message
{
	import starling.textures.Texture;

	/**
	 * Configuration for a chat messages display </br>
	 * <ul>
	 * 		<li>backgroundColor - the message background color </li>
	 * 		<li>backgroundAlpha - the message background backgroundAlpha </li>
	 * 		<li>avatarLoadFailedTexture - texture displayed if avatar image failed to load  </li>
	 * 		<li>avatarLoadingTexture - texture displayed while avatar image is loading </li>
	 * </ul>
	 */
	public class ChatMessageDisplayConfig
	{
		public var backgroundColor:uint;
		public var backgroundAlpha:Number;
		public var avatarLoadFailedTexture:Texture;
		public var avatarLoadingTexture:Texture;
		public var enableAvatar:Boolean;
		public var isFromMe:Boolean;
		
		/**
		 * Create a ChatMessageDisplayConfig Object
		 * @param backgroundColor - the message background color 
		 * @param backgroundAlpha - the message background backgroundAlpha 
		 * @param avatarLoadFailedTexture - texture displayed if avatar image failed to load  
		 * @param avatarLoadingTexture - texture displayed while avatar image is loading 
		 */
		public function ChatMessageDisplayConfig(backgroundColor:uint, backgroundAlpha:Number, 
												 avatarLoadFailedTexture:Texture = null, avatarLoadingTexture:Texture = null,
												 enableAvatar:Boolean = true, isFromMe:Boolean = false)
		{
			this.backgroundColor 			= backgroundColor;
			this.backgroundAlpha 			= backgroundAlpha;
			this.avatarLoadFailedTexture	= avatarLoadFailedTexture;
			this.avatarLoadingTexture 		= avatarLoadingTexture;
			this.enableAvatar = enableAvatar;
			this.isFromMe = isFromMe;
		}
	}
}
