﻿package org.tomasino.utils 
{
	import flash.utils.Timer;

	public dynamic class DynamicTimer extends Timer
	{
		public function DynamicTimer (delay:Number, repeatCount:int = 0):void
		{
			super (delay, repeatCount);
		}
	}
}
