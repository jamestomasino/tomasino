package com.tomasino.external
{
	import flash.external.ExternalInterface;
	
	public class Availability
	{
		private static var _availability:Boolean;
		
		private static function init():Boolean
		{
			try
			{
				_availability = ExternalInterface.available;
				ExternalInterface.addCallback('test', function():Boolean {return true});
			}
			catch (e:Error)
			{
				_availability = false;
			}
			return true;
		}
		private static var _initializer:Boolean = init();
		
		public static function get available ():Boolean
		{
			return _availability;
		}
	}
}
