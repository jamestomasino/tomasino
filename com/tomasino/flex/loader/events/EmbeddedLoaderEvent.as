package com.tomasino.flex.loader.events
{
	import flash.events.Event;

	public class EmbeddedLoaderEvent extends Event
	{
		static public const LOADER_INIT:String = "LOADER_INIT";
		
		public function EmbeddedLoaderEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}
