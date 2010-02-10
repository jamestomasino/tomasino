package com.tomasino.external
{
	import flash.external.ExternalInterface;
	import com.tomasino.external.Availability;
	
	public class QueryString
	{
		private static var qParams:Object;
		
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