package com.tomasino.logging
{
	import flash.events.StatusEvent;
	import flash.net.LocalConnection;

	public class LogBookConsole implements IConsole{

		public static const LOGGING_METHOD:String = "logMessage";
		private var _lc:LocalConnection;
		private var _connection:String;
		
		public function LogBookConsole(connectionId:String)
		{
			_lc = new LocalConnection();
			_lc.addEventListener(StatusEvent.STATUS, statusEventHandler);
			_connection = connectionId;
		}

		private function statusEventHandler(event:StatusEvent):void
		{
			//trace("statusEventHandler: " + event.code);
		}

		public function log(category:String, level:Number, msg:String):void{
			
			var d:Date = new Date();

			try {
				_lc.send(_connection, LOGGING_METHOD, d, category, level, msg);
			} catch(error:Error) {
				trace('ERROR - Cannot sconnect to local connection');
			}
		}
		
		public function toString():String
		{
			return "LocalConnectionTarget[" + _connection + "]";
		}

		public function getConnectionId():String {
			return _connection;
		}
	}
}