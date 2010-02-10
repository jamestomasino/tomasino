package com.tomasino.tracking.omniture
{
	import flash.events.Event;
	
	public class OmnitureEvent extends Event
	{
		public static const TYPE_CUSTOM_LINK:String = 'o';
		public static const TYPE_FILE_DOWNLOAD:String = 'd';
		public static const TYPE_EXIT_LINK:String = 'e';
		
		public static const TRACK:String = 'omniture_track';
		
		public var data:OmnitureTrackData;
		
		public function OmnitureEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			data = new OmnitureTrackData();
			super(type, bubbles, cancelable);
		}
		
		override public function clone ():Event
		{
			var oe:OmnitureEvent = new OmnitureEvent (type, bubbles, cancelable);
			oe.data = data;
			return oe;
		}
	}
}