package com.tomasino.tracking.types
{
	import com.tomasino.tracking.TrackingData;
	import com.tomasino.tracking.omniture.OmnitureWrapper;

	public class OmnitureType implements ITrackingType
	{
		public function OmnitureType()
		{
			
		}

		public function track(t:TrackingData):void
		{
			if ((t.omnitureLinkUrl) && (t.omnitureLinkName) && (t.omnitureEVars) && (t.omnitureEvents))
			{
				OmnitureWrapper.trackClick (t.omnitureLinkUrl, t.omnitureLinkName, t.omnitureEVars, t.omnitureEvents);
			}
		}
		
		public function set debug(val:Boolean):void
		{
			OmnitureWrapper.debug = val;
		}
		
		public function get debug():Boolean
		{
			return OmnitureWrapper.debug;
		}
		
		public function configure (newChannel:String, newXmlPath:String, newOmniPath:String):void
		{
			OmnitureWrapper.configure(newChannel, newXmlPath, newOmniPath);
		}	
	}
}
