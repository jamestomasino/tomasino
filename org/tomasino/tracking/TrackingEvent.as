﻿package org.tomasino.tracking
{
	import flash.events.Event;
	
	public class TrackingEvent extends Event
	{
		public static const TRACK:String = 'track';
		private var _data:TrackingData;
		private var _type:String;
		private var _bubbles:Boolean;
		private var _cancelable:Boolean;
		
		public function TrackingEvent(data:TrackingData = null)
		{
			super(TrackingEvent.TRACK, true, false);
			_data = data || new TrackingData ();
		}
		
		public override function clone():Event
		{
			return new TrackingEvent(_data);
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
