﻿package org.tomasino.display
{
	import com.greensock.TweenLite;
	import com.greensock.data.TweenLiteVars;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	public class ParallaxManager
	{
		private var _layers:Dictionary;
		private var _locked:Boolean = false;
		private var _originPoint:Point;
		private var _stage:Stage;
		
		public function ParallaxManager(stage:Stage)
		{
			clearLayers();
			_stage = stage;
			_stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		}
		
		public function clearLayers():void
		{
			if (_layers)
			{
				for (var o:Object in _layers)
				{
					var po:ParallaxObject = _layers[o] as ParallaxObject;
					po.destroy();
				}
			}

			_layers = new Dictionary(true);
		}
		
		public function registerLayer(layer:DisplayObject, bounds:Rectangle):void
		{
			if (_layers[layer]) ParallaxObject(_layers[layer]).destroy();
			
			var po:ParallaxObject = new ParallaxObject();
			po.d = layer;
			po.originalX = layer.x;
			po.originalY = layer.y;
			po.bounds = bounds;
			
			_layers[layer] = po;
		}
		
		public function lock(center:Boolean = false):void
		{
			_locked = true;
			
			if (center)
			{
				for (var o:Object in _layers)
				{
					var po:ParallaxObject = _layers[o] as ParallaxObject;
					
					var tweenProps:TweenLiteVars = new TweenLiteVars();
					tweenProps.x = po.originalX;
					tweenProps.y = po.originalY;
					TweenLite.to(po.d, .5, tweenProps);
				}
			}
		}
		
		public function unLock():void
		{
			_locked = false;
		}
		
		private function onMouseMove(e:MouseEvent):void
		{
			if (!_locked)
			{
				var deltaX:Number = e.stageX / _stage.stageWidth;
				var deltaY:Number = e.stageY / _stage.stageHeight;
				
				for (var o:Object in _layers)
				{
					var po:ParallaxObject = _layers[o] as ParallaxObject;
					
					var offSetX:Number = po.originalX + ((po.bounds.width * deltaX) + po.bounds.left);
					var offSetY:Number = po.originalY + ((po.bounds.height * deltaY) + po.bounds.top);
					
					var tweenProps:TweenLiteVars = new TweenLiteVars();
					tweenProps.x = offSetX;
					tweenProps.y = offSetY;
					TweenLite.to(po.d, .5, tweenProps);
				}
			}
		}
	}
}

import flash.display.DisplayObject;
import flash.geom.Rectangle;

internal class ParallaxObject
{
	public var d:DisplayObject;
	public var originalX:Number;
	public var originalY:Number;
	public var bounds:Rectangle;
	
	public function ParallaxObject()
	{
	}
	
	public function destroy ():void
	{
		d = null;
	}
}