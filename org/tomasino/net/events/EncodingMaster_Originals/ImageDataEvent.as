package org.tomasino.net.events
{
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	public class ImageDataEvent extends Event
	{
		public static const IMAGE_DATA:String = 'ImageDataEvent_IMAGE_DATA';
		
		public var imageData:ByteArray;
		
		public function ImageDataEvent(type:String, imageData:ByteArray = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.imageData = imageData;
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			return new ImageDataEvent ( type, imageData, bubbles, cancelable );
		}
	}
}