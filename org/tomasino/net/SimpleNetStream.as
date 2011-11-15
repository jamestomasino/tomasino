package org.tomasino.net
{
	import org.tomasino.net.events.CuePointEvent;
	import org.tomasino.net.events.DRMContentEvent;
	import org.tomasino.net.events.ImageDataEvent;
	import org.tomasino.net.events.MetaDataEvent;
	import org.tomasino.net.events.PlayStatusEvent;
	import org.tomasino.net.events.SeekPointEvent;
	import org.tomasino.net.events.TextDataEvent;
	import org.tomasino.net.events.XMPEvent;
	import org.tomasino.net.vo.CuePointVO;
	import org.tomasino.net.vo.NetConstants;
	
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.utils.ByteArray;
	
	public class SimpleNetStream extends NetStream
	{
		private var _isMetaDataFired:Boolean = false;
		private var _isPauseQueued:Boolean = false;
		private var _metaData:Object;

		public function SimpleNetStream(connection:NetConnection, peerID:String="connectToFMS")
		{
			super(connection, peerID);
			this.client = this;
		}
		
		public function onCuePoint ( cueInfoObj:Object ):void
		{
			var cuePoint:CuePointVO = new CuePointVO();
			cuePoint.time = cueInfoObj['time'];
			cuePoint.name = cueInfoObj['name'];
			cuePoint.type = cueInfoObj['type'];
			cuePoint.parameters = cueInfoObj['parameters'];
			
			var cuePointEvent:CuePointEvent = new CuePointEvent ( CuePointEvent.CUE_POINT, cuePoint );
			dispatchEvent( cuePointEvent );
		}
		
		public function onImageData ( imageData:Object ):void
		{
			var imageByteArray:ByteArray = imageData as ByteArray;
			var imageDataEvent:ImageDataEvent = new ImageDataEvent ( ImageDataEvent.IMAGE_DATA, imageByteArray );
			dispatchEvent( imageDataEvent );
		}
		
		// Handle dispatching metadata events and handle bug with pause() called before metadata
		public function onMetaData ( metaData:Object ):void
		{
			_metaData = metaData;

			_isMetaDataFired = true;

			if (_isPauseQueued)
			{
				_isPauseQueued = false;
				seek (0);
				super.pause();
			}
			
			var metaDataEvent:MetaDataEvent = new MetaDataEvent ( MetaDataEvent.META_DATA, metaData );
			dispatchEvent( metaDataEvent );
		}
		
		public function get metaData ():Object
		{
			return _metaData;
		}

		override public function pause ():void
		{
			if (_isMetaDataFired) super.pause();
			else
			{
				_isPauseQueued = true;
			}
		}

		override public function togglePause ():void
		{
			if (_isMetaDataFired) super.togglePause();
			else
			{
				_isPauseQueued = !_isPauseQueued;
			}
		}

		override public function resume ():void
		{
			if (_isMetaDataFired) super.resume();
			else
			{
				_isPauseQueued = false;
			}
		}

		public function onPlayStatus ( playStatus:Object ):void
		{
			var code:String = playStatus['info']['code'] as String;
			switch (code)
			{
				case NetConstants.NETSTREAM_PLAY_COMPLETE:
					dispatchEvent( new PlayStatusEvent ( PlayStatusEvent.COMPLETE ) );
					break;
				case NetConstants.NETSTREAM_PLAY_SWITCH:
					dispatchEvent( new PlayStatusEvent ( PlayStatusEvent.SWITCH ) );
					break;
				case NetConstants.NETSTREAM_PLAY_TRANSITION_COMPLETE:
					dispatchEvent( new PlayStatusEvent ( PlayStatusEvent.TRANSITION_COMPLETE ) );
					break;
				default:
					break
			}
		}
		
		public function onSeekPoint ( seekObject:Object ):void
		{
			var seekPointEvent:SeekPointEvent = new SeekPointEvent ( SeekPointEvent.SEEK_POINT, seekObject );
			dispatchEvent( seekPointEvent );
		}
		
		public function onTextData ( textData:Object ):void
		{
			var textDataEvent:TextDataEvent = new TextDataEvent ( TextDataEvent.TEXT_DATA, textData );
			dispatchEvent( textDataEvent );
		}
		
		public function onXMPData ( xmpData:Object ):void
		{
			var UUID:String = xmpData['data'] as String;
			var xmpEvent:XMPEvent = new XMPEvent ( XMPEvent.XMP, UUID );
			dispatchEvent( xmpEvent );
		}
		
		/* AIR Only */
		public function onDRMContentData ( drmData:Object ):void
		{
			// drmData is a DRMContentData object.
			// Unfortunately, unless we're in AIR, we can't type it.
			// So instead we'll have to pass it along as a basic object.
			var drmContentEvent:DRMContentEvent = new DRMContentEvent (DRMContentEvent.DRM_CONTENT, drmData );
			dispatchEvent( drmContentEvent );
		}
		
		/* Undocumented public callbacks from FMS */
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
		}

	}
}
