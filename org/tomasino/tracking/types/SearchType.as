package org.tomasino.tracking.types
{
	import org.tomasino.tracking.search.SearchTracking;
	import org.tomasino.tracking.TrackingData;

	public class SearchType implements ITrackingType
	{
		public function SearchType()
		{
		}

		public function track(t:TrackingData):void
		{
			if ((t.searchVars) && (t.searchIDC) && (t.searchLead))
			{
				SearchTracking.TrackClick(t.searchVars, t.searchIDC, t.searchLead);
			
			}
			
		}
	}
}
