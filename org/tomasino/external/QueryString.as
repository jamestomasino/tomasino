﻿package org.tomasino.external
{
	import flash.external.ExternalInterface;
	import org.tomasino.external.Availability;
	
	/**
	 * Gets any query string parameters in the URL string and stores them in name/value pairs.
	 *  
	 * @author tomasino
	 * 
	 */
	public class QueryString
	{
		private static var qParams:Object;
		
		/**
		 * Gets query string paremeters from document URL using JavaScript. If ExternalInterface is unavailable or
		 * there are no query parameters, returned object will be empty.
		 *  
		 * @return Object of name/value pairs for each parameter in query string of current URL 
		 * 
		 */
		public static function get params():Object
		{
			if (!qParams)
			{
				qParams = new Object();
				if(Availability.available)
				{
					var qString:String = String(ExternalInterface.call("window.location.search.toString")).substring(1);
					var qNameValues:Array = qString.split("&");
					for(var i:int=0; i<qNameValues.length; i++)
					{
						var a:Array = String(qNameValues[i]).split("=");
						qParams[a[0]] = a[1];
					}
				}
			}
			return qParams;
		}
	}
}