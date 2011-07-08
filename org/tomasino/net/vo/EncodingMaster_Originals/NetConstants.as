package org.tomasino.net.vo
{
	public class NetConstants
	{
		public static const NETSTREAM_PLAY_SWITCH:String = 'NetStream.Play.Switch';
		public static const NETSTREAM_PLAY_COMPLETE:String = 'NetStream.Play.Complete';
		public static const NETSTREAM_PLAY_TRANSITION_COMPLETE:String = 'NetStream.Play.TransitionComplete';
		
		public static const NETSTREAM_BUFFER_EMPTY:String = 'NetStream.Buffer.Empty';
		public static const NETSTREAM_BUFFER_FULL:String = 'NetStream.Buffer.Full';
		public static const NETSTREAM_BUFFER_FLUSH:String = 'NetStream.Buffer.Flush';
		
		public static const NETSTREAM_FAILED:String = 'NetStream.Failed';
		
		public static const NETSTREAM_PUBLISH_START:String = 'NetStream.Publish.Start';
		public static const NETSTREAM_PUBLISH_BADNAME:String = 'NetStream.Publish.BadName';
		public static const NETSTREAM_PUBLISH_IDLE:String = 'NetStream.Publish.Idle';
		public static const NETSTREAM_UNPUBLISH_SUCCESS:String = 'NetStream.Unpublish.Success';
		
		public static const NETSTREAM_PLAY_START:String = 'NetStream.Play.Start';
		public static const NETSTREAM_PLAY_STOP:String = 'NetStream.Play.Stop';
		public static const NETSTREAM_PLAY_FAILED:String = 'NetStream.Play.Failed';
		public static const NETSTREAM_PLAY_STREAM_NOT_FOUND:String = 'NetStream.Play.StreamNotFound';
		public static const NETSTREAM_PLAY_RESET:String = 'NetStream.Play.Reset';
		public static const NETSTREAM_PLAY_PUBLISH_NOTIFY:String = 'NetStream.Play.PublishNotify';
		public static const NETSTREAM_PLAY_UNPUBLISH_NOTIFY:String = 'NetStream.Play.UnpublishNotify';
		public static const NETSTREAM_PLAY_INSUFFICIENT_BW:String = 'NetStream.Play.InsufficientBW';
		public static const NETSTREAM_PLAY_FILE_STRUCTURE_INVALID:String = 'NetStream.Play.FileStructureInvalid';
		public static const NETSTREAM_PLAY_NO_SUPPORTED_TRACK_FOUND:String = 'NetStream.Play.NoSupportedTrackFound';
		
		public static const NETSTREAM_PAUSE_NOTIFY:String = 'NetStream.Pause.Notify';
		public static const NETSTREAM_UNPAUSE_NOTIFY:String = 'NetStream.Unpause.Notify';
		
		public static const NETSTREAM_RECORD_START:String = 'NetStream.Record.Start';
		public static const NETSTREAM_RECORD_NO_ACCESS:String = 'NetStream.Record.NoAccess';
		public static const NETSTREAM_RECORD_STOP:String = 'NetStream.Record.Stop';
		public static const NETSTREAM_RECORD_FAILED:String = 'NetStream.Record.Failed';
		public static const NETSTREAM_SEEK_FAILED:String = 'NetStream.Seek.Failed';
		public static const NETSTREAM_SEEK_INVALID_TIME:String = 'NetStream.Seek.InvalidTime';
		public static const NETSTREAM_SEEK_NOTIFY:String = 'NetStream.Seek.Notify';
		
		public static const NETCONNECTION_CALL_BAD_VERSION:String = 'NetConnection.Call.BadVersion';
		public static const NETCONNECTION_CALL_FAILED:String = 'NetConnection.Call.Failed';
		public static const NETCONNECTION_CALL_PROHIBITED:String = 'NetConnection.Call.Prohibited';
		
		public static const NETCONNECTION_CONNECT_SUCCESS:String = 'NetConnection.Connect.Success';
		public static const NETCONNECTION_CONNECT_FAILED:String = 'NetConnection.Connect.Failed';
		public static const NETCONNECTION_CONNECT_CLOSED:String = 'NetConnection.Connect.Closed';
		public static const NETCONNECTION_CONNECT_REJECTED:String = 'NetConnection.Connect.Rejected';
		public static const NETCONNECTION_CONNECT_APP_SHUTDOWN:String = 'NetConnection.Connect.AppShutdown';
		public static const NETCONNECTION_CONNECT_INVALID_APP:String = 'NetConnection.Connect.InvalidApp';
		
		public static const SHAREDOBJECT_FLUSH_SUCCESS:String = 'SharedObject.Flush.Success';
		public static const SHAREDOBJECT_FLUSH_FAILED:String = 'SharedObject.Flush.Failed';
		public static const SHAREDOBJECT_BAD_PERSISTENCE:String = 'SharedObject.BadPersistence';
		public static const SHAREDOBJECT_URI_MISMATCH:String = 'SharedObject.UriMismatch';
	}
}