package com.tomasino.flex.loader
{
	import com.tomasino.flex.loader.events.EmbeddedLoaderEvent;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	import mx.containers.Canvas;
	/*
	 EmbeddedLoader Version 1
	 by Josh Barber
	 
	 The purpose of this class is to embed external swf assets at compile time, while retaining those external swfs' native code.
	 Without this class, if you embed a swf into a Flex app, the ActionScript present in that swf is removed.  This class embeds the swf
	 as a byte array 
	 
	 
	*/
	public class EmbeddedLoader extends Canvas
	{
		private var myLoader:MoxieLoader = new MoxieLoader();
		public var resource:Object = new Object();
		
		public function EmbeddedLoader(resource:Class){
			super();
			var resourceBytes:ByteArray = (new resource as ByteArray);
			myLoader.loadBytes(resourceBytes, new LoaderContext(false, ApplicationDomain.currentDomain));
			myLoader.addEventListener(Event.COMPLETE, onAssetLoaded,false,0,true);
		}
		
		private function onAssetLoaded(evt:Event):void{
			resource = myLoader.content as Object;
			var contentDisplayObject:DisplayObject = myLoader.content as DisplayObject;
			this.rawChildren.addChild(contentDisplayObject);
			this.dispatchEvent(new EmbeddedLoaderEvent(EmbeddedLoaderEvent.LOADER_INIT, true));
		}
		
		
	}
}
