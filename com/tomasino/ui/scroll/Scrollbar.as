package com.tomasino.ui.scroll
{
	import com.tomasino.utils.ButtonHelper;
	import com.greensock.TweenLite;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class Scrollbar extends Sprite
	{
		private var _isEnabled:Boolean = false;
		private var _stage:Stage;
		
		// UI Components
		private var _track:Sprite;
		private var _slider:Sprite;
		private var _upBtn:DisplayObject;
		private var _downBtn:DisplayObject;
		private var _content:DisplayObject;
		private var _contentMask:DisplayObject;
		
		// Scroll Classes
		private var _sliderClass:Slider;
		
		// Configuration
		private var _topBuffer:Number = 0;
		private var _bottomBuffer:Number = 0;
		private var _contentSize:Number = 0;
		private var _contentMaskSize:Number = 0;
		
		private var _scaleSliderRelativeToContent:Boolean = false;
		private var _useScrollWheel:Boolean = false;
		
		
		/*
		 * Public Methods
		 *
		 */
		
		public function Scrollbar ():void
		{
			addEventListener (Event.ADDED_TO_STAGE, onAdd);
		}
		
		
		/*
		 * Private Methods
		 *
		 */
		
		private function onAdd ( event:Event ):void
		{
			if (!_stage) _stage = this.stage;
			removeEventListener (Event.ADDED_TO_STAGE, onAdd);
			addEventListener (Event.REMOVED_FROM_STAGE, onRemove);
			
			if (_isEnabled)
				addEventListeners ();
		}
		
		private function onRemove ( event:Event ):void
		{
			removeEventListener (Event.REMOVED_FROM_STAGE, onRemove);
			addEventListener (Event.ADDED_TO_STAGE, onAdd);
			removeEventListeners ();
		}
		
		private function checkIfActive ():void
		{
			if (_track && _slider)
			{
				if (!_sliderClass) _sliderClass = new Slider (_slider, _track);

				_isEnabled = true;
				_sliderClass.enable ();
				addEventListeners ();
			}
			else
			{
				_isEnabled = false;
				if (_sliderClass) _sliderClass.disable ();
				removeEventListeners ();
			}
		}
		
		private function addEventListeners():void
		{
			if (_useScrollWheel) _stage.addEventListener (MouseEvent.MOUSE_WHEEL, mouseWheelHandler);
			_sliderClass.addEventListener (Event.CHANGE, onSliderChange);
		}
		
		private function removeEventListeners():void
		{
			if (_stage) _stage.removeEventListener (MouseEvent.MOUSE_WHEEL, mouseWheelHandler);
			if (_sliderClass) _sliderClass.removeEventListener (Event.CHANGE, onSliderChange);
		}
		
		private function onSliderChange(e:Event):void
		{
			var ratio:Number = _sliderClass.position;
			if (_content)
			{
				var newY = 0 - ((_contentSize - _contentMaskSize) * ratio);
				TweenLite.to (_content, .5, { y:newY } );
			}
		}
		
		private function mouseWheelHandler ( event:MouseEvent ):void
		{
			if (event.delta < 0)
			{
				
			}
			else
			{
			
			}
		}
		
		
		/*
		 * Getters & Setters
		 *
		 */
		
		public function get track():Sprite { return _track; }
		
		public function set track(value:Sprite):void
		{
			_track = value;
			checkIfActive ();
		}
		
		public function get slider():Sprite { return _slider; }
		
		public function set slider(value:Sprite):void
		{
			_slider = value;
			ButtonHelper.MakeButton (_slider);
			checkIfActive ();
		}
		
		public function get upBtn():DisplayObject { return _upBtn; }
		
		public function set upBtn(value:DisplayObject):void
		{
			_upBtn = value;
			ButtonHelper.MakeButton (_upBtn);
		}
		
		public function get downBtn():DisplayObject { return _downBtn; }
		
		public function set downBtn(value:DisplayObject):void
		{
			_downBtn = value;
			ButtonHelper.MakeButton (_downBtn);
		}
		
		public function get scaleSliderRelativeToContent():Boolean { return _scaleSliderRelativeToContent; }
		
		public function set scaleSliderRelativeToContent(value:Boolean):void
		{
			_scaleSliderRelativeToContent = value;
		}
		
		public function get content():DisplayObject { return _content; }
		
		public function set content(value:DisplayObject):void
		{
			_content = value;
			contentSize = _content.height;
		}
		
		public function get contentMask():DisplayObject { return _contentMask; }
		
		public function set contentMask(value:DisplayObject):void
		{
			_contentMask = value;
			contentMaskSize = _contentMask.height;
		}
				
		public function get contentSize():Number { return _contentSize; }
		
		public function set contentSize(value:Number):void
		{
			_contentSize = value;
		}
		
		public function get contentMaskSize():Number { return _contentMaskSize; }
		
		public function set contentMaskSize(value:Number):void
		{
			_contentMaskSize = value;
			
		}
		
		public function get topBuffer():Number { return _topBuffer; }
		
		public function set topBuffer(value:Number):void
		{
			_topBuffer = value;
			if (_sliderClass) _sliderClass.topBuffer = value;
		}
		
		public function get bottomBuffer():Number { return _bottomBuffer; }
		
		public function set bottomBuffer(value:Number):void
		{
			_bottomBuffer = value;
			if (_sliderClass) _sliderClass.bottomBuffer = value;
		}
	}
}