package org.tomasino.tests
{
	import org.tomasino.logging.Logger;
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.utils.getTimer;

	public class BandwidthTest extends EventDispatcher
	{
		private var _bandwidthTests:Array;
		private var _detectedBandwidth:Number;
		private var _startTime:int;
		private var _downloadCount:int;
		private var _filename:String;
		private var _loader:Loader = new Loader();
		private var _timesToDownload:int;
		private var _log:Logger = new Logger (this);
		
		public function BandwidthTest(filename:String, timesToDownload:int = 1)
		{
			_downloadCount = 0;
			_bandwidthTests = new Array();
			_filename = filename;
			_timesToDownload = timesToDownload;
			if (_timesToDownload < 1) _timesToDownload = 1;
		}
		
		public function test():void
		{
			_log.info ('test -', _filename);
			var request:URLRequest = new URLRequest(_filename + "?unique="+(new Date()).getTime());
			_loader.contentLoaderInfo.addEventListener(Event.OPEN, onStart);
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoad);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onError);
			_loader.load(request);
		}
		
		private function onStart(event:Event):void
		{
			_startTime = getTimer();
		}
		
		private function onLoad(event:Event):void
		{
			var downloadTime:Number = (getTimer() - _startTime) / 1000;
			_downloadCount++;
			
			var kilobits:Number = event.target.bytesTotal / 1000 * 8;
			var kbps:Number = kilobits / downloadTime;

			_bandwidthTests.push(kbps);

			if(_downloadCount < _timesToDownload)
			{
				test();
			}
			else
			{
				dispatchCompleteEvent();
			}
		}
		
		private function onError ( event:IOErrorEvent ):void
		{
			_log.warn ('onError -', event);
			var i:IOErrorEvent = event.clone() as IOErrorEvent;
			dispatchEvent(i);
		}
		
		private function dispatchCompleteEvent():void
		{
			_detectedBandwidth = 0;
			var testLength:int = _bandwidthTests.length;
			
			for(var i:int=0 ; i < testLength; ++i)
			{
				_detectedBandwidth += _bandwidthTests[i];
			}
			
			_detectedBandwidth /= _downloadCount;
			
			dispatchEvent(new Event(Event.COMPLETE))
		}
		
		public function get detectedBandwidth():Number
		{
			return _detectedBandwidth;
		}
		
		public function get percent():Number
		{
			var p:Number = (_downloadCount) ? _downloadCount : 0;
			p = p * (100 / _timesToDownload);
			if (_loader && _loader.contentLoaderInfo)
			{
				p += (_loader.contentLoaderInfo.bytesLoaded / _loader.contentLoaderInfo.bytesTotal) * (100 / _timesToDownload);
			}
			
			if (p > 100) p = 100;
			if (isNaN(p)) p = 0;
			
			return p;
		}
	}
}