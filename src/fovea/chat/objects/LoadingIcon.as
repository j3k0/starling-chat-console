package fovea.chat.objects
{
	import starling.animation.IAnimatable;
	import starling.core.Starling;
	import starling.display.Disk;
	import starling.display.DisplayObjectContainer;
	import starling.display.Quad;

	/**
	 * A display of a familiar looking loading icon.
	 */
	public class LoadingIcon extends DisplayObjectContainer implements IAnimatable
	{
		/** Circle used in the background of the display */ 
		private var _spinnerBase:Disk;
		/** Overlay circle used to hide a postion of the background circle */
		private var _spinnerCenter:Disk;
		/** Overlay square used to hide a postion of the background circle */
		private var _spinnerQuad:Quad;
		
		/**
		 * Instantiates a LoadingIcon
		 * @param color:uint - the color of the loading icon
		 * @param backgroundColor:uint - the color of the background behind the loading icon
		 * @param radius:Number - The radius of loading icon
		 */
		public function LoadingIcon(color:uint, backgroundColor:uint, radius:Number)
		{
			_spinnerBase = new Disk(radius, color);
			_spinnerCenter = new Disk(radius *.75, backgroundColor);
			_spinnerQuad = new Quad(radius, radius * 1.5, backgroundColor);
			
			_spinnerBase.x = -radius;
			_spinnerBase.y = -radius; 
			
			_spinnerCenter.x = -radius * .5;
			_spinnerCenter.y = -radius * .5;
			
			_spinnerQuad.y = -radius;
			
			addChild(_spinnerBase);
			addChild(_spinnerCenter);
			addChild(_spinnerQuad);
			
			Starling.juggler.add(this);
		}
		
		/** Advance the time by a number of seconds. @param time in seconds. */
		public function advanceTime(time:Number):void
		{
			var angle:Number = ((time / 1000) * 360) * .5;
			rotation += angle * (180/Math.PI);
		}
		
		/**
		 * Disposes of this object
		 */
		override public function dispose():void
		{
			Starling.juggler.remove(this);
			
			_spinnerBase.dispose();
			_spinnerCenter.dispose();
			_spinnerQuad.dispose();
			
			super.dispose();
		}	
	}
}