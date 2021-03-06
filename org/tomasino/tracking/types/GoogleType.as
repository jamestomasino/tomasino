﻿package org.tomasino.tracking.types
{
	import org.tomasino.tracking.google.GoogleAnalytics;
	import org.tomasino.tracking.TrackingData;
	
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
	}
}
