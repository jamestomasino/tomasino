package com.tomasino.display.carousel
{
	import flash.events.Event;

	public class CarouselEvent extends Event
	{
		public static  var TRACKCLICK:String = "trackclick";
		public static var GETLINK:String = "getLink";
		
		public var _type:String;
		public var _bubbles:Boolean;
		public var _cancelable:Boolean;

		public function CarouselEvent (type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			_type = type;
			_bubbles = bubbles;
			_cancelable = cancelable;
			super (type, bubbles, cancelable);
			
			trace('CAROUSELEVENT',type);
		}
		override public function clone ():Event
		{
			return new CarouselEvent(_type,_bubbles,_cancelable);
		}
	}
}
