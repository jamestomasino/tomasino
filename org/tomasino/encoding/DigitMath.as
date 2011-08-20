package org.tomasino.encoding
{
	public class DigitMath
	{
		public static function sum (a1:Array, a2:Array):Array
		{
			if (a1.length != a2.length)
			{
				fixSize(a1, a2);
			}
			
			var returnArr:Array = new Array();
			var totalLength:int = a1.length;
			for (var i:int = 0; i < totalLength; ++i)
			{
				var newVal:int = (int(a1[i]) + int(a2[i])) % 10;
				returnArr.push( newVal );
			}
			
			return returnArr;
		}
		
		public static function subtract (a1:Array, a2:Array):Array
		{
			if (a1.length != a2.length)
			{
				fixSize(a1, a2);
			}
			
			var returnArr:Array = new Array();
			var totalLength:int = a1.length;
			for (var i:int = 0; i < totalLength; ++i)
			{
				var newVal:int = (int(a1[i]) - int(a2[i])) % 10;
				if (newVal < 0) newVal += 10;
				returnArr.push( newVal );
			}
			
			return returnArr;
		}
		
		private static function fixSize (a1:Array, a2:Array):void
		{
			if (a1.length < a2.length)
			{
				for (var i:int = a1.length; i < a2.length; ++i)
				{
					a1.unshift(0);
				}
			}
			else
			{
				for (i = a2.length; i < a1.length; ++i)
				{
					a2.unshift(0);
				}
			}
			
			return;
		}
	}
}