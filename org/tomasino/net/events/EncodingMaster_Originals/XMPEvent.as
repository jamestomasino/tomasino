package org.tomasino.net.events
{
	import flash.events.Event;
	
	public class XMPEvent extends Event
	{
		public static const XMP:String = 'XMPEvent_XMP';
		
		public var UUID:String;
		
		public function XMPEvent(type:String, UUID:String = '', bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.UUID = UUID;
		}
		
		override public function clone():Event
		{
			return new XMPEvent ( type, UUID, bubbles, cancelable );
		}
	}
}