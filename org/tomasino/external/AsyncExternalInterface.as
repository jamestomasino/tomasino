package org.tomasino.external
{
	import flash.external.ExternalInterface;
	import flash.system.Capabilities;

	public class AsyncExternalInterface
	{
		private static var _isExternalInterfaceAvailable:Boolean;
		private static var _isCallStackAvailable:Boolean;

		private static function testExternalInterface():Boolean
		{
			if (!_isExternalInterfaceAvailable)
			{
				if (Capabilities.playerType == "External")
					return false;

				try
				{
					_isExternalInterfaceAvailable = ExternalInterface.available;
					ExternalInterface.addCallback( 'org_tomasino_external_AsyncExnternalInterface_isExternalInterfaceAvailable_test', function():Boolean {return true} );
				}
				catch (e:Error)
				{
					_isExternalInterfaceAvailable = false;
				}
			}
			return true;
		}
		private static var _initExternalInterface:Boolean = testExternalInterface();

		private static function testCallStack():Boolean
		{
			if (_isExternalInterfaceAvailable)
			{
				_isCallStackAvailable = true;
				try
				{
					// Test if CallStack class exists
					ExternalInterface.call( 'CallStack.getInst();');
				}
				catch (e:Error)
				{
					_isCallStackAvailable = false;
				}
			}
			else
			{
				_isCallStackAvailable = false;
			}
			return true;
		}
		private static var _initCallStack:Boolean = testCallStack();

		public static function get available ():Boolean { return _isExternalInterfaceAvailable; }

		public static function call ( functionName:String, ...rest ):void
		{
			if (_isExternalInterfaceAvailable)
			{
                if (_isCallStackAvailable)
				{
					ExternalInterface.call ( 'CallStack.getInst().addCall', functionName, rest);
				}
				else
				{
					var params:Array = rest.unshift(functionName);
					ExternalInterface.call.apply( null, params );
				}
			}
			else
			{
				// Do nothing. No external Interface
			}
		}
	}
}
