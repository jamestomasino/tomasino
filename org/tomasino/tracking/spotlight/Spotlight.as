﻿package org.tomasino.tracking.spotlight
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
	
	import org.tomasino.net.Web;
	import org.tomasino.logging.Logger;
	
	public class Spotlight
	{
		private static var _log:Logger = new Logger ('org.tomasino.tracking.spotlight.Spotlight');
		
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

			_log.info ("Track -", url + rndSeed);
			
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
				_log.error ("Track -", "Error on path");	
			}
			
    	}

		public static function TrackExit( tag:String, url:String, scope:String ) : void 
		{
			
			_log.info ("TrackExit -", tag, url, scope);
			
			var rndSeed:int = Math.abs(Math.random() * 10000000000000);

			var parameters:String = "";
			parameters += rndSeed;
			
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
				_log.error ("TrackExit -", "Error on path");	
			}
				
    	}
		
		private static function OnLoadComplete(event:Event):void
		{
			_log.info ("OnLoadComplete -", event);
			
			var li:LoaderInfo = event.currentTarget as LoaderInfo;
			var loader:DynamicLoader = li.loader as DynamicLoader;
			if (loader.trackurl != null)
			{
				Web.getURL(loader.trackurl, loader.trackscope);
			}
		}
		private static function securityErrorHandler(event:SecurityErrorEvent):void 
		{
			_log.error ("securityErrorHandler -", event);
        }

        private static function httpStatusHandler(event:HTTPStatusEvent):void 
		{
			_log.error ("httpStatusHandler -", event);
        }

        private static function ioErrorHandler(event:IOErrorEvent):void 
		{
			_log.error ("ioErrorHandler -", event);
        }

		
	}
}
