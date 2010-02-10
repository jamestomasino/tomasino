package com.tomasino.tracking.types
{
	import com.tomasino.tracking.search.SearchTracking;
	import com.tomasino.tracking.TrackingData;

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
		
		public function set debug(val:Boolean):void
		{
			SearchTracking.debug = val;
		}
		
		public function get debug():Boolean
		{
			return SearchTracking.debug;
		}
		
	}
}
