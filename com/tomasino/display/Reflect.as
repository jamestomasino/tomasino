/*
 * Author: James Tomasino
 * Date: 2008-02-15
 * 
 * CHANGELOG:
 *     
 */

package com.tomasino.display
{
	import flash.geom.Matrix;
  	import flash.display.Sprite;
  	import flash.display.SpreadMethod;
  	import flash.display.GradientType;
	import flash.display.Bitmap;
	import flash.display.BitmapData;

	public class Reflect extends Sprite 
	{
		private var _bmp:BitmapData;
		private var _reflection:Bitmap;
		private var _mask:Sprite;	
				
		public function Reflect (mc:Sprite, alpha:Number, ratio:Number, dropoff:Number):void
		{
			if (mc.height == 0 || mc.width == 0) return;
			dropoff = dropoff || 1;
			_bmp = new BitmapData(mc.width, mc.height, true, 0x00FFFFFF);
			_mask = new Sprite();
			_bmp.draw(mc);
			_reflection = new Bitmap(_bmp);
			
			addChild(_reflection);
			addChild(_mask);
			
			_reflection.scaleY = -1;
			_reflection.y = mc.height;
			
			var fillType:String = GradientType.LINEAR;
		 	var colors:Array = [0xFFFFFF, 0xFFFFFF];
		 	var alphas:Array = [alpha, 0];
		  	var ratios:Array = [0, ratio];
		  	var matr:Matrix = new Matrix();
		  	matr.createGradientBox(mc.width, mc.height, (90/180)*Math.PI, 0, 0);
		  	var spreadMethod:String = SpreadMethod.PAD;
			_mask.graphics.beginGradientFill(fillType, colors, alphas, ratios, matr, spreadMethod);  
		    _mask.graphics.drawRect(0,0,mc.width,mc.height);

			_mask.scaleY /= dropoff;
			
			// Set Mask
			_mask.cacheAsBitmap = true;
			_reflection.cacheAsBitmap = true;
			_reflection.mask = _mask;
 		}
	}
}
