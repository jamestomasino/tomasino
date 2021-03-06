﻿package org.tomasino.effects
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.filters.BlurFilter;
	
	public class SnowFlake extends Sprite
	{
		public var xVel:Number;
		public var yVel:Number;
		public var size:Number ;
		public var screenArea:Rectangle;
		
		public function SnowFlake(screenarea:Rectangle, graphic:DisplayObject = null, initialSpeed:Number = 5)
		{
			if (!graphic)
			{
				graphics.lineStyle(3,0xffffff);
				graphics.moveTo(0,0);
				graphics.lineTo (0.2, 0.2);
			}
			else
			{
				addChild (graphic);
				graphic.x = 0 - (graphic.width >> 1);
				graphic.y = 0 - (graphic.height >> 1);
			}

			screenArea = screenarea;
			
			x = Math.random()*screenArea.width;
			var z:Number = (Math.random()*600)-150;
			size = calculatePerspectiveSize(z);
			scaleX = scaleY = size;
			
			if(z<-150)
			{
				var bluramount:Number = z+150;
				bluramount /= -100;
				bluramount = (bluramount * 20) + 2;
				filters = [new BlurFilter(bluramount, bluramount, 2)];
				
			}
			else
			{
				filters = [new BlurFilter(2,2,2)];
			}
			
			cacheAsBitmap = true;
			xVel = (Math.random()*2)-1;
			yVel = initialSpeed; // should make this variable
			xVel*=size;
			yVel*=size;
			
		}
		
		public function update(wind:Number, speed:Number = NaN):void
		{
			if (!isNaN(speed))
			{
				yVel = speed*=size;
			}
			x+=xVel;
			y+=yVel;
			x += (wind*size);
			if(y>screenArea.bottom) y = screenArea.top;
			if(x>screenArea.right) x = screenArea.left;
			else if(x<screenArea.left) x = screenArea.right;
		}
		
		public function calculatePerspectiveSize(z:Number) : Number
		{
			var fov:Number = 300;
			return fov/(z+fov);
		}
	}
}