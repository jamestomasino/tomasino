package com.tomasino.display
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.geom.Transform;
	
	/**
	 * Display Proxy that uses Blitting to optimize screen draws.
	 * @author tomasino
	 */
	
	public class BlittingProxy extends MovieClip
	{
		private var _isInvalidated:Boolean;
		private var _stage:Stage;
		private var _dispObj:DisplayObject;
		private var _blit:Bitmap;
		private var _blitData:BitmapData;
		private var _wrapperDisp:Sprite;
		private var _updateWithFrameRate:Boolean;
		
		public function BlittingProxy (updateWithFrameRate:Boolean = false):void
		{
			addEventListener ( Event.ADDED_TO_STAGE, onAdd );
			_wrapperDisp = new Sprite();
			_updateWithFrameRate = updateWithFrameRate;
		}
		
		private function onAdd(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdd);
			_stage = this.stage;
			addEventListener(Event.ENTER_FRAME, onFrame);
		}
		
		private function onFrame(e:Event):void 
		{
			if ((_isInvalidated || _updateWithFrameRate) && _dispObj)
			{
				_isInvalidated = false;
				var w:Number = _dispObj.width || 1;
				var h:Number = _dispObj.height || 1;
				var stageW:Number = _stage.stageWidth;
				var stageH:Number = _stage.stageHeight;
				
				_blitData = new BitmapData ( stageW, stageH, true );
				_blitData.draw (_wrapperDisp, null, null, null, new Rectangle (0,0, stageW, stageH ), true);
				_blitData.lock();
				_blit = new Bitmap ( _blitData );
				addChild (_blit);
			}
		}
		
		public function invalidate ( e:Event = null ):void
		{
			_isInvalidated = true;
		}
		
		public function set target ( val:DisplayObject ):void
		{
			_dispObj = val;
			_wrapperDisp.addChild(_dispObj);
		}
	}
}