package com.tomasino.tracking.types
{
	import com.tomasino.tracking.google.GoogleAnalytics;
	import com.tomasino.tracking.TrackingData;
	
	public class GoogleType implements ITrackingType
	{
		public function GoogleType()
		{
		}

		public function track(t:TrackingData):void
		{
			if ((t.googleCategory) && (t.googleClickName))
			{
				GoogleAnalytics.TrackClick(t.googleCategory, t.googleClickName);
			}
			if ((t.googleCategory) && (t.googleRollOverName))
			{
				GoogleAnalytics.TrackRollOver(t.googleCategory, t.googleRollOverName);
			}
			if (t.googlePageName)
			{
				GoogleAnalytics.TrackPageView(t.googlePageName);
			}
		}
		
		public function set debug (val:Boolean):void
		{
			GoogleAnalytics.debug = val;
		}
		public function get debug ():Boolean
		{
			return GoogleAnalytics.debug;
		}
	}
}
