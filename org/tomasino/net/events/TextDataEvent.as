package org.tomasino.net.events
{
	import flash.events.Event;
	
	public class TextDataEvent extends Event
	{
		public static const TEXT_DATA:String = 'MetaDataEvent_TEXT_DATA';
		
		public var textData:Object;
		
		public function TextDataEvent(type:String, textData:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.textData = textData;
		}
		
		override public function clone():Event
		{
			return new TextDataEvent (type, textData, bubbles, cancelable);
		}
	}
}