﻿package org.tomasino.tracking.hbx
{
	import flash.events.Event;
	
	public class HBXEventDelayComplete extends Event
	{
		public static const EVENT_DELAY_COMPLETE:String = 'EVENT_DELAY_COMPLETE';
		
		private var _objTrackObject:HBXTrackObject;
		
		public function HBXEventDelayComplete(oTrackObject:HBXTrackObject)
		{
			super(EVENT_DELAY_COMPLETE);
			_objTrackObject = oTrackObject.clone();
		}
		
		public function get TrackObject():HBXTrackObject
		{
			return _objTrackObject;
		}
	}
}
