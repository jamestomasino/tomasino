package org.tomasino.tracking.omniture
{
	import flash.events.Event;
	
	public class OmnitureEvent extends Event
	{
		public static const TRACK:String = 'omniture_track';
		
		public var data:OmnitureTrackData;
		
		public function OmnitureEvent(_data:OmnitureTrackData = null)
		{
			super(OmnitureEvent.TRACK, true, false);
			data = _data || new OmnitureTrackData();
		}
		
		override public function clone ():Event
		{
			return new OmnitureEvent (data);
		}
	}
}
