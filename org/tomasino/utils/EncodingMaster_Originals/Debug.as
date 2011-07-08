package org.tomasino.utils
{
	import flash.system.Capabilities;
	
	public class Debug
	{
		public static var enabled:Boolean = true;
		public static var headersEnabled:Boolean = true;
		public static var headersOnly:Boolean = false;
		private static var flashIDEErrorStyle:Boolean = false;
		
		private static function init():Boolean
		{
			if (Capabilities.playerType == "External") flashIDEErrorStyle = true;
			return true;
		}
		private static var _initializer:Boolean = init();
		
		public static function out(...msg):void
		{
			if (enabled)
			{
				var t:String = '';
				if (headersEnabled)
				{
					
					/* Hack: Since AS3 has no arugments.caller method, we have to use the stack trace from a dummy error */
					var error:Error = new Error();
					var caller:String = error.getStackTrace().split('\n')[2];
					var className:String;
					var callerArr:Array;
					
					/* the Flash IDE has a different Error syntax than the plugin */
					if (flashIDEErrorStyle)
					{
						callerArr = caller.split(' ').pop().split('/')
						className = '['+callerArr.shift()+']';
						var methodName:String = callerArr.shift();
						t += className + '::' + methodName;
					}
					else
					{
						callerArr = caller.split('/').pop().split(':')
						className = '['+callerArr.shift()+']';
						var lineNum:String = '(' + callerArr.shift().substr(0,-1) + ')';
						t += className + ' ' + lineNum;
					}
				}
				
				if (!headersOnly)
				{
					t += (headersEnabled) ? '\n\t' : '';
					t += msg.join(' ');
				}
				
				if (t) trace (t);		
			}
		}
	}
}