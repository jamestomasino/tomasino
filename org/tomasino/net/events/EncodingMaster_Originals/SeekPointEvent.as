package org.tomasino.net.events
{
	import flash.events.Event;
	
	public class SeekPointEvent extends Event
	{
		public static const SEEK_POINT:String = 'MetaDataEvent_SEEK_POINT';
		
		public var seekData:Object;
		
		public function SeekPointEvent(type:String, seekData:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.seekData = seekData;
		}
		
		override public function clone():Event
		{
			return new SeekPointEvent (type, seekData, bubbles, cancelable);
		}
	}
}