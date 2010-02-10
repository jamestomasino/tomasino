package com.tomasino.tracking.types
{
	import com.tomasino.tracking.spotlight.Spotlight;
	import com.tomasino.tracking.TrackingData;

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
		
		public function set debug(val:Boolean):void
		{
			Spotlight.debug = val;
		}
		
		public function get debug():Boolean
		{
			return Spotlight.debug;
		}
		
	}
}
