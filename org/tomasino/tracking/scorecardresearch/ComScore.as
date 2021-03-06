﻿package org.tomasino.tracking.scorecardresearch {

	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLVariables;
	
	import org.tomasino.logging.*;
	
	import flash.errors.IllegalOperationError;
	
	public class ComScore
	{
		private static var _log:Logger = new Logger ('org.tomasino.tracking.scorecardresearch.ComScore');
		
		public function ComScore () { throw new IllegalOperationError ('ComScore cannot be instantiated.'); }
		
		public static function track (...rest):void
		{
			var vars:URLVariables = new URLVariables();
			
			for (var i:int = 0; i < rest.length; ++i)
			{
				vars["c" + (i + 1)] = rest[i];
			}
			
			var req:URLRequest = new URLRequest("http://b.scorecardresearch.com/b");
			req.data = vars;
			req.method = URLRequestMethod.GET;
			
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(IOErrorEvent.IO_ERROR, onError);
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			loader.load(req);
			
			_log.info ('track -', vars);
		}
		
		static private function onError(e:IOErrorEvent):void
		{
			_log.warn ('onError -', e);
		}
		
	}
}