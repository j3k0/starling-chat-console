package fovea.chat.objects
{
	import starling.display.DisplayObjectContainer;
	import starling.display.Quad;
	import starling.utils.Color;
	
	public class Shadow extends DisplayObjectContainer
	{
		private var _quads:Vector.<Quad> = new Vector.<Quad>();

		private function addShadowQuad(w:Number):void {
			var q:Quad = new Quad(w, 1, Color.BLACK);
			q.alpha = 0.1;
			addChild(q);
			_quads.push(q);
		}

		public function Shadow(numSteps:int = 3) {
			for (var i:int = numSteps; i > 0; --i) {
				addShadowQuad(i);
			}
		}

		public function layout(w:Number, h:Number):void {
			// Set the shadow position and size
			_quads[0].width = w;
			for (var i:int = 0; i < _quads.length; ++i) {
				var q:Quad = _quads[i];
				q.height = h;
				q.x = w - q.width;
			}
		}

		/**
		 * Disposes of this object
		 */
		override public function dispose():void
		{
			for (var i:int = 0; i < _quads.length; ++i) {
				_quads[i].dispose();
			}
			_quads = new Vector.<Quad>();
		}
	}
}
