package com.tomasino.video
{
	import com.tomasino.logging.*;
	
	import flash.display.Sprite;
	import flash.events.*;
	import flash.media.Video;
	import flash.net.*;
	import flash.text.TextField;
	
	public class StreamingVideoPlayer extends Sprite
	{
		private var _videoURL:String;
		private var _video:Video;
		private var _vidDuration:Number;
		private var _vidXmax:Number;
		private var _vidYmax:Number;
		private var _vidWidth:Number;
		private var _vidHeight:Number;
		private var _main_nc:NetConnection = new NetConnection();
		private var _serverLoc:String;
		private var _ns:NetStream;
		private var _paused:Boolean;
		private var _autosize:Boolean;
		private var _time:Number;
		private var _bytesLoaded:Number;
		
		private var _log:Logger = new Logger ('com.tomasino.video.StreamingVideoPlayer');
		
		public function StreamingVideoPlayer (serverLoc:String, flvLocation:String, vidXmax:Number, vidYmax:Number, autosize:Boolean = false):void
		{
			_log.info ('StreamingVideoPlayer - Server Location:', serverLoc);
			_log.info ('StreamingVideoPlayer - FLV Location:', flvLocation);
			_log.info ('StreamingVideoPlayer - Maxmimum Width:', vidXmax);
			_log.info ('StreamingVideoPlayer - Maxmimum Height:', vidYmax);
			_log.info ('StreamingVideoPlayer - Autosize:', autosize);
			
			//set video params
			_videoURL = flvLocation;
			_vidXmax = vidXmax;
			_vidYmax = vidYmax;
			_autosize = autosize;
			_serverLoc = serverLoc;
			//add eventListeners to NetConnection and connect
			_main_nc.addEventListener (NetStatusEvent.NET_STATUS, onNetStatus);
			_main_nc.addEventListener (
			SecurityErrorEvent.SECURITY_ERROR,
			securityErrorHandler);
			_main_nc.client = this;
			_main_nc.connect (serverLoc);
		}
		private function onNetStatus (event:Object):void
		{
			//handles NetConnection and NetStream status events
			switch (event.info.code)
			{
				case "NetConnection.Connect.Success" :
					//play stream if connection successful
					if (_serverLoc) _main_nc.call("checkBandwidth", null);
					else connectStream ();
					break;
				case "NetStream.Play.StreamNotFound" :
					//error if stream file not found in location specified
					_log.warn ('onNetStatus - Stream not found: ' + _videoURL);
					break;
				case "NetStream.Play.Stop" :
					//do if video is stopped
					videoPlayComplete ();
					break;
			}
			_log.info ('onNetStatus -', event.info.code);
		}
		
		private function connectStream ():void
		{
			//netstream object
			_ns = new NetStream(_main_nc);
			_ns.addEventListener (AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
			_ns.addEventListener (NetStatusEvent.NET_STATUS, onNetStatus);
			//other event handlers assigned
			//to the netstream client property
			var custom_obj:Object = new Object();
			custom_obj.onMetaData = onMetaDataHandler;
			custom_obj.onCuePoint = onCuePointHandler;
			custom_obj.onPlayStatus = playStatus;
			_ns.client = custom_obj;
			//attach netstream to the video object
			_video = new Video(_vidXmax,_vidYmax);
			_video.smoothing = true;
			_video.attachNetStream (_ns);
			
			addChild (_video);
			setVideoInit ();
			if (!_serverLoc) this.addEventListener(Event.ENTER_FRAME,OnEnterFrame);
		}
		private function closeStream():void
		{
			this.removeEventListener(Event.ENTER_FRAME,OnEnterFrame);
		}
		private function OnEnterFrame(e:Event):void
		{
			if (_time != _ns.time)
			{
				_time = _ns.time;
				var e:Event = new Event(Event.CHANGE);
				dispatchEvent(e);
			}
			if (_bytesLoaded != _ns.bytesLoaded)
			{
				_bytesLoaded = _ns.bytesLoaded;
				var loadingEvent:Event = new Event("LOADING");
				dispatchEvent(loadingEvent);
			}
		}
		private function videoPlayComplete ():void
		{
			var e:Event = new Event(Event.COMPLETE);
			dispatchEvent(e);
			
			_paused = true;
			_ns.pause();
		}
		private function setVideoInit ():void
		{
			var e:Event = new Event(Event.INIT);
			dispatchEvent(e);
			
			_ns.play (_videoURL);
			//_ns.pause();
			//_paused = true;
		}
		private function playStatus (event:Object):void
		{
			//handles onPlayStatus complete event if available
			switch (event.info.code)
			{
				case "NetStream.Play.Complete" :
					//do if video play completes
					videoPlayComplete ();
					break;
			}
			_log.info ('playStatus -', event.info.code);
		}
		public function play (event:MouseEvent = null):Boolean
		{
			if (_paused == true)
			{
				_paused = false;
				_ns.togglePause ();
				return true;
			} else {
				return false;
			}
		}
		public function pause (event:MouseEvent = null):Boolean
		{
			if (_paused == false)
			{
				_paused = true;
				_ns.togglePause ();
				return true;
			} else {
				return false;
			}
		}
		public function togglePause (event:MouseEvent = null):Boolean
		{
			_ns.togglePause();
			_paused != _paused;
			return true;
		}
		public function seek (pos:Number):void
		{
			_ns.seek(pos);
		}
		
		public function addASCuePoint ( time:Number, label:String ):void
		{
			
		}
		
		public function get time ():Number
		{
			return _ns.time;
		}
		public function get duration ():Number
		{
			return _vidDuration;
		}
		public function get paused ():Boolean
		{
			return _paused;
		}
		public function get loadProgress ():Number
		{
			return _ns.bytesLoaded / _ns.bytesTotal;
		}
		private function onMetaDataHandler (metaInfoObj:Object):void
		{
			for (var s:String in metaInfoObj)
			{
				_log.info ('onMetaDataHandler -' , s,'=>', metaInfoObj[s]);
			}
			_vidDuration = metaInfoObj.duration;
			_vidHeight = metaInfoObj.height;
			_vidWidth = metaInfoObj.width;
			
			if (_autosize == true)
			{
				_video.height = metaInfoObj.height;
				_video.width = metaInfoObj.width;
			}
		}
		private function onCuePointHandler (cueInfoObj:Object):void
		{
			
		}
		
		private function securityErrorHandler (event:SecurityErrorEvent):void
		{
			_log.warn ('securityErrorHandler -', event);
		}
		
		private function asyncErrorHandler (event:AsyncErrorEvent):void
		{
			_log.warn ('asyncErrorHandler -', event.text);
		}
		
		public function onBWCheck(...args):Number {
        	return 0;
    	}
		
		public function onBWDone (...args):void{
			if (args.length > 0)
			{
				var bandwidth:Number = args[0];
			}
			_log.info ('onBWDone - Bandwidth - ', bandwidth);
			if (!isNaN(Number(bandwidth))) connectStream ();
		}
		
		public function close ():void{
			_log.info ('close - Remote Called');
		}
		
		public function onFCSubscribe(info:Object):void
		{
			_log.info ('onFCSubscribe - Remote Called');
			// We should now be subscribed to the stream.
			switch (info.code) {
				case "NetStream.Play.Start":
				// Now create your NetStream object here and do all of the other code to attach it to a Video object, etc.
				break;
			}
		}
	}
}
