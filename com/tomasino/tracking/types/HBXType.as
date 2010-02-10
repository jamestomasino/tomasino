package com.tomasino.tracking.types
{
	import com.tomasino.tracking.TrackingData;
	import com.tomasino.tracking.hbx.HBX;

	public class HBXType implements ITrackingType
	{
		private var _mlc:String;
		
		public function HBXType()
		{
		}

		public function track(t:TrackingData):void
		{
			if (t.hbxClickName)
			{
				HBX.TrackClick(t.hbxClickName);
			}
			if (t.hbxRollOverName)
			{
				HBX.TrackRollover(t.hbxRollOverName, 500);
			}
			if ((t.hbxPageName) && (_mlc))
			{
				HBX.TrackPageview(_mlc,t.hbxPageName);
			}
		}
		
		public function set debug(val:Boolean):void
		{
			HBX.debug = val;
		}
		
		public function get debug():Boolean
		{
			return HBX.debug;
		}
		
		public function set mlc (val:String):void
		{
			_mlc = val;
		}
	}
}
