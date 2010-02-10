package com.tomasino.tracking.spotlight
{
	import com.adobe.net.DynamicLoader;
	
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	import com.tomasino.net.Web;
	import com.tomasino.utils.Debug;
	
	public class Spotlight
	{

		private static var _debug:Boolean;
		public static function get debug():Boolean {return _debug;}
		public static function set debug(value:Boolean):void {_debug = value;}
		
		
		private static var _urlToLoad:String;
		private static var _scope:String;
		private static var _t:Timer;
		
		
		public function Spotlight ():void
		{
			throw new Error("Error: Instantiation failed: This is a static class.");
		}
		
				
		public static function Track(url:String) : void 
		{
			var rndSeed:int = Math.abs(Math.random() * 10000000000000);

			if (_debug) Debug.out ("Spotlight::Track", url + rndSeed);
			
			var loader:DynamicLoader = new DynamicLoader();
			
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, OnLoadComplete);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			loader.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
			
			try 
			{
				loader.load (new URLRequest(url + rndSeed));
			} 
			catch (error:Error)
			{
				if (_debug) Debug.out ("Spotlight::Track", "Error on path");	
			}
			
    	}

		public static function TrackExit( tag:String, url:String, scope:String ) : void 
		{
			
			if (_debug) Debug.out ("Spotlight::TrackExit", tag, url, scope);
			
			var rndSeed:int = Math.abs(Math.random() * 10000000000000);

			var parameters:String = "";
			parameters += rndSeed;
			//parameters += "&type=" + escape(type);
			
			

			var path:String = tag + parameters;

						
			var loader:DynamicLoader = new DynamicLoader();
			loader.trackurl = url;
			loader.trackscope = scope;
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, OnLoadComplete);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			loader.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
			
			try 
			{
				loader.load (new URLRequest(path));
			} catch (error:Error)
			{
				if (_debug) Debug.out ("Spotlight::TrackExit", "Error on path");	
			}
				
    	}
		
		private static function OnLoadComplete(event:Event):void
		{
			if (_debug) Debug.out ("Spotlight::OnLoadComplete", event);
			
			var li:LoaderInfo = event.currentTarget as LoaderInfo;
			var loader:DynamicLoader = li.loader as DynamicLoader;
			if (loader.trackurl != null)
			{
				Web.getURL(loader.trackurl, loader.trackscope);
			}
		}
		private static function securityErrorHandler(event:SecurityErrorEvent):void 
		{
			if (_debug) Debug.out ("Spotlight::securityErrorHandler", event);
        }

        private static function httpStatusHandler(event:HTTPStatusEvent):void 
		{
			if (_debug) Debug.out ("Spotlight::httpStatusHandler", event);
        }

        private static function ioErrorHandler(event:IOErrorEvent):void 
		{
			if (_debug) Debug.out ("Spotlight::ioErrorHandler", event);
        }

		
	}
}
