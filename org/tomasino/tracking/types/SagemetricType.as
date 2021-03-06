﻿package org.tomasino.tracking.types
{
	import org.tomasino.tracking.sagemetrics.SagemetricManager;
	import org.tomasino.tracking.TrackingData;
	
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
		
		public function set baseURL (val:String):void
		{
			SagemetricManager.baseURL = val;
		}
	}
}
