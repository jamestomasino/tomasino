﻿package org.tomasino.events
{
	import flash.events.Event;
	
	public class NavEvent extends Event
	{		
		public static const ROLL_OVER:String = 'nav_roll_over';
		public static const ROLL_OUT:String = 'nav_roll_out';
		public static const CLICK:String = 'nav_click';
		public static const DEEP_LINK:String = 'nav_deep_link';
		
		private var _link:String;
		private var _data:Object;
		
		public function NavEvent (type:String, bubbles:Boolean = true, cancelable:Boolean = false):void
		{
			super (type, bubbles, cancelable);
		}
		
		public override function clone():Event
		{
			var newEvent:NavEvent = new NavEvent(type, bubbles, cancelable);
			newEvent.link = _link;
			newEvent.data = _data;
			return newEvent;
		}
		
		public function set link ( val:String ):void
		{
			_link = val;
		}
		
		public function get link ():String
		{
			return _link;
		}
		
		public function set data ( val:Object ):void
		{
			_data = val;
		}
		
		public function get data ():Object
		{
			return _data;
		}
	}
}