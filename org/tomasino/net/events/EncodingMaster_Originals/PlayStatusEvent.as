package org.tomasino.net.events
{
	import flash.events.Event;
	
	public class PlayStatusEvent extends Event
	{
		public static const SWITCH:String = 'PlayStatusEvent_SWITCH';
		public static const COMPLETE:String = 'PlayStatusEvent_COMPLETE';
		public static const TRANSITION_COMPLETE:String = 'PlayStatusEvent_TRANSITION_COMPLETE';
		
		public function PlayStatusEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			return new PlayStatusEvent ( type, bubbles, cancelable );
		}
	}
}