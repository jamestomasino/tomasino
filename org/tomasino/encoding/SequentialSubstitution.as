package org.tomasino.encoding
{
	public class SequentialSubstitution
	{
		public static function substitute ( source:Array, mod10:Boolean = true ):Array
		{
			var lookupArr:Array = source.concat();
			var sortArr:Array = source.concat();
			sortArr = sortArr.sort();
			
			
			var index:int = 0;
			var returnArray:Array = new Array();
			
			while (index < sortArr.length)
			{
				var item:Object = sortArr[index];
				var itemIndex:int = lookupArr.indexOf(item);
				lookupArr[itemIndex] = null; // clear found item in case of duplicates
				
				var placeValue:int = index + 1;
				if (mod10) placeValue %= 10;
				returnArray[itemIndex] = placeValue; // Sequential Substitutions count from 1
				++index;
			}
			
			return returnArray;
		}
		
		public static function substituteIntegers ( source:Array, mod10:Boolean = true ):Array
		{
			var copyArray:Array = source.concat();
			for (var i:int = 0; i < copyArray.length; ++i)
			{
				if (int(copyArray[i]) == 0) 
				{
					copyArray[i] = 10;
				}
				else if (int(copyArray[i] < 10))
				{
					copyArray[i] = '0' + copyArray[i];
				}
			}

			return substitute (copyArray, mod10);
		}
	}
}