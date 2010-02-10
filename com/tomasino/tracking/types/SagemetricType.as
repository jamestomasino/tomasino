package com.tomasino.tracking.types
{
	import com.tomasino.tracking.sagemetrics.SagemetricManager;
	import com.tomasino.tracking.TrackingData;
	
	public class SagemetricType implements ITrackingType
	{
		public function SagemetricType()
		{
		}
		
		public function track(t:TrackingData):void
		{
			if ((t.sageType) && (t.sageCategory))
			{
				SagemetricManager.track(t.sageType, t.sageCategory);
			}
		}
		
		public function set debug (val:Boolean):void
		{
			SagemetricManager.debug = val;
		}
		
		public function get debug ():Boolean
		{
			return SagemetricManager.debug;
		}
		
		public function set baseURL (val:String):void
		{
			SagemetricManager.baseURL = val;
		}
	}
}
