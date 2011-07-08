package org.tomasino.utils 
{
	public class Range
	{
		public function Range (){}
		
		
		public static function getRange(start:int, endO:Object = null, interval:int = 1):Array
		{
			var returnArr:Array = new Array();
			var end:int;
			if (endO == null)
			{
				end = start;
				start = 0;
			}
			else
			{
				end = int(endO);
			}
			
			var i:int;
			if (interval > 0)
			{
				if (start < end)
				{
					// valid
					for (i = start; i < end; i += interval)
					{
						returnArr.push(i);
					}
				}
			} 
			else if (interval < 0)
			{
				if (end < start)
				{
					// valid
					for (i = start; i > end; i += interval)
					{
						returnArr.push(i);
					}
				}
			}
			return returnArr;
		}

		/**
		 * Converts numbers from one range to another range.
		 * 
		 * @param origRange1 Start bounds of original range
		 * @param origRange2 End bounds of original range
		 * @param newRange1 Start bounds of new range
		 * @param newRange2 End bounds of new range
		 * @param index Value to convert
		 * @return Converted value
		 * 
		 */
		public static function convert (origRange1:Number, origRange2:Number, newRange1:Number, newRange2:Number, index:Number):Number
		{
			var ratio:Number;
			var delta:Number = (origRange1 - origRange2);
			var leftBound:Number = origRange1 / delta;
			var rightBound:Number = origRange2 / delta;
			var iBound:Number = index / delta;
			
			if (leftBound < rightBound)
			{
				ratio = iBound - leftBound;
			}
			else
			{
				ratio = (iBound - leftBound) * -1;
			}
									
			var returnNum:Number = (ratio * (newRange2 - newRange1)) + newRange1;
			return returnNum;
		}
		
	}
}
