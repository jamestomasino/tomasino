﻿package org.tomasino.external
{
	import flash.external.ExternalInterface;
	import flash.system.Capabilities;
	
	/**
	 * Utility class tests for the availability of ExternalInterface in the current swf
	 * by thoroughly testing environment issues that are overlooked by ExternalInterface.available.
	 *  
	 * @author tomasino
	 * 
	 */
	public class Availability
	{
		private static var _availability:Boolean;
		
		/**
		 * Automatically tests for the availability of ExternalInterface 
		 * @return Availability of ExternalInterface
		 * 
		 */
		private static function init():Boolean
		{
			// Only test if we haven't found availability yet. (Should only run once anyway)
			if (!_availability)
			{
				
				// First test if we're in the Flash or Flex IDE. If so, no ExternalInterface, despite what it claims.
				if (Capabilities.playerType == "External")
					return false;
					
				try
				{
					// Next test the regular availability property
					_availability = ExternalInterface.available;
					
					//Regardless of result, try to add a callback. If not in a valid browser, this will throw an error.
					ExternalInterface.addCallback( 'org_tomasino_external_Availability_test', function():Boolean {return true} );
				}
				catch (e:Error)
				{
					// Any error, no External Interface
					_availability = false;
				}
			}
			
			// All tests succeed, ExternalInterface is indeed available.
			return true;
		}
		private static var _initializer:Boolean = init();
		
		
		/**
		 * Getter for availability of ExternalInterface 
		 * @return 
		 * 
		 */
		public static function get available ():Boolean
		{
			return _availability;
		}
	}
}
