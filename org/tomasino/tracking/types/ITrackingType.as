﻿package org.tomasino.tracking.types
{
	import org.tomasino.tracking.TrackingData;
	
	public interface ITrackingType
	{
		function track (t:TrackingData):void;
	}
}
