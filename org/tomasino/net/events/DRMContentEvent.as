package org.tomasino.net.events
{
	import flash.events.Event;
	
	public class DRMContentEvent extends Event
	{
		public static const DRM_CONTENT:String = 'DRMContentEvent_DRM_CONTENT';
		
		public var drmContent:Object;
		
		public function DRMContentEvent(type:String, drmContent:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.drmContent = drmContent;
		}
		
		override public function clone():Event
		{
			return new DRMContentEvent ( type, drmContent, bubbles, cancelable );
		}
	}
}