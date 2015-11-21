package fovea.chat.message
{	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	import fovea.chat.ChatUtil;
	import fovea.chat.ChatConsole;
	
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.textures.Texture;

	/**
	 * Load an avatar image for chat display
	 */
	public class AvatarImage extends DisplayObjectContainer
	{
		/** the image used for the avatar image */
		private var _image:Image;
		/** url of the avatar image location */
		private var _url:String;
		/** loader used for avatar image */
		private var _loader:Loader;
		/** loading image */
		private var _loadingImage:Image;
		/** load failed image */
		private var _loadFailedImage:Image;
		
		public function AvatarImage(loadFailedTexture:Texture, loadingTexture:Texture)
		{	
			// Instantiate objects
			_loadingImage = loadingTexture ? new Image(loadingTexture) : null;
			_loadFailedImage = loadFailedTexture? new Image(loadFailedTexture) : null;;
			_loader = new Loader();
			
			// Add Event Listeners
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadSuccess);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onLoadFail);
			_loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoadFail);
			
			// Add loading image if exists
			if(_loadingImage) {
				forceImageSize(_loadingImage);
				addChild(_loadingImage);
			}
		}
		
		/**
		 * Loads an image
		 * @param url:String - url of the loaded image
		 */
		public function load(url:String):void
		{
			var context:LoaderContext = new LoaderContext();
			context.checkPolicyFile = true;
			context.applicationDomain = new ApplicationDomain();
			
			_url = url;
			_loader.load(new URLRequest(_url), context);
		}

		public function forceImageSize(img:Image):void {
			if (img) {
				img.width = ChatConsole.theme.avatarSize();
				img.height = ChatConsole.theme.avatarSize();
			}
		}
		
		/**
		 * Image load success callback</br>
		 * Adds image to this container
		 */
		private function onLoadSuccess(event:Event):void
		{
			_image = new Image(Texture.fromBitmap(_loader.content as Bitmap));
			forceImageSize(_image);
			addChild(_image);
			
			// Remove the loading icon
			if(_loadingImage)
				removeChild(_loadingImage);
			
			dispatchEventWith(ChatUtil.LOAD_SUCCESS);
		}
		
		/**
		 * Image load fail callback</br>
		 */
		private function onLoadFail(event:Event):void
		{
			trace("Load Failed: "+_url+": "+event.type);
			
			// Add a load failed image if exists
			if(_loadFailedImage) {
				forceImageSize(_loadFailedImage);
				addChild(_loadFailedImage);
			}
			
			// Remove the loading icon
			if(_loadingImage)
				removeChild(_loadingImage);
		}
		
		/**
		 * Disposes of this object
		 */
		override public function dispose():void
		{
			_loader.removeEventListener(Event.COMPLETE, onLoadSuccess);
			_loader.removeEventListener(IOErrorEvent.IO_ERROR, onLoadFail);
			_loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoadFail);
			_image.dispose();
			
			if(_loadingImage)
				_loadingImage.dispose();
			
			if(_loadFailedImage)
				_loadFailedImage.dispose();
			
			_loader = null;
		}
	}
}
