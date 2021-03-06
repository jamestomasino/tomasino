﻿package org.tomasino.tracking.hbx
{
	import flash.events.EventDispatcher;
	import flash.events.Event;
	
	import flash.utils.setInterval;
	import flash.utils.clearInterval;
	
	public class HBXTrackDelayed extends EventDispatcher
	{
		public static var EVENT_DELAY_COMPLETE:String = 'EVENT_DELAY_COMPLETE';
		private static var MIN_DELAY:Number = 0;
		
		private var _intDelay:int;
		private var _intIntervalID:int;
		private var _objTrackObject:HBXTrackObject;
		
		public function HBXTrackDelayed(oTrackObj:HBXTrackObject, iDelay:int)
		{
			_intDelay = (iDelay < MIN_DELAY) ? MIN_DELAY : iDelay;
			_objTrackObject = oTrackObj.clone();
		}
		
		public function Start():void
		{
			if(_intDelay > 0)
			{
				_intIntervalID = setInterval(HandleInterval, _intDelay);
			}
			else
			{
				HandleInterval();
			}
		}
		
		public function Cancel():void
		{
			if(_intIntervalID)
			{
				clearInterval(_intIntervalID);
			}
			_intIntervalID = undefined;
		}
		
		private function HandleInterval():void
		{
			clearInterval(_intIntervalID);
			_intIntervalID = undefined;
			dispatchEvent(new HBXEventDelayComplete(_objTrackObject.clone()));
			delete this;
		}
	}
}
