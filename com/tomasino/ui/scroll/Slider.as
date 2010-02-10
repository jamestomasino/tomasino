package com.tomasino.ui.scroll
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	public class Slider extends EventDispatcher
	{
		private var _sprite:Sprite;
		private var _track:Sprite;
		private var _stage:Stage;
		private var _position:Number = 0;
		private var _scrolling:Boolean = false;
		private var _isMouseOffStage:Boolean = false;
		
		public var topBuffer:Number = 0;
		public var bottomBuffer:Number = 0;
		
		public function Slider (sprite:Sprite, track:Sprite):void
		{
			_sprite = sprite;
			_track = track;
			if (_sprite.stage)
			{
				_stage = _sprite.stage;
			}
			else
			{
				_sprite.addEventListener (Event.ADDED_TO_STAGE, onAdd);
			}
		}
		
		public function enable ():void
		{
			_sprite.addEventListener (MouseEvent.MOUSE_DOWN, onScrollDown);
		}
		
		public function disable ():void
		{
			_sprite.removeEventListener (MouseEvent.MOUSE_DOWN, onScrollDown);
			if (_stage)
			{
				_stage.removeEventListener (MouseEvent.MOUSE_UP, onScrollUp);
				_stage.removeEventListener (MouseEvent.MOUSE_MOVE, onScrollMove);
			}
		}
		
		private function onScrollUp(e:Event):void
		{
			stopListeners ();
		}
		
		private function onScrollDown(e:Event):void
		{
			if (_track && _track.height)
			{
				if (_stage)
				{
					_stage.addEventListener (MouseEvent.MOUSE_UP, onScrollUp);
					_stage.addEventListener (Event.MOUSE_LEAVE, onScrollLeave);
					_stage.addEventListener (MouseEvent.MOUSE_OUT, onStageOut);
					_stage.addEventListener (MouseEvent.MOUSE_OVER, onStageOver);
					_stage.addEventListener (MouseEvent.MOUSE_MOVE, onScrollMove);
					var bounds:Rectangle = new Rectangle ( _sprite.x, _track.y + topBuffer, 0, _track.height - (topBuffer + bottomBuffer + _sprite.height) );
					_sprite.startDrag (false, bounds);
				}
			}
		}
		
		private function onScrollLeave ( event:Event ) :void
		{
			stopListeners ();
		}

		private function onScrollFrame(e:Event):void
		{
			if (_stage.mouseX < 0 || _stage.mouseX > _stage.stageWidth || _stage.mouseY < 0 || _stage.mouseY > _stage.stageHeight)
			{
				//stopListeners ();
			}
		}
		
		private function stopListeners ():void
		{
			_stage.removeEventListener (MouseEvent.MOUSE_UP, onScrollUp);
			_stage.removeEventListener (Event.MOUSE_LEAVE, onScrollLeave);
			_stage.removeEventListener (MouseEvent.MOUSE_OUT, onStageOut);
			_stage.removeEventListener (MouseEvent.MOUSE_OVER, onStageOver);
			_stage.removeEventListener (MouseEvent.MOUSE_MOVE, onScrollMove);
			_sprite.stopDrag ();
		}
		
		private function onStageOut ( event:Event ) :void
		{
			_isMouseOffStage = true;
		}

		private function onStageOver ( event:Event ) :void
		{
			_isMouseOffStage = false;
		}

		private function onScrollMove( event:MouseEvent ):void
		{
			if (event.buttonDown)
			{
				_position = (_sprite.y - (_track.y + topBuffer)) / (_track.height - (topBuffer + bottomBuffer + _sprite.height) );
				dispatchEvent ( new Event (Event.CHANGE) );
			}
			else
			{
				stopListeners ();
			}
		}
		
		public function get position():Number { return _position; }
		
		public function set position (value:Number):void
		{
			if (!_scrolling)
			{
				if (value < 0) value = 0;
				if (value > 1) value = 1;
				_position = value;
				
				_sprite.y = _track.y + topBuffer + ((_track.height - (topBuffer + bottomBuffer + _sprite.height)) * _position);
			}
		}
		
		public function get scrolling():Boolean { return _scrolling; }
		
		private function onAdd(e:Event):void
		{
			_sprite.removeEventListener (Event.ADDED_TO_STAGE, onAdd);
			_stage = _sprite.stage;
		}
	}
}