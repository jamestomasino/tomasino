package org.tomasino.effects
{
	import flash.display.Shape;
	import flash.display.Sprite;
	
	import com.greensock.TweenLite;
	import com.greensock.easing.Quad;
	
	/**
	 * Builds a rectangular area with a sparkle effect. (Requires Greensock TweenLite Library) 
	 * @author tomasino
	 * 
	 */
	public class SparkleBox extends Sprite
	{
		
		private var sparkleMaskWidth:Number;
		private var sparkleMaskHeight:Number;
		
		public function SparkleBox ():void
		{
			super ();
			sparkleMaskWidth = this.width;
			sparkleMaskHeight = this.height;
			this.scaleX = 1;
			this.scaleY = 1;
			this.mouseChildren = false;
			this.mouseEnabled = false;
			createSparkles();
		}
		
		private function createSparkles ():void
		{
			for (var i:int = 0; i < 10; ++i)
			{
				var sparkle:Shape = new Shape();
				sparkle.graphics.lineStyle (.1, 0xFFFFFF, .8);
				sparkle.graphics.moveTo(0, -2);
				sparkle.graphics.lineTo(0,  2);
				sparkle.graphics.moveTo(-2, 0);
				sparkle.graphics.lineTo(2,  0);
				startSparkle (sparkle);
			}
		}

		private function startSparkle (s:Shape)
		{
			if (this.parent)
			{
				s.alpha = 1;
				s.rotation = 0;
				s.x = Math.random() * sparkleMaskWidth;
				s.y = Math.random() * sparkleMaskHeight;
				s.scaleX = s.scaleY = Math.random();
				
				var finalScale:Number = .8 + Math.random();
				
				this.addChild(s);
				
				TweenLite.to (s, Math.random() * .2 + .1, { scaleX:finalScale, scaleY:finalScale, ease:Quad.easeOut, rotation:Math.random() * 180 - 90, onComplete:startSparkle, onCompleteParams:[s] } );
			}
			else destroy();
		}

		public function destroy ():void
		{
			var numSparkles:int = this.numChildren;
			for (var i:int = 0; i < numSparkles; ++i)
			{
				var s:Shape = this.removeChildAt(0) as Shape;
				TweenLite.killTweensOf (s);
				s = null;
			}
		}
	}
}