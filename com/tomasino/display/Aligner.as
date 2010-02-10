package com.tomasino.display
{
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	public class Aligner extends Sprite
	{
		public static const TOP:String = 'top';
		public static const CENTER:String = 'center';
		public static const BOTTOM:String = 'bottom';
		public static const LEFT:String = 'left';
		public static const RIGHT:String = 'right';
		public static const NONE:String = 'none';
		
		private var _valign:String;
		private var _halign:String;

		public function Aligner (v:String = NONE, h:String = NONE):void
		{
			valign = v;
			halign = h;
		}
		
		public function refresh ():void
		{
			if (this.parent)
			{
				var boundingRect:Rectangle = this.getBounds(this.parent);
				
				switch (_valign)
				{
					case TOP:
						this.y = -boundingRect.y;
						break;
					case CENTER:
						var heightPastReg:Number = this.height - (this.y - boundingRect.y);
						this.y = -(heightPastReg >> 1)
						break;
					case BOTTOM:
						heightPastReg = this.height - (this.y - boundingRect.y);
						this.y = -heightPastReg;
						break;
					case NONE:
						break;
				}
				
				switch (_halign)
				{
					case LEFT:
						this.x = -boundingRect.x;
						break;
					case CENTER:
						var widthPastReg:Number = this.width - (this.x - boundingRect.x);
						this.x = -(widthPastReg >> 1)
						break;
					case RIGHT:
						widthPastReg = this.width - (this.x - boundingRect.x);
						this.x = -widthPastReg;
						break;
					case NONE:
						break;
				}
			}
		}
		
		public function get valign ():String { return _valign }
		public function set valign (val:String):void
		{
			switch (val)
			{
				case CENTER:
					_valign = CENTER;
					break;
				case BOTTOM:
					_valign = BOTTOM;
					break;
				case TOP:
					_valign = TOP;
					break;
				default:
					_valign = NONE;
					break;
			}
		}

		public function get halign ():String { return _halign }
		public function set halign (val:String):void
		{
			switch (val)
			{
				case CENTER:
					_halign = CENTER;
					break;
				case RIGHT:
					_halign = RIGHT;
					break;
				case LEFT:
					_halign = LEFT;
					break;
				default:
					_halign = NONE;
					break;
			}
		}

	}
}