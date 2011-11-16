﻿package org.tomasino.events
{
	import flash.events.Event;
	
	public class KeyCodeEvent extends Event
	{
		public static const MATCH:String = 'keycodeevent_match';
		
		public var key:Array;
		
		public function KeyCodeEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false )
		{
			super ( type, bubbles, cancelable );
		}
		
		override public function clone ():Event
		{
			var kce:KeyCodeEvent = new KeyCodeEvent ( type, bubbles, cancelable );
			kce.key = key;
			return kce;
		}
	}
}
