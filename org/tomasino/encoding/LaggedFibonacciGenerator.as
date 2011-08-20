package org.tomasino.encoding
{
	public class LaggedFibonacciGenerator
	{
		public static function generate (source:Array, length:int):Array
		{
			var returnArray = source.concat();
			
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
					var num1:int = returnArray[fibIndex] as int;
					var num2:int = returnArray[fibIndex+1] as int;
					var appendNum:int = (num1 + num2) % 10;
					
					returnArray.push (appendNum);
					
					fibIndex++;
				}
			}
			
			return returnArray;
		}
		
		public static function generateFromInt ( source:int, length:int ):Array
		{
			var returnArray:Array = convertIntToArr (source);
			return generate (returnArray, length);
		}
		
		private static function convertIntToArr ( source:int ):Array
		{
			// convert integer into an array
			var returnArray:Array = String(source).split('');
			
			// Make sure each element is still an int
			for (var i:int = 0; i < returnArray.length; ++i)
			{
				returnArray[i] = int(returnArray[i]);
			}
			
			return returnArray;
		}
	}
}