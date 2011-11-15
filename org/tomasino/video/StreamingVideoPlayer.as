package org.tomasino.video
{
	import org.tomasino.logging.*;
	import org.tomasino.net.SimpleNetStream;
	import org.tomasino.net.events.*;
	import org.tomasino.net.vo.*;
	
	import flash.display.Sprite;
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.StatusEvent;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	
	public class StreamingVideoPlayer extends Sprite
	{
		private var _videoURL:String;
		private var _video:Video;
		private var _vidDuration:Number;
		private var _maxWidth:Number;
		private var _maxHeight:Number;
		private var _vidWidth:Number;
		private var _vidHeight:Number;
		
		private var _volume:Number = 1;
		private var _netConnection:NetConnection = new NetConnection();
		private var _ns:SimpleNetStream;
		private var _serverLoc:String;
		
		private var _repeat:Boolean;
		private var _isPaused:Boolean;
		private var _isAutosize:Boolean;
		private var _time:Number;
		private var _bytesLoaded:Number;
		private var _isMuted:Boolean = false;
		private var _isDestroying:Boolean = false;

		private var _playTimeUpdateListener:Boolean = false;
		
		// For Seeking
		private var _isSeeking:Boolean = false;
		private var _lastSeekableTime:Number;
		private var _lastSeekTime:Number;
		private var _seekID:Number = -1;
		
		// For cuePoints
		private var _firstCuePoint:CuePointVO;

		private var _log:Logger = new Logger (this);
		
		public function StreamingVideoPlayer (serverLoc:String, flvLocation:String, maxWidth:Number, maxHeight:Number, autosize:Boolean = false, volume:Number = 1):void
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
			_volume = volume;
			
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
		public function get isSeeking ():Boolean { return _isSeeking; }
		public function get mute ():Boolean { return _isMuted }
		public function set mute (val:Boolean):void 
		{
			_isMuted = val;
			if (val)
			{
				if (_ns) _ns.soundTransform = new SoundTransform (0);
			}
			else
			{
				volume = _volume;
			}
		}
		public function get volume ():Number { return ( _isMuted ) ? 0 : _volume }
		public function set volume (val:Number):void 
		{
			_volume = val;
			if (_ns)
			{
				if (val != 0)
				{
					_isMuted = false;
				}
				
				_ns.soundTransform = new SoundTransform (_volume);
			}
		}
		
		private function connectStream ():void
		{
			_ns = new SimpleNetStream (_netConnection);
			
			// Stuff We actually care about
			_ns.addEventListener (AsyncErrorEvent.ASYNC_ERROR, onAsyncError);
			_ns.addEventListener (NetStatusEvent.NET_STATUS, onNetStatus);
			_ns.addEventListener (CuePointEvent.CUE_POINT, onCuePoint);
			_ns.addEventListener (MetaDataEvent.META_DATA, onMetaData);
			_ns.addEventListener (PlayStatusEvent.COMPLETE, onPlayComplete);
			
			
			// Dispatch Clones for NetStream
			_ns.addEventListener ( NetStatusEvent.NET_STATUS, onClonableEvent);
			_ns.addEventListener ( AsyncErrorEvent.ASYNC_ERROR, onClonableEvent);
			_ns.addEventListener ( StatusEvent.STATUS, onClonableEvent );
			_ns.addEventListener ( IOErrorEvent.IO_ERROR, onClonableEvent );
			_ns.addEventListener ( DRMContentEvent.DRM_CONTENT, onClonableEvent );
			_ns.addEventListener ( CuePointEvent.CUE_POINT, onClonableEvent );
			_ns.addEventListener ( ImageDataEvent.IMAGE_DATA, onClonableEvent );
			_ns.addEventListener ( MetaDataEvent.META_DATA, onClonableEvent);
			_ns.addEventListener ( PlayStatusEvent.COMPLETE, onClonableEvent);
			_ns.addEventListener ( SeekPointEvent.SEEK_POINT, onClonableEvent);
			_ns.addEventListener ( TextDataEvent.TEXT_DATA, onClonableEvent );
			_ns.addEventListener ( XMPEvent.XMP, onClonableEvent );
			
			
			//attach netstream to the video object
			_video = new Video(_maxWidth,_maxHeight);
			_video.smoothing = true;
			_video.attachNetStream (_ns);
			
			// Handle Audio
			volume = _volume; 
			
			addChild (_video);
			dispatchEvent (new Event ( NetConstants.NETSTREAM_INIT ) );
			_ns.play (_videoURL);
			if (!_serverLoc) this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onClonableEvent ( e:Event ):void
		{
			dispatchEvent ( e.clone() );
		}
		
		private function videoPlayComplete ():void
		{
			var e:Event = new Event(NetConstants.NETSTREAM_PLAY_COMPLETE);

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
			} 
			else 
			{
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
			} 
			else 
			{
				return false;
			}
		}
		public function togglePause (event:MouseEvent = null):Boolean
		{
			_ns.togglePause();
			_isPaused != _isPaused;
			return true;
		}
		
		public function seek (time:Number):void
		{
			if ( time != _lastSeekTime )
			{
				if ( time > _lastSeekableTime )
				{
					time = _lastSeekableTime;
				}
				_lastSeekTime = time;
				_isSeeking = true;
				
				// Cleanup
				if ( _seekID != -1 )
				{
					clearInterval ( _seekID );
					_seekID = -1;
				}
			}
			
			_seekID = setInterval( checkForTimeUpdate, 1, time );
			_ns.seek( time );
		}
		
		private function checkForTimeUpdate ( snapshot:Number ):void
		{
			if ( _ns.time != snapshot )
			{
				clearInterval( _seekID );
				_seekID = -1;
				_isSeeking = false;
				_lastSeekTime = -1;
				dispatchEvent( new Event ( NetConstants.NETSTREAM_SEEK_NOTIFY ) ); // Only dispatch this after we have a valid new time
			}
		}

		override public function addEventListener (type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false ):void
		{
			if (type == NetConstants.NETSTREAM_PLAY_TIME_UPDATE) 
			{
				_playTimeUpdateListener = true;
			}
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		public function addASCuePoint ( time:Number, label:String ):void
		{
			var prevCuePoint:CuePointVO = _firstCuePoint;

			if (prevCuePoint != null && prevCuePoint.time > time) 
			{
				prevCuePoint = null;
			} 
			else 
			{
				while (prevCuePoint && prevCuePoint.time <= time && prevCuePoint.next && prevCuePoint.next.time <= time) 
				{
					prevCuePoint = prevCuePoint.next;
				}
			}

			var cuePoint:CuePointVO = new CuePointVO ( time, name, '', prevCuePoint );

			if ( prevCuePoint == null )
			{
				if ( _firstCuePoint != null ) 
				{
					_firstCuePoint.prev = cuePoint;
					cuePoint.next = _firstCuePoint;
				}

				_firstCuePoint = cuePoint;
			}
		}

		public function removeASCuePoint(timeNameOrCuePoint:*):void 
		{
			var cuePoint:CuePointVO = _firstCuePoint;
		
			while (cuePoint) 
			{
				if (cuePoint == timeNameOrCuePoint || cuePoint.time == timeNameOrCuePoint || cuePoint.name == timeNameOrCuePoint) 
				{
					if (cuePoint.next) 
					{
						cuePoint.next.prev = cuePoint.prev;
					}

					if (cuePoint.prev) 
					{
						cuePoint.prev.next = cuePoint.next;
					} 
					else if (cuePoint == _firstCuePoint) 
					{
						_firstCuePoint = cuePoint.next;
					}

					cuePoint.next = cuePoint.prev = null;

					return;
				}

				cuePoint = cuePoint.next;
			}

			return;
		}

		public function getCuePointTime(name:String):Number 
		{
			if (_ns.metaData != null && _ns.metaData.cuePoints is Array) 
			{
				var i:int = _ns.metaData.cuePoints.length;
				while (--i > -1) 
				{
					if (name == _ns.metaData.cuePoints[i].name) 
					{
						return Number(_ns.metaData.cuePoints[i].time);
					}
				}
			}
			
			var cuePoint:CuePointVO = _firstCuePoint;
			
			while (cuePoint) 
			{
				if (cuePoint.name == name) 
				{
					return cuePoint.time;
				}

				cuePoint = cuePoint.next;
			}

			return NaN;
		}

		
		private function onNetStatus (event:Object):void
		{
			var code:String = event['info']['code'] as String;
			switch (code)
			{
				case NetConstants.NETCONNECTION_CONNECT_SUCCESS:
					if (_serverLoc) _netConnection.call( "checkBandwidth", null );
					else connectStream ();
					dispatchEvent ( new Event ( NetConstants.NETCONNECTION_CONNECT_SUCCESS ) ); 
					break;
				case NetConstants.NETCONNECTION_CALL_BAD_VERSION:
					dispatchEvent ( new Event ( NetConstants.NETCONNECTION_CALL_BAD_VERSION ) ); 
					break;
				case NetConstants.NETCONNECTION_CALL_FAILED:
					dispatchEvent ( new Event ( NetConstants.NETCONNECTION_CALL_FAILED ) ); 
					break;
				case NetConstants.NETCONNECTION_CALL_PROHIBITED:
					dispatchEvent ( new Event ( NetConstants.NETCONNECTION_CALL_PROHIBITED ) ); 
					break;
				case NetConstants.NETCONNECTION_CONNECT_FAILED:
					dispatchEvent ( new Event ( NetConstants.NETCONNECTION_CONNECT_FAILED ) ); 
					break;
				case NetConstants.NETCONNECTION_CONNECT_CLOSED:
					dispatchEvent ( new Event ( NetConstants.NETCONNECTION_CONNECT_CLOSED ) ); 
					break;
				case NetConstants.NETCONNECTION_CONNECT_REJECTED:
					dispatchEvent ( new Event ( NetConstants.NETCONNECTION_CONNECT_REJECTED ) ); 
					break;
				case NetConstants.NETCONNECTION_CONNECT_APP_SHUTDOWN:
					dispatchEvent ( new Event ( NetConstants.NETCONNECTION_CONNECT_APP_SHUTDOWN ) ); 
					break;
				case NetConstants.NETCONNECTION_CONNECT_INVALID_APP:
					dispatchEvent ( new Event ( NetConstants.NETCONNECTION_CONNECT_INVALID_APP ) ); 
					break;
				case NetConstants.NETSTREAM_PLAY_STREAM_NOT_FOUND:
					_log.warn ('onNetStatus - Stream not found: ' + _videoURL);
					dispatchEvent ( new Event ( NetConstants.NETSTREAM_PLAY_STREAM_NOT_FOUND ) );
					break;
				case NetConstants.NETSTREAM_PLAY_STOP:
					videoPlayComplete ();
					dispatchEvent ( new Event ( NetConstants.NETSTREAM_PLAY_STOP ) );
					break;
				case NetConstants.NETSTREAM_SEEK_FAILED:
					_log.warn ('onNetStatus - Seek Failed: ' + _ns.time);
					clearInterval ( _seekID );
					_isSeeking = false;
					dispatchEvent ( new Event ( NetConstants.NETSTREAM_SEEK_FAILED ) );
					break;
				case NetConstants.NETSTREAM_SEEK_INVALID_TIME:
					_log.warn ('onNetStatus - Seek Invalid Time: ' + _ns.time);
					clearInterval ( _seekID );
					_isSeeking = false;
					var lvtime:Number = parseFloat ( event['info']['details'] );
					seek ( lvtime );
					dispatchEvent ( new Event ( NetConstants.NETSTREAM_SEEK_INVALID_TIME ) );
					break;
				case NetConstants.NETSTREAM_PLAY_SWITCH:
					dispatchEvent ( new Event ( NetConstants.NETSTREAM_PLAY_SWITCH ) );
					break;
				case NetConstants.NETSTREAM_PLAY_COMPLETE:
					dispatchEvent ( new Event ( NetConstants.NETSTREAM_PLAY_COMPLETE ) );
					break;
				case NetConstants.NETSTREAM_PLAY_TRANSITION_COMPLETE:
					dispatchEvent ( new Event ( NetConstants.NETSTREAM_PLAY_TRANSITION_COMPLETE ) );
					break;
				case NetConstants.NETSTREAM_BUFFER_EMPTY:
					dispatchEvent ( new Event ( NetConstants.NETSTREAM_BUFFER_EMPTY ) );
					break;
				case NetConstants.NETSTREAM_BUFFER_FULL:
					dispatchEvent ( new Event ( NetConstants.NETSTREAM_BUFFER_FULL ) );
					break;
				case NetConstants.NETSTREAM_BUFFER_FLUSH:
					dispatchEvent ( new Event ( NetConstants.NETSTREAM_BUFFER_FLUSH ) );
					break;
				case NetConstants.NETSTREAM_FAILED:
					dispatchEvent ( new Event ( NetConstants.NETSTREAM_FAILED ) );
					break;
				case NetConstants.NETSTREAM_PUBLISH_START:
					dispatchEvent ( new Event ( NetConstants.NETSTREAM_PUBLISH_START ) );
					break;
				case NetConstants.NETSTREAM_PUBLISH_BADNAME:
					dispatchEvent ( new Event ( NetConstants.NETSTREAM_PUBLISH_BADNAME ) );
					break;
				case NetConstants.NETSTREAM_PUBLISH_IDLE:
					dispatchEvent ( new Event ( NetConstants.NETSTREAM_PUBLISH_IDLE ) );
					break;
				case NetConstants.NETSTREAM_UNPUBLISH_SUCCESS:
					dispatchEvent ( new Event ( NetConstants.NETSTREAM_UNPUBLISH_SUCCESS ) );
					break;
				case NetConstants.NETSTREAM_PLAY_START:
					dispatchEvent ( new Event ( NetConstants.NETSTREAM_PLAY_START ) );
					break;
				case NetConstants.NETSTREAM_PLAY_STOP:
					dispatchEvent ( new Event ( NetConstants.NETSTREAM_PLAY_STOP ) );
					break;
				case NetConstants.NETSTREAM_PLAY_FAILED:
					dispatchEvent ( new Event ( NetConstants.NETSTREAM_PLAY_FAILED ) );
					break;
				case NetConstants.NETSTREAM_PLAY_STREAM_NOT_FOUND:
					dispatchEvent ( new Event ( NetConstants.NETSTREAM_PLAY_STREAM_NOT_FOUND ) );
					break;
				case NetConstants.NETSTREAM_PLAY_RESET:
					dispatchEvent ( new Event ( NetConstants.NETSTREAM_PLAY_RESET ) );
					break;
				case NetConstants.NETSTREAM_PLAY_PUBLISH_NOTIFY:
					dispatchEvent ( new Event ( NetConstants.NETSTREAM_PLAY_PUBLISH_NOTIFY ) );
					break;
				case NetConstants.NETSTREAM_PLAY_UNPUBLISH_NOTIFY:
					dispatchEvent ( new Event ( NetConstants.NETSTREAM_PLAY_UNPUBLISH_NOTIFY ) );
					break;
				case NetConstants.NETSTREAM_PLAY_INSUFFICIENT_BW:
					dispatchEvent ( new Event ( NetConstants.NETSTREAM_PLAY_INSUFFICIENT_BW ) );
					break;
				case NetConstants.NETSTREAM_PLAY_FILE_STRUCTURE_INVALID:
					dispatchEvent ( new Event ( NetConstants.NETSTREAM_PLAY_FILE_STRUCTURE_INVALID ) );
					break;
				case NetConstants.NETSTREAM_PLAY_NO_SUPPORTED_TRACK_FOUND:
					dispatchEvent ( new Event ( NetConstants.NETSTREAM_PLAY_NO_SUPPORTED_TRACK_FOUND ) );
					break;
				case NetConstants.NETSTREAM_PAUSE_NOTIFY:
					dispatchEvent ( new Event ( NetConstants.NETSTREAM_PAUSE_NOTIFY ) );
					break;
				case NetConstants.NETSTREAM_UNPAUSE_NOTIFY:
					dispatchEvent ( new Event ( NetConstants.NETSTREAM_UNPAUSE_NOTIFY ) );
					break;
				case NetConstants.NETSTREAM_RECORD_START:
					dispatchEvent ( new Event ( NetConstants.NETSTREAM_RECORD_START ) );
					break;
				case NetConstants.NETSTREAM_RECORD_NO_ACCESS:
					dispatchEvent ( new Event ( NetConstants.NETSTREAM_RECORD_NO_ACCESS ) );
					break;
				case NetConstants.NETSTREAM_RECORD_STOP:
					dispatchEvent ( new Event ( NetConstants.NETSTREAM_RECORD_STOP ) );
					break;
				case NetConstants.NETSTREAM_RECORD_FAILED:
					dispatchEvent ( new Event ( NetConstants.NETSTREAM_RECORD_FAILED ) );
					break;
				case NetConstants.NETSTREAM_SEEK_FAILED:
					dispatchEvent ( new Event ( NetConstants.NETSTREAM_SEEK_FAILED ) );
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
			
			_lastSeekTime = _vidDuration = metaData['duration'];
			_vidHeight = metaData['height'];
			_vidWidth = metaData['width'];
			
			if (_isAutosize == true)
			{
				_video.height = metaData['height'];
				_video.width = metaData['width'];
			}
			
			dispatchEvent ( new Event ( NetConstants.NETSTREAM_META_DATA ) );
		}
		
		private function onCuePoint (cuePointEvent:CuePointEvent):void
		{
			dispatchEvent (cuePointEvent.clone());
		}
		
		private function onEnterFrame(e:Event):void
		{
			if ( _firstCuePoint || _playTimeUpdateListener )
			{
				if (_time != _ns.time)
				{
					if (!_isSeeking)
					{
						var nextCuePoint:CuePointVO;
						var cuePoint:CuePointVO = _firstCuePoint;

						while (cuePoint) 
						{
							nextCuePoint = cuePoint.next;

							if ( _time < cuePoint.time && cuePoint.time <= _ns.time )
							{
								dispatchEvent( new CuePointEvent ( CuePointEvent.CUE_POINT, cuePoint ) );
							}

							cuePoint = nextCuePoint;
						}
					}
				
					_time = _ns.time;
					
					if ( _playTimeUpdateListener )
					{
						var e:Event = new Event(NetConstants.NETSTREAM_PLAY_TIME_UPDATE);
						dispatchEvent(e);
					}
				}
			}
			
			if (_bytesLoaded != _ns.bytesLoaded)
			{
				_bytesLoaded = _ns.bytesLoaded;
				var loadingEvent:Event = new Event(NetConstants.NETSTREAM_LOADING);
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
		
		public function destroy ():void
		{
			_ns.pause();
			
			_netConnection.removeEventListener ( NetStatusEvent.NET_STATUS, onNetStatus );
			_netConnection.removeEventListener ( SecurityErrorEvent.SECURITY_ERROR, onSecurityError );
			
			_ns.removeEventListener ( AsyncErrorEvent.ASYNC_ERROR, onAsyncError );
			_ns.removeEventListener ( NetStatusEvent.NET_STATUS, onNetStatus );
			_ns.removeEventListener ( CuePointEvent.CUE_POINT, onCuePoint );
			_ns.removeEventListener ( MetaDataEvent.META_DATA, onMetaData );
			_ns.removeEventListener ( PlayStatusEvent.COMPLETE, onPlayComplete );
			
			_ns.removeEventListener ( AsyncErrorEvent.ASYNC_ERROR, onClonableEvent);
			_ns.removeEventListener ( NetStatusEvent.NET_STATUS, onClonableEvent);
			_ns.removeEventListener ( StatusEvent.STATUS, onClonableEvent );
			_ns.removeEventListener ( IOErrorEvent.IO_ERROR, onClonableEvent );
			
			
			_ns.removeEventListener ( DRMContentEvent.DRM_CONTENT, onClonableEvent );
			_ns.removeEventListener ( CuePointEvent.CUE_POINT, onClonableEvent );
			_ns.removeEventListener ( ImageDataEvent.IMAGE_DATA, onClonableEvent );
			_ns.removeEventListener ( MetaDataEvent.META_DATA, onClonableEvent);
			_ns.removeEventListener ( PlayStatusEvent.COMPLETE, onClonableEvent);
			_ns.removeEventListener ( SeekPointEvent.SEEK_POINT, onClonableEvent);
			_ns.removeEventListener ( TextDataEvent.TEXT_DATA, onClonableEvent );
			_ns.removeEventListener ( XMPEvent.XMP, onClonableEvent );
			
			
			this.removeEventListener ( Event.ENTER_FRAME, onEnterFrame );
			_netConnection.close ();
			
			for (var s:String in this)
			{
				try
				{
					this[s] = null;
				}
				catch (e:Error) {}
			}
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
			if (_isDestroying == false)
			{
				// avoid close loops in certain situations
				_isDestroying = true;
				destroy();
			}
		}
		
		public function onFCSubscribe(info:Object):void
		{
			_log.info ('onFCSubscribe - Remote Called');
			// We should now be subscribed to the stream.
			switch (info['code']) {
				case NetConstants.NETSTREAM_PLAY_START:
					// FMS is creating the stream. Connect now
					connectStream();
					break;
			}
		}
	}
}

