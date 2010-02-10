package com.tomasino.display.carousel
{
	import gs.TweenFilterLite;
	import gs.easing.*;
	import flash.events.*;
	import flash.display.MovieClip;
	
	
	
	import com.adobe.utils.ArrayUtil;

	public class Carousel extends MovieClip
	{
		
		private var _ease:Object; 
		
		private var _links:Array = new Array ();
		private var _carouselArray:Array = new Array ();
		
		private var _radiusWidth:Number;
		private var _radiusHeight:Number;
		private var _centerX:Number;
		private var _centerY:Number;
		private var _speed:Number;
		private var _transitionTime:Number;
		
		private var _btnID:String;
		private var _currentLink:String;

		private var _carousel:MovieClip;

		private var _lBtn:MovieClip;
		private var _rBtn:MovieClip;
		private var _pDetails:MovieClip;
		private var _p:MovieClip;

		private var _currentItem:Number;
		private var _offSet:Number = 30;
		private var _s:Number;
		private var _depth:Number;
		private var _tint:Number;
		private var _tintAmt:Number;
		
		private var _rolloverEnabled:Boolean = false;


		public function Carousel (rW:Number, rH:Number, cX:Number, cY:Number, speed:Number, depth:Number)
		{
			_radiusWidth = rW;
			_radiusHeight = rH;
			_centerX = cX;
			_centerY = cY;
			_offSet = 30;
			_speed = speed;
			_depth = depth;
			_tint = 0xFFFFFF;
			_tintAmt = 0.45;
			
			
		}
		
		public function AddItem (mc:MovieClip, link:String = null):void
		{
			_carouselArray.push (mc);
			_links.push (link);
		}
		public function set ease(o:Object):void
		{
			_ease = o;
		}
		
		public function set transitionTime(n:Number):void
		{
			_transitionTime = n;
		}
		
		public function set rollover(b:Boolean):void
		{
			_rolloverEnabled = b;
		}
		
		public function set right (mc:MovieClip):void
		{
			_rBtn = mc;
			_rBtn.addEventListener (MouseEvent.CLICK, focusItems, false, 0, true);

		}
		public function set left (mc:MovieClip):void
		{
			_lBtn = mc;
			_lBtn.addEventListener (MouseEvent.CLICK, focusItems, false, 0, true);

		}
		public function set details (mc:MovieClip):void
		{
			_pDetails = mc;
			_pDetails.addEventListener (MouseEvent.CLICK, getLink, false, 0, true);

		}
		public function Start ():void
		{
			initCarousel ();
		}
		
		private function initCarousel ():void
		{
			for (var i:Number = 0; i < _carouselArray.length; ++i)
			{
				_carouselArray[i].i = i;
				_carouselArray[i].link = _links[i];
				_carouselArray[i].myAngle = i * ((Math.PI * 2) / _carouselArray.length);

				_currentItem = 0;

				position (_carouselArray[i]);

				TweenFilterLite.to (_carouselArray[i], 0, {colorMatrixFilter: {colorize:_tint, amount:_tintAmt}});

				_carouselArray[i].addEventListener (MouseEvent.CLICK, prepareItem, false, 0, true);
				_carouselArray[i].addEventListener (MouseEvent.CLICK, TrackProduct, false, 0, true);
				
				if(_ease == null)
				{
					_ease = Sine.easeOut;
				}
				
				if(_transitionTime == undefined)
				{
					_transitionTime = 1;
				}
				

			}
			EnableAllRollOvers();
			TweenFilterLite.to (_carouselArray[0],0,{colorMatrixFilter:{colorize:_tint, amount:0}});

		}
		private function OnOver(e:Event):void
		{
			e.currentTarget.gotoAndStop("over");
		}
		
		private function OnOut(e:Event):void
		{
			e.currentTarget.gotoAndStop("up");
		}
		
		public function TintAll():void
		{
			for (var i:int = 0; i < _carouselArray.length; ++i)
			{
				TweenFilterLite.to (_carouselArray[i], .5, {colorMatrixFilter:{colorize:_tint, amount:_tintAmt}, overwrite:false});
			
			}

		}
		
		
		private function TrackProduct (e:Event):void
		{

			_btnID = e.currentTarget.name;
			this.dispatchEvent (new CarouselEvent(CarouselEvent.TRACKCLICK, true, true));
		}
		public function get btnID ():String
		{
			return _btnID;
		}
		private function position (c:MovieClip):void
		{
			//trace('position',c);
			if (_carouselArray.length != 2)
			{
				c.x = Math.sin (c.myAngle) * _radiusWidth + _centerX;
				c.y = Math.cos (c.myAngle) * _radiusHeight + _centerY;
			}
			else
			{
				c.x = Math.cos (c.myAngle - 10) * _radiusWidth + _centerX;
				c.y = Math.sin (c.myAngle - 10) * _radiusHeight + _centerY;
			}
			var r:Number = (c.myAngle > (Math.PI * 2)) ? c.myAngle - Math.PI * 2 : c.myAngle;
			r = (c.myAngle < 0) ? c.myAngle + Math.PI * 2 : r;

			c.scaleX = c.scaleY = Math.abs ((Math.PI - r) / Math.PI) * _depth + (1 - _depth);
			
			var sortArray:Array = new Array();
			sortArray = ArrayUtil.copyArray(_carouselArray);
			sortArray.sortOn("scaleX");
			for(var i:int = 0; i <sortArray.length; ++i)
			{
				addChild(sortArray[i]);
			}
			

		}
		//next and back btn release function

		private function TrackArrows (id:String):void
		{
			_btnID = id;
			this.dispatchEvent (new CarouselEvent(CarouselEvent.TRACKCLICK, true, true));

		}
		private function focusItems (e:Event):void
		{
			TrackArrows (e.currentTarget.name);

			e.currentTarget.mouseEnabled = true;
			e.currentTarget.gotoAndStop ('_up');

			if (e.currentTarget == _rBtn)
			{
				_currentItem++;
				if (_currentItem > _carouselArray.length - 1)
				{
					_currentItem = 0;
				}
			}
			else
			{
				_currentItem--;
				if (_currentItem < 0)
				{
					_currentItem = _carouselArray.length - 1;
				}
			}
			for (var i:Number = 0; i < _carouselArray.length; ++i)
			{
				var delta:Number = Math.PI * 2 / _carouselArray[i];
			}
			getItem (_carouselArray[_currentItem]);

		}
		//change focus and rotate

		private function prepareItem (e:Event):void
		{
			
			var mc:MovieClip = e.currentTarget as MovieClip;
			getItem (mc);
		}
		
		public function EnableAllRollOvers():void
		{
			
			if(_rolloverEnabled)
			{
				for(var i:int = 0; i <_carouselArray.length; ++i)
				{
					_carouselArray[i].buttonMode = true;
					_carouselArray[i].mouseChildren = false;
					_carouselArray[i].addEventListener (MouseEvent.MOUSE_OVER, OnOver, false, 0, true);
					_carouselArray[i].addEventListener (MouseEvent.MOUSE_OUT, OnOut, false, 0, true);
				}
				
			}
		}
			
		public function getItem (mc:MovieClip):void
		{
			EnableAllRollOvers();
			
			if(_rolloverEnabled)
			{
				mc.buttonMode = false;
				mc.removeEventListener(MouseEvent.MOUSE_OVER, OnOver);
				mc.removeEventListener(MouseEvent.MOUSE_OUT, OnOut);
			}
			
			
			_currentItem = mc.i;

			//shuffle through product details per current focus
			var pFrame:Number = _currentItem + 1;

			if (_pDetails != null)
			{
				_pDetails.gotoAndStop (pFrame);
			}
			
			if (mc.myAngle >= Math.PI)
			{
				var delta:Number = Math.PI * 2 - mc.myAngle;
			}
			else
			{
				delta = 0 - mc.myAngle;
			}
			for (var i:Number = 0; i < _carouselArray.length; ++i)
			{
				var target:MovieClip = _carouselArray[i];
				target.mouseEnabled = true;
				target.gotoAndStop ('_up');

				var newAngle:Number = target.myAngle + delta;


				TweenFilterLite.to (target, _transitionTime, {ease:_ease, myAngle:newAngle, onUpdate:position, onUpdateParams:[target], onComplete:CleanUp});

				if (target != mc)
				{
					TweenFilterLite.to (target,1,{colorMatrixFilter:{colorize:_tint, amount:_tintAmt}, overwrite:false});
				}
				else
				{
					TweenFilterLite.to (target,1,{colorMatrixFilter:{colorize:_tint, amount:0}, overwrite:false});
				}
			}
		}
		private function CleanUp ():void
		{
			
			if(_rBtn != null && _lBtn != null)
			{
				_rBtn.mouseEnabled = true;
				_lBtn.mouseEnabled = true;
			}
			

			
			for (var i:Number = 0; i < _carouselArray.length; ++i)
			{
				//enable all items to click except _currentItem
				if (i != _currentItem)
				{
					_carouselArray[i].mouseEnabled = true;
					//limit angle 
					if (_carouselArray[i].myAngle > Math.PI * 2)
					{
						_carouselArray[i].myAngle -= Math.PI * 2;
					}
					if (_carouselArray[i].myAngle < 0)
					{
						_carouselArray[i].myAngle += Math.PI * 2;
					}
				}
			}
			
		}
		
		//product details release function
		public function get currentLink():String
		{
			return _currentLink;
		}
		
		private function getLink (e:Event):void
		{
			_currentLink = _carouselArray[_currentItem].link;
			this.dispatchEvent(new CarouselEvent(CarouselEvent.GETLINK, true, true));
		}
	}
}
