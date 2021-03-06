﻿package org.tomasino.utils
{
	public class DateRangeTest
	{
		public static const TODAY:Date = new Date();
		private var _ranges:Array;

		public function DateRangeTest ():void
		{
			_ranges = new Array();
		}
		public function AddRange (startDate:Date, endDate:Date, returnVal:Object):void
		{
			_ranges.push ({startDate:startDate, endDate:endDate, returnVal:returnVal});
		}
		public function Test (d:Date = null):Object
		{
			if (d == null) d = TODAY;
			for (var i:int = 0; i < _ranges.length; ++i)
			{
				if ((d >= _ranges[i].startDate) && (d <= _ranges[i].endDate))
				{
					return _ranges[i].returnVal;
				}
			}
			return false;
		}
	}
}
