package org.tomasino.encoding
{
	public class LaggedFibonacciGenerator
	{
		public static function generate (source:Array, length:int):Array
		{
			var returnArray:Array = source.concat();
			
			if (length <= returnArray.length)
			{
				returnArray = returnArray.slice (0, length);
			}
			else
			{
				var startingSize:int = returnArray.length;
				var fibIndex:int = 0;
				for (var i:int = startingSize; i < length; ++i)
				{
					var appendNum:int = (returnArray[fibIndex] + returnArray[fibIndex+1]) % 10;
					returnArray.push (appendNum);
					fibIndex++;
				}
			}
			
			return returnArray;
		}
	}
}