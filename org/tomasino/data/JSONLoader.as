﻿package org.tomasino.data
{
	import com.adobe.serialization.json.JSON;
	import org.tomasino.events.DataEvent;
	import org.tomasino.logging.Logger;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;

	public class JSONLoader extends EventDispatcher
	{
		private var _log:Logger = new Logger (this);
		
		public function JSONLoader()
		{
			super();
		}
		
		public function load (url:String):void
		{
			var request:URLRequest = new URLRequest(url);
			var loader:URLLoader = new URLLoader();
			var vars:URLVariables = new URLVariables();
			
			request.data = vars;
			request.method = URLRequestMethod.GET;
			
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			loader.addEventListener(Event.COMPLETE, onLoadComplete);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			loader.load(request);
			_log.info ('load - Loading URL -', url);
		}
		
		private function onLoadComplete ( event:Event ):void
		{
			_log.info ('onLoadComplete -', event);
			
			var loader:URLLoader = URLLoader(event.target);
			var response:String = loader.data;
			parseJSON (response);
		}
		
		private function onIOError ( event:IOErrorEvent ):void
		{
			_log.warn ('onIOError -', event);
		}
		
		private function parseJSON ( s:String ):void
		{
			
			_log.info ('parseJSON -', s);
			
			var responseObject:Object;
			
			try
			{
				responseObject = JSON.decode(s);
			}
			catch (e:Error)
			{
				_log.warn ('parseJSON -', e);
			}
			
			var de:DataEvent = new DataEvent( DataEvent.COMPLETE );
			de.data = responseObject;
			dispatchEvent ( de );
		}
	}
}