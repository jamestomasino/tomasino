﻿package org.tomasino.display
{
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.SecurityErrorEvent;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ErrorEvent;
	import flash.events.IOErrorEvent;
	
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;

	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	
	import flash.utils.ByteArray;

	public class DuplicateLoader extends EventDispatcher
	{
		private var _byteLoader:URLLoader;
		private var _request:URLRequest;
		private var _instances:Array;
		private var _application:ApplicationDomain = new ApplicationDomain ();
		private var _context:LoaderContext = new LoaderContext ( false, _application );

		public function DuplicateLoader ( url:String = null )
		{
			if (url) load (url);
		}

		public function load ( url:String ):void
		{
			// Cleanup
			destroy ();
			
			// New Instances
			_instances = new Array();
			_byteLoader = new URLLoader ();
			_byteLoader.dataFormat = URLLoaderDataFormat.BINARY;

			// Listeners
			_byteLoader.addEventListener ( Event.COMPLETE, onBytesLoaded );
			_byteLoader.addEventListener ( SecurityErrorEvent.SECURITY_ERROR, onError );
			_byteLoader.addEventListener ( IOErrorEvent.IO_ERROR, onError );

			try
			{
				_request = new URLRequest ( url );
				_byteLoader.load ( _request );
			}
			catch (e:Error)
			{
				trace (e);
			}
		}
		
		public function convert ():void
		{
			if (_byteLoader && _byteLoader.data)
			{
				var converter:Loader = new Loader ();
				converter.contentLoaderInfo.addEventListener (Event.COMPLETE, onConvert, false, 0, true);
				
				try
				{
					converter.loadBytes ( _byteLoader.data , _context);
				}
				catch (e:Error)
				{
					trace (e);
				}
			}
			else
			{
				var e:ErrorEvent = new ErrorEvent ( ErrorEvent.ERROR, false, false, 'No data available to convert');
				dispatchEvent (e);
			}
		}
		
		public function getInstance ():DisplayObject
		{
			var returnInst:DisplayObject;
			if (_instances && _instances.length)
			{
				returnInst = _instances.shift();
			}
			return returnInst;
		}
		
		public function destroy ():void
		{
			// Remove any orphaned instances before loading a new byte-array
			if (_instances && _instances.length)
			{
				while (_instances.length)
				{
					_instances[0] = null;
					_instances.shift ();
				}
			}
			_instances = null;
			_byteLoader = null;
			_request = null;
		}
		
		/*
		 * Event Handling
		 */
		private function onError (event:ErrorEvent):void
		{
			_byteLoader.removeEventListener ( Event.COMPLETE, onBytesLoaded );
			_byteLoader.removeEventListener ( SecurityErrorEvent.SECURITY_ERROR, onError );
			_byteLoader.removeEventListener ( IOErrorEvent.IO_ERROR, onError );
			
			var e:ErrorEvent = new ErrorEvent ( ErrorEvent.ERROR, false, false, event.text);
			dispatchEvent (e);
		}
		
		private function onBytesLoaded (event:Event):void
		{
			_byteLoader.removeEventListener ( Event.COMPLETE, onBytesLoaded );
			_byteLoader.removeEventListener ( SecurityErrorEvent.SECURITY_ERROR, onError );
			_byteLoader.removeEventListener ( IOErrorEvent.IO_ERROR, onError );
			
			var e:Event = new Event ( Event.COMPLETE );
			dispatchEvent ( e );
		}
		
		private function onConvert (event:Event):void
		{
			var loaderInfo:LoaderInfo = event.target as LoaderInfo;
			var converter:Loader = loaderInfo.loader as Loader;
			converter.removeEventListener ( Event.COMPLETE, onConvert, false );
			_instances.push ( converter.content );
			converter = null;
			
			var e:Event = new Event ( Event.CHANGE );
			dispatchEvent ( e );
		}
	}
}