package org.tomasino.tracking.types
{
	import org.tomasino.tracking.TrackingData;
	import org.tomasino.tracking.omniture.OmnitureWrapper;

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
		
		public function configure (newChannel:String, newXmlPath:String, newOmniPath:String):void
		{
			OmnitureWrapper.configure(newChannel, newXmlPath, newOmniPath);
		}	
	}
}
