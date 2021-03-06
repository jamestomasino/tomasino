﻿package org.tomasino.tracking.types
{
	import org.tomasino.tracking.spotlight.Spotlight;
	import org.tomasino.tracking.TrackingData;

	public class SpotlightType implements ITrackingType
	{
		public function SpotlightType()
		{
		}

		public function track(t:TrackingData):void
		{
			if (t.spotlightURL)
			{
				Spotlight.Track(t.spotlightURL);	
			}
		}
	}
}
