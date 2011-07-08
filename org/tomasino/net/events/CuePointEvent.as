package org.tomasino.net.events
{
	import org.tomasino.net.vo.CuePointVO;
	
	import flash.events.Event;
	
	public class CuePointEvent extends Event
	{
		public static const CUE_POINT:String = 'CuePointEvent_CUE_POINT';
		
		public var cuePoint:CuePointVO;
		
		public function CuePointEvent(type:String, cuePoint:CuePointVO = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.cuePoint = cuePoint;
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			return new CuePointEvent (type, cuePoint, bubbles, cancelable);
		}
	}
}