package com.tomasino.tracking.types
{
	import com.tomasino.tracking.TrackingData;
	
	public interface ITrackingType
	{
		function track (t:TrackingData):void;
		function set debug (val:Boolean):void;
		function get debug ():Boolean;
	}
}
