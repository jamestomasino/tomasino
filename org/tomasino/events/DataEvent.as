package org.tomasino.events
{
	import flash.events.Event;
	
	public class DataEvent extends Event
	{
		public static const COMPLETE:String = 'dataevent_complete';
		public static const START:String = 'dataevent_start';
		public static const CHANGE:String = 'dataevent_change';
		
		public var data:*;
		
		public function DataEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		override public function clone ():Event
		{
			var de:DataEvent = new DataEvent (type, bubbles, cancelable);
			de.data = data;
			return de;
		}
	}
}