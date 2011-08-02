package org.tomasino.encoding
{
	public class SequentialSubstitution
	{
		public static function substitute ( source:Array, caseSensitive:Boolean = false ):Array
		{
			var localSource:Array = source.concat();
			var sortArray:Array = new Array();
			/* If Array.RETURNINDEXEDARRAY wasn't broken, this class would be 3 lines long! :) */
			
			for (var i:int = 0; i < localSource.length; ++i)
			{
				sortArray.push ( {data:localSource[i], index:i} );
			}
			
			sortArray.sortOn ('data');
			
			var indexes:Array = new Array();
			
			for (i = 0; i < sortArray.length; ++i)
			{
				indexes.push (sortArray[i].index);
			}
			
			return indexes;
		}
	}
}