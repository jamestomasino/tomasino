﻿package org.tomasino.encoding
{
	import flash.geom.Point;
	
	public class Transposition
	{
		public static function simpleColumn (source:Array, columns:Array):Array
		{
			
			var columnsLength:int = columns.length;
			var sourceLength:int = source.length;
			var rows:int = Math.ceil( sourceLength / columnsLength );
			
			var matrix:Array = new Array();
			
			// Make sure everything is strings, add padding for single digits
			for (var i:int = 0; i < columnsLength; ++i)
			{
				columns[i] = (columns[i] < 10) ? '0' + String(columns[i]) : String(columns[i]);
			}
			
			for (i = 0; i < rows; ++i)
			{
				var startIndex:int = i * columnsLength;
				if (i == rows - 1) // last row
				{
					matrix.push ( source.slice (startIndex, sourceLength) );
				}
				else
				{
					
					matrix.push ( source.slice (startIndex, startIndex + columnsLength ) );
				}
			}
			
			return flattenByColumns (matrix, columns);
		}
		
		
		public static function unSimpleColumn (source:Array, columns:Array):Array
		{
			numToStrArr (columns);
			var matrix:Array = unflattenToColumns( source, columns );
			
			var returnArr:Array = new Array();
			
			for (var i:int = 0; i < matrix.length; ++i)
			{
				returnArr = returnArr.concat( matrix[i] );
			}
			
			return returnArr;
		}
		
		public static function disrupted (source:Array, columns:Array):Array
		{
			var pattern:Array = buildDisruptedPattern( columns, source.length );
			
			numToStrArr (columns);
			
			// Build placeholder matrix
			var matrix:Array = new Array();
			for (var i:int = 0; i < Math.ceil(source.length / columns.length); ++i)
			{
				matrix[i] = new Array();
			}
			
			// Assign everything to matrix in perfect position
			for (i = 0; i < pattern.length; ++i)
			{
				var p:Point = pattern[i] as Point;
				matrix[p.y][p.x] = source[i];
			}
			
			//traceMatrixOrder (pattern, columns.length);
			
			return flattenByColumns (matrix, columns);
		}
		
		public static function undisrupted (source:Array, columns:Array):Array
		{
			var pattern:Array = buildDisruptedPattern( columns, source.length );
			
			numToStrArr (columns);
			
			var matrix:Array = unflattenToColumns( source, columns );
			
			var returnArr:Array = new Array();
			
			for (var i:int = 0; i < pattern.length; ++i)
			{
				var p:Point = pattern[i] as Point;
				returnArr.push( matrix[p.y][p.x] );
			}
			
			return returnArr;
		}
		
		private static function buildDisruptedPattern (columns:Array, sourceLen:int):Array
		{
			// Gather necessary data
			var colLen:int = columns.length;
			var lastRowLen:int = sourceLen % colLen;
			var rows:int = Math.ceil( sourceLen / colLen);
			
			var columnsSorted:Array = columns.concat().sort(Array.NUMERIC);
			var columnSortIndex:int = 0;
			var columnValue:int = columnsSorted[columnSortIndex];
			var columnNum:int = columns.indexOf(columnValue);
			
			var positions:Array = new Array();
			var totalItems:int = rows * colLen;
			positions = buildTriangle (columnNum, colLen, 0, rows, sourceLen, columns);
			
			fillMatrix (positions, rows, sourceLen, colLen);
			return positions;
		}
		
		private static function buildTriangle (startColumn:int, columnLength:int, startRow:int, rowLength:int, sourceLength:int, columns:Array):Array
		{
			//trace (startColumn, columnLength, startRow, rowLength, sourceLength );
			var positions:Array = new Array();
			var currentRow = startRow;
			var lastRowLen:int = sourceLength % columnLength;
			
			for (var columnLimit:int = startColumn; columnLimit < columnLength; ++columnLimit)
			{
				if ( currentRow == rowLength) break;
				if ( currentRow == rowLength - 1 && lastRowLen)
				{
					for (var currentColumn:int = 0; currentColumn < Math.min(lastRowLen, columnLimit); ++currentColumn)
					{
						positions.push( new Point (currentColumn, currentRow) );
					}
				}
				else
				{
					for (currentColumn = 0; currentColumn < columnLimit; ++currentColumn)
					{
						positions.push( new Point (currentColumn, currentRow) );
					}
				}
				currentRow ++;
			}
			
			if (currentRow != rowLength)
			{
				// Recursively build next part of tree
				var columnsSorted:Array = columns.concat().sort(Array.NUMERIC);
				var sortedColItem:int = columnsSorted.indexOf( columns[startColumn] );
				var columnValue:int = columnsSorted[sortedColItem + 1];
				var nextColumn:int = columns.indexOf(columnValue);
				
				var recursivePositions:Array = buildTriangle ( nextColumn, columnLength, currentRow, rowLength, sourceLength, columns);
				
				positions = positions.concat( recursivePositions );
				
			}

			return positions;
		}
		
		private static function fillMatrix (positions:Array, rowLength:int, sourceLen:int, colLen:int):void
		{		
			// Build them into a matrix so we can fill them in easily
			var lastRowLen:int = sourceLen % colLen;
			var matrix:Array = new Array();
			for (var i:int = 0; i < rowLength; ++i)
			{
				matrix[i] = new Array();
			}
		
			for (i = 0; i < positions.length; ++i)
			{
				var p:Point = positions[i] as Point;
				if (p)
				{
					matrix[p.y][p.x] = i;
				}
			}
			
			// Toss everything back into the positions array
			var fillRowLength = (lastRowLen == 0) ?  rowLength : rowLength - 1;
			for (i = 0; i < fillRowLength; ++i)
			{
				var row:Array = matrix[i] as Array;
				for (var j:int = row.length; j < colLen; ++j)
				{
					positions.push( new Point (j, i) );
				}
			}
			
			if (lastRowLen)
			{
				row = matrix[rowLength-1] as Array;
				var remainingItems:int =  lastRowLen - row.length;
				
				for (j = row.length; j < lastRowLen; ++j)
				{
					positions.push( new Point (j, rowLength-1) );
				}
			}
		
		}
		
		private static function flattenByColumns (matrix:Array, columns:Array):Array
		{
			var returnArray:Array = new Array;
			
			var columnsLength:int = columns.length;
			var rows:int = matrix.length;
			var columnsSorted:Array = columns.concat().sort();
			
			for (var i:int = 0; i < columnsLength; ++i)
			{
				var columnValue:String = columnsSorted[i] as String;
				var columnNum:int = columns.indexOf(columnValue);
				
				for (var j:int = 0; j < rows; ++j)
				{
					if (matrix[j].length > columnNum)
					{
						returnArray.push( matrix[j][columnNum] );
					}
				}
			}
			return returnArray;
		}
		
		private static function unflattenToColumns (source:Array, columns:Array):Array
		{
			// Size vars
			var sourceLen:int = source.length;
			var colLen:int = columns.length;
			var lastRowLen:int = sourceLen % colLen;
			var rows:int = Math.ceil( sourceLen / colLen);
			
			// Sort the column to lookup positioning
			var columnsSorted:Array = columns.concat().sort();
			
			// Old data -> new data
			var s:Array = source.concat();
			var matrix:Array = new Array();
			for (var i:int = 0; i < rows; ++i)
			{
				matrix[i] = new Array();
			}
			
			for (i = 0; i < colLen; ++i)
			{
				var columnValue:String = columnsSorted[i] as String;
				var columnNum:int = columns.indexOf(columnValue);
				
				if (columnNum < lastRowLen)
				{
					for (var j:int = 0; j < rows; ++j)
					{
						matrix[j][columnNum] = s.shift();
					}
				}
				else
				{
					for (j = 0; j < rows - 1; ++j)
					{
						matrix[j][columnNum] = s.shift();
					}
				}
			}
			
			return matrix;
		}
		
		private static function numToStrArr (a:Array):void
		{
			for (var i:int = 0; i < a.length; ++i)
			{
				if (a[i] < 10)
				{
					a[i] = '0' + String(a[i]);
				}
				else
				{
					a[i] = String(a[i]);
				}
			}
		}
		
		private static function traceMatrix (a:Array):void
		{
			for (var j:int = 0; j < a.length; ++j)
			{
				trace (padString( String(j), '0', 3), '-', a[j]);
			}
		}
		
		private static function traceMatrixOrder (a:Array, c:int):void
		{
			// Build placeholder matrix
			var matrix:Array = new Array();
			for (var i:int = 0; i < Math.ceil(a.length / c); ++i)
			{
				matrix[i] = new Array();
			}
			
			// Assign everything to matrix in perfect position
			for (i = 0; i < a.length; ++i)
			{
				var p:Point = a[i] as Point;
				if (p)
					matrix[p.y][p.x] = padString( String(i), '0', 3);
			}
			
			//trace ('----------------------------------------------------------------------');
			//traceMatrix (matrix);
		}
		
		private static function padString (s:String, pad:String, len:int, padLeft:Boolean = true):String 
		{
			while (s.length < len) 
			{
				s = padLeft ? pad + s : s + pad;
			}
			return s;
		}
	}
}
