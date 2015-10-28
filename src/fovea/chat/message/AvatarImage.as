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
	import fovea.chat.objects.FailedLoadIcon;
	import fovea.chat.objects.LoadingIcon;
	
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.textures.Texture;
	import starling.utils.Color;

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
		/** loading icon */
		private var _loadingIcon:LoadingIcon;
		
		/** Radius of the loading icon */
		private static const LOADING_ICON_RADIUS:Number = 20;
		
		public function AvatarImage()
		{	
			// Instantiate objects
			_loadingIcon = new LoadingIcon(Color.BLUE, Color.WHITE, LOADING_ICON_RADIUS);
			_loader = new Loader();
			
			// Set position
			_loadingIcon.x = LOADING_ICON_RADIUS;
			_loadingIcon.y = LOADING_ICON_RADIUS;
			
			// Add Event Listeners
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadSuccess);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onLoadFail);
			_loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoadFail);
			
			// Add Children
			addChild(_loadingIcon);
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
		
		/**
		 * Image load success callback</br>
		 * Adds image to this container
		 */
		private function onLoadSuccess(event:Event):void
		{
			_image = new Image(Texture.fromBitmap(_loader.content as Bitmap));
			addChild(_image);
			
			// Remove the loading icon
			removeChild(_loadingIcon);
			
			dispatchEventWith(ChatUtil.LOAD_SUCCESS);
		}
		
		/**
		 * Image load fail callback</br>
		 */
		private function onLoadFail(event:Event):void
		{
			trace("Load Failed: "+_url+": "+event.type);
			// Add a load failed image
			
			
			// Remove the loading icon
			removeChild(_loadingIcon);
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
			_loadingIcon.dispose();
			
			_loader = null;
		}
	}
}