﻿package org.tomasino.display
{
	import com.greensock.TweenLite;
	import flash.display.DisplayObject;

	public class DepthOfField
	{
		public var quality:int = 1;
		public var time:Number = 0;
		
		private var _focalRange:Number = 0;
		private var _focalPoint:Number = 0;
		private var _blurFactor:Number = 1;
		
		private var _dispObjects:Array = new Array();
		
		public function DepthOfField(fp:Number = 0, fr:Number = 0, bf:Number = 1, t:Number = 0, q:int = 1)
		{
			focalPoint = fp;
			focalRange = fr;
			blurFactor = bf;
			time = (t >= 0) ? t : 0;
			quality = (q >= 1) ? q : 1;
		}
		
		public function add ( d:DisplayObject, depth:Number):void
		{
			var depthObj:DepthObject = new DepthObject();
			depthObj.d = d;
			depthObj.depth = depth;
			depthObj.quality = quality;
			
			_dispObjects.push (depthObj);
			
			update();
		}
	
		public function remove ( d:DisplayObject ):void
		{
			for (var i:int = 0; i < _dispObjects.length; ++i)
			{
				var depthObj:DepthObject = _dispObjects[i] as DepthObject;
				if (depthObj.d == d)
				{
					removeIndex (i);
					break;
				}
			}
		}
		
		private function removeIndex ( index:int )
		{
			_dispObjects.slice( index, 1);
			update();
		}
		
		private function update()
		{
			for (var i:int = 0; i < _dispObjects.length; ++i)
			{
				var depthObj:DepthObject = _dispObjects[i] as DepthObject;
				
				if (depthObj.d)
				{
					// Get shortest distance between the points, with optional focal range in there.
					var dist1:Number = _focalPoint - depthObj.depth;
					var dist2:Number = (_focalPoint - (focalRange / 2)) - depthObj.depth;
					var dist3:Number = (_focalPoint + (focalRange / 2)) - depthObj.depth;
					
					// blurAmount = range * blurfactor
					var blurAmount:Number;
					blurAmount = ( Math.abs(dist1) < Math.abs(dist2) ) ? dist1 : dist2;
					blurAmount = ( Math.abs(blurAmount) < Math.abs(dist3) ) ? blurAmount : dist3;
					blurAmount *= _blurFactor;
					
					// Tween the blur property over "time"
					TweenLite.to (depthObj, time, {blur:blurAmount});
				}
				else
				{
					removeIndex (i);
					break;
				}
			}
		}	
		
		//private function tween (d:DisplayObject, 
		
		public function set focalPoint (val:Number):void
		{
			if (_focalPoint != val)
			{
				_focalPoint = val;
				update();
			}
		}
		
		public function get focalPoint ():Number
		{
			return _focalPoint;
		}
		
		public function set focalRange (val:Number):void
		{
			if (_focalRange != val)
			{
				_focalRange = val;
				update();
			}
		}
		
		public function get focalRange ():Number
		{
			return _focalRange;
		}
		
		public function set blurFactor (val:Number):void
		{
			if (_blurFactor != val)
			{
				_blurFactor = (val == 0) ? 1 : val;
				update();
			}
		}
		
		public function get blurFactor ():Number
		{
			return _blurFactor;
		}
	}
}

import flash.display.DisplayObject;
import flash.filters.BlurFilter;

internal class DepthObject
{
	public var d:DisplayObject;
	public var depth:Number;
	public var quality:Number;
	
	private var _blur:Number = 0;
	
	public function DepthObject()
	{
	}
	
	public function get blur ():Number
	{
		return _blur;
	}
	
	public function set blur (val:Number):void
	{
		_blur = val;
		update();
	}
	
	private function update ():void
	{
		var filters:Array = d.filters;
		for (var i:int = 0; i < filters.length; ++i)
		{
			if (filters[i] is BlurFilter)
			{
				filters.splice(i,1);
				break;
			}	
		}
		var blurAmount:Number = Math.abs(_blur);
		var blur:BlurFilter = new BlurFilter (blurAmount, blurAmount, quality);
		filters.push(blur);
		d.filters = filters;
	}
}