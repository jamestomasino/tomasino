﻿package org.tomasino.events
{
	import flash.events.Event;
	
	public class PreloadEvent extends Event
	{
		public static const PRELOAD_START:String = 'preload_start';
		public static const PRELOAD_END:String = 'preload_end';
		public static const PRELOAD_CLEAR:String = 'preload_clear';
		
		public var id:String;
		
		public function PreloadEvent (type:String, bubbles:Boolean = true, cancelable:Boolean = false):void
		{
			super (type, bubbles, cancelable);
		}
		
		public override function clone():Event
		{
			var newEvent:PreloadEvent = new PreloadEvent(type, bubbles, cancelable);
			newEvent.id = id;
			return newEvent;
		}
	}
}