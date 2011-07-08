package org.tomasino.video
{
	import org.tomasino.logging.*;
	import org.tomasino.net.SimpleNetStream;
	import org.tomasino.net.events.CuePointEvent;
	import org.tomasino.net.events.MetaDataEvent;
	import org.tomasino.net.events.PlayStatusEvent;
	import org.tomasino.net.vo.NetConstants;
	
	import flash.display.Sprite;
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.media.Video;
	import flash.net.NetConnection;
	
	
	public class StreamingVideoPlayer extends Sprite
	{
		private var _videoURL:String;
		private var _video:Video;
		private var _vidDuration:Number;
		private var _maxWidth:Number;
		private var _maxHeight:Number;
		private var _vidWidth:Number;
		private var _vidHeight:Number;
		
		private var _netConnection:NetConnection = new NetConnection();
		private var _ns:SimpleNetStream;
		private var _serverLoc:String;
		
		private var _repeat:Boolean;
		private var _isPaused:Boolean;
		private var _isAutosize:Boolean;
		private var _time:Number;
		private var _bytesLoaded:Number;
		
		private var _log:Logger = new Logger (this);
		
		public function StreamingVideoPlayer (serverLoc:String, flvLocation:String, maxWidth:Number, maxHeight:Number, autosize:Boolean = false):void
		{
			_log.info ('StreamingVideoPlayer - Server Location:', serverLoc);
			_log.info ('StreamingVideoPlayer - FLV Location:', flvLocation);
			_log.info ('StreamingVideoPlayer - Maxmimum Width:', maxWidth);
			_log.info ('StreamingVideoPlayer - Maxmimum Height:', maxHeight);
			_log.info ('StreamingVideoPlayer - Autosize:', autosize);
			
			//set video params
			_videoURL = flvLocation;
			_maxWidth = maxWidth;
			_maxHeight = maxHeight;
			_isAutosize = autosize;
			_serverLoc = serverLoc;
			
			//add eventListeners to NetConnection and connect
			_netConnection.addEventListener (NetStatusEvent.NET_STATUS, onNetStatus);
			_netConnection.addEventListener (SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			_netConnection.client = this;
			_netConnection.connect (serverLoc);
		}
		
		public function get time ():Number { return _ns.time; }
		public function get duration ():Number { return _vidDuration; }
		public function get paused ():Boolean { return _isPaused; }
		public function get loadProgress ():Number { return _ns.bytesLoaded / _ns.bytesTotal; }
		public function get repeat ():Boolean { return _repeat; }
		public function set repeat (val:Boolean):void { _repeat = val; }
		public function set smoothing (val:Boolean):void { if (_video) _video.smoothing = val; }
		public function get smoothing ():Boolean { return (_video) ? _video.smoothing : true; }
		
		private function connectStream ():void
		{
			_ns = new SimpleNetStream (_netConnection);
			_ns.addEventListener (AsyncErrorEvent.ASYNC_ERROR, onAsyncError);
			_ns.addEventListener (NetStatusEvent.NET_STATUS, onNetStatus);
			_ns.addEventListener (CuePointEvent.CUE_POINT, onCuePoint);
			_ns.addEventListener (MetaDataEvent.META_DATA, onMetaData);
			_ns.addEventListener (PlayStatusEvent.COMPLETE, onPlayComplete);
			
			//attach netstream to the video object
			_video = new Video(_maxWidth,_maxHeight);
			_video.smoothing = true;
			_video.attachNetStream (_ns);
			
			addChild (_video);
			dispatchEvent(new Event(Event.INIT));
			_ns.play (_videoURL);
			if (!_serverLoc) this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function videoPlayComplete ():void
		{
			var e:Event = new Event(Event.COMPLETE);
			dispatchEvent(e);
			
			if (_repeat)
			{
				_ns.seek(0);
			}
			else
			{
				_isPaused = true;
				_ns.pause();
			}
		}
		
		public function play (event:MouseEvent = null):Boolean
		{
			if (_isPaused == true)
			{
				_isPaused = false;
				_ns.togglePause ();
				return true;
			} else {
				return false;
			}
		}
		public function pause (event:MouseEvent = null):Boolean
		{
			if (_isPaused == false)
			{
				_isPaused = true;
				_ns.togglePause ();
				return true;
			} else {
				return false;
			}
		}
		public function togglePause (event:MouseEvent = null):Boolean
		{
			_ns.togglePause();
			_isPaused != _isPaused;
			return true;
		}
		
		public function seek (pos:Number):void
		{
			_ns.seek(pos);
		}
		
		public function addASCuePoint ( time:Number, label:String ):void
		{
			// Currently no way to do this that I know of
		}
		
		private function onNetStatus (event:Object):void
		{
			var code:String = event['info']['code'] as String;
			switch (code)
			{
				case NetConstants.NETCONNECTION_CONNECT_SUCCESS:
					if (_serverLoc) _netConnection.call("checkBandwidth", null);
					else connectStream ();
					break;
				case NetConstants.NETSTREAM_PLAY_STREAM_NOT_FOUND:
					_log.warn ('onNetStatus - Stream not found: ' + _videoURL);
					break;
				case NetConstants.NETSTREAM_PLAY_STOP:
					videoPlayComplete ();
					break;
			}
		}
		
		private function onMetaData (metaDateEvent:MetaDataEvent):void
		{
			var metaData:Object = metaDateEvent.metaData;
			
			for (var s:String in metaData)
			{
				_log.info ('onMetaData -' , s,'=>', metaData[s]);
			}
			
			_vidDuration = metaData['duration'];
			_vidHeight = metaData['height'];
			_vidWidth = metaData['width'];
			
			if (_isAutosize == true)
			{
				_video.height = metaData['height'];
				_video.width = metaData['width'];
			}
		}
		
		private function onCuePoint (cuePointEvent:CuePointEvent):void
		{
			dispatchEvent (cuePointEvent.clone());
		}
		
		private function onEnterFrame(e:Event):void
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
		
		private function onPlayComplete (event:PlayStatusEvent):void
		{
			videoPlayComplete ();
		}
		
		private function onSecurityError (event:SecurityErrorEvent):void
		{
			_log.warn ('onSecurityError -', event);
		}
		
		private function onAsyncError (event:AsyncErrorEvent):void
		{
			_log.warn ('onAsyncError -', event.text);
		}
		
		
		
		
		/* FMS Calls */
		
		public function onBWCheck(...args):Number 
		{
        		return 0;
    		}
		
		public function onBWDone (...args):void
		{
			if (args.length > 0)
			{
				var bandwidth:Number = args[0];
			}
			_log.info ('onBWDone - Bandwidth - ', bandwidth);
			if (!isNaN(Number(bandwidth))) connectStream ();
		}
		
		public function close ():void
		{
			_log.info ('close - Remote Called');
		}
		
		public function onFCSubscribe(info:Object):void
		{
			_log.info ('onFCSubscribe - Remote Called');
			// We should now be subscribed to the stream.
			switch (info['code']) 
			{
				case "NetStream.Play.Start":
				// Now create your NetStream object here and do all of the other code to attach it to a Video object, etc.
				break;
			}
		}
	}
}
