﻿package org.tomasino.display
{
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import com.greensock.TweenLite;
	
	/**
	 * Allows scrolling of content inside stage. (Requires Greensock Tweenlite library)
	 * 
	 * @author tomasino
	 */
	public class ScrollWheelWindow
	{
		private var _yPos:Number = 0;
		private var _multiplier:Number;
		private var _stage:Stage;
		private var _scrollObj:DisplayObject;
		private var _boundingRect:Rectangle;
		
		public function ScrollWheelWindow (scrollObj:DisplayObject, multiplier:Number = 8):void
		{
			_scrollObj = scrollObj;
			_multiplier = multiplier;
			_scrollObj.addEventListener(Event.ADDED_TO_STAGE, onAdd);
			if (_scrollObj.stage) onAdd();
		}
		
		private function onAdd(e:Event = null):void 
		{
			_scrollObj.removeEventListener(Event.ADDED_TO_STAGE, onAdd);
			_scrollObj.addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
			
			_stage = _scrollObj.stage;
			_stage.addEventListener(MouseEvent.MOUSE_WHEEL, onWheel);			
		}
		
		private function onRemove(e:Event):void 
		{
			_scrollObj.removeEventListener(Event.REMOVED_FROM_STAGE, onRemove);
			_stage.removeEventListener(MouseEvent.MOUSE_WHEEL, onWheel);
		}
		
		private function onWheel(e:MouseEvent):void 
		{
			var delta:Number = e.delta;
			var stageHeight:Number = _stage.stageHeight;
			var thisHeight:Number = _scrollObj.height;
			var newYPos:Number = _yPos + (delta * _multiplier);
			
			if (!_boundingRect) _boundingRect = _scrollObj.getBounds(_scrollObj.parent);
			var minY:Number = stageHeight - (thisHeight + _boundingRect.y);
			
			if (newYPos > 0) _yPos = 0;
			else if (thisHeight < stageHeight) _yPos = 0;
			else if (newYPos < minY) _yPos = minY;
			else _yPos = newYPos;
			
			TweenLite.to (_scrollObj, .25, { y:_yPos} );
		}
	}
}