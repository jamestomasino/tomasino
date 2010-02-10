package com.tomasino.tracking
{
	import flash.events.Event;
	
	public class TrackingEvent extends Event
	{
		public static const TRACK:String = 'track';
		private var _data:TrackingData;
		private var _type:String;
		private var _bubbles:Boolean;
		private var _cancelable:Boolean;
		
		public function TrackingEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		public override function clone():Event
		{
			var t:TrackingEvent = new TrackingEvent(_type, _bubbles, _cancelable);
			t.data = _data;
			return t;
		}
		
		public function get data ():TrackingData
		{
			return _data;
		}
		public function set data (val:TrackingData):void
		{
			_data = val;
		}
	}
}
