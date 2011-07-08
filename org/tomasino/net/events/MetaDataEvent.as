package org.tomasino.net.events
{
	import flash.events.Event;
	
	public class MetaDataEvent extends Event
	{
		public static const META_DATA:String = 'MetaDataEvent_META_DATA';
		
		public var metaData:Object;
		
		public function MetaDataEvent(type:String, metaData:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.metaData = metaData;
		}
		
		override public function clone():Event
		{
			return new MetaDataEvent (type, metaData, bubbles, cancelable);
		}
	}
}