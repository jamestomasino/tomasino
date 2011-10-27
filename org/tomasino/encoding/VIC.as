package org.tomasino.encoding
{
	import org.tomasino.encoding.SequentialSubstitution;
	import org.tomasino.encoding.DigitMath;
	import org.tomasino.encoding.LaggedFibonacciGenerator;
	import org.tomasino.encoding.StraddlingCheckerboard;
	import org.tomasino.encoding.Transposition;
	
	public class VIC
	{
		
		public static const KEY_AT_ONE_SIR:Array   	= new Array ('A', 'T', ' ', 'O', 'N', 'E', ' ', 'S', 'I', 'R');
		public static const KEY_A_SIN_TO_ERR:Array 	= new Array ('A', 'S', 'I', 'N', 'T', 'O', 'E', 'R', ' ', ' ')
		private static const ROW_2:Array      		= new Array ('B', 'D', 'G', 'J', 'L', 'P', 'U', 'W', 'Y', '.');
		private static const ROW_3:Array      		= new Array ('C', 'F', 'H', 'K', 'M', 'Q', 'V', 'X', 'Z', '#');
		
		// Series from Key Phrase
		private var _s1:Array;
		private var _s2:Array;
		
		// Message Identifier
		private var _mi:Array;
		private var _date:Array;
		
		// 5D Date expanded to 10 + S1 =
		private var _g:Array;
		
		// Substitution 1234567890 with G =
		private var _t:Array;
		
		// T expanded to 50 (5 rows of 10)
		private var _u:Array;
		
		// Header for straddling checkerboard
		private var _c:Array;
		
		private var _firstTrans:int;
		private var _secondTrans:int;
		
		// Transposition Keys
		private var _k1:Array;
		private var _k2:Array;
		
		// straddling checkerboard
		private var _straddlingCheckerboard:StraddlingCheckerboard;
		
		public function VIC ():void
		{
			
		}
		
		public function decode (song:String, keyDate:Date, personalID:String, code:String):String
		{
			// Clean up code
			var regex:RegExp = /[^0-9]/g;
			var codeArr:Array = code.replace(regex, '').split('');
			var codeLen:int = codeArr.length;
			// Derive MI
			var dateString:String = String(keyDate.getFullYear());
			var MIIndex:int = int(dateString.substr(-1, 1));
			if (MIIndex == 0) MIIndex = 10; // in case date ends in 0
			MIIndex = codeLen - (5 * MIIndex);
			var MIArr:Array = codeArr.splice( MIIndex, 5);
			var MI:String = MIArr.join('');
			
			// Calculate Intermediate Keys
			intermediateKeys (song, MI, keyDate, personalID);
			
			// Create Checkerboard
			createStraddlingCheckerboard();
			
			var firstTransposition = Transposition.undisrupted(codeArr, _k2);
			
			var straddledMessage:Array = Transposition.unSimpleColumn( firstTransposition, _k1 );
			
			var message:String = _straddlingCheckerboard.decode( straddledMessage.join('') );
			
			traceIntermediateKeys();

			return message;
			
		}
		
		public function encode (song:String, MI:String, keyDate:Date, personalID:String, message:String):String
		{
			// Calculate Intermediate Keys
			intermediateKeys (song, MI, keyDate, personalID);
			
			// Create Checkerboard
			createStraddlingCheckerboard();

			// Encode message with Checkerboard
			var straddledMessage:String  = _straddlingCheckerboard.encode( message, 5 ); // Mod 5 padding
			
			var straddledArray:Array = straddledMessage.split('');
			
			// First Transposition
			var firstTransposition:Array = Transposition.simpleColumn( straddledArray, _k1 );
			
			// Second Transposition
			var secondTransposition:Array = Transposition.disrupted( firstTransposition, _k2 );
			
			// Insert MI
			var dateString:String = String(keyDate.getFullYear());
			var MIIndex:int = int(dateString.substr(-1, 1));
			if (MIIndex == 0) MIIndex = 10; // dates ending in 0, count as 10
			MIIndex = secondTransposition.length - (5 * (MIIndex - 1));
			var miArr:Array = String(MI).split('');
			var end:Array = secondTransposition.splice ( MIIndex );
			secondTransposition = secondTransposition.concat( miArr);
			secondTransposition = secondTransposition.concat( end );
			
			
			// Format in groups of 5 integers for return
			for (var i:int = 5; i < secondTransposition.length; i += 6)
			{
				secondTransposition.splice(i, 0, ' ');
			}
			
			var encodedMessage:String = secondTransposition.join('');
			
			traceIntermediateKeys();

			return encodedMessage;
		}
		
		private function createStraddlingCheckerboard ():void
		{
			var tableArray:Array = new Array ();
			tableArray = tableArray.concat( _c );
			tableArray = tableArray.concat( KEY_A_SIN_TO_ERR );
			tableArray = tableArray.concat( ROW_2 );
			tableArray = tableArray.concat( ROW_3 );
			_straddlingCheckerboard = new StraddlingCheckerboard (tableArray);
		}
		
		private function intermediateKeys (song:String, MI:String, keyDate:Date, personalID:String):void
		{
			// Build _s1 & _s2 from song & sequentializing
			var regex:RegExp = /[^A-Za-z0-9]/g;
			var songArr:Array = song.toUpperCase().replace(regex, '').split('');
			var s1:Array = songArr.slice(0,10)
			var s2:Array = songArr.slice(10,20);
			
			_s1 = SequentialSubstitution.substitute (s1);
			_s2 = SequentialSubstitution.substitute (s2);
			
			// Choose a random 5-digit message identifier, MI.
			_mi = MI.split('').slice(0,5);
			
			// Subtract, without borrowing, the first five digits of the key date (39175) from MI.
			var dateString:String = String(keyDate.getDate()) + String(keyDate.getMonth() + 1) + String(keyDate.getFullYear());
			_date = dateString.split('').slice(0,5);
			var miDateDiff:Array = DigitMath.subtract(_mi, _date);
			
			// Through chain addition, expand the resulting five digits to ten, and add these digits to S1 (without carrying) to obtain G.
			miDateDiff = LaggedFibonacciGenerator.generate(miDateDiff, 10);
			_g = DigitMath.sum( _s1, miDateDiff );
			
			// Below S2, write the sequence 1234567890. Locate each digit of G in the sequence 1234567890 and replace it with the digit directly above it in S2. The result is T.
			_t = new Array();
			for each (var index:int in _g) 
			{
				_t.push (_s2[index - 1]);
			}
			
			// Use chain addition to expand T by 50 digits. These digits, in five rows of ten, form the U block.
			var uSource:Array = _t.concat();
			uSource = LaggedFibonacciGenerator.generate(uSource, 60);
			
			_u = new Array();
			for (var i:int = 0; i < 5 ; i++)
			{
				var sliceIndex:int = 10 * (i+1);
				_u[i] = uSource.slice(sliceIndex, sliceIndex + 10);
			}
			
			// The last two non-equal digits of the U block are individually added to the agent's personal number to give the widths of the two transpositions.
			if (int(personalID) > 16) throw new ArgumentError ('PersonalID cannot exceed 16');
			_secondTrans = int(personalID) + _u[4][9];
			for (i = 8; i >= 0; i--)
			{
				if (_u[4][9] != _u[4][i])
				{
					_firstTrans = int(personalID) + _u[4][i];
					break;
				}
			}
			
			// Sequentialize T and use this sequence to copy off the columns of the U block, from top to bottom, into a new row of digits.
			
			var seqT:Array = SequentialSubstitution.substituteIntegers( _t );
			var columnU:Array = new Array ();
			
			for (i = 1; i <= 10; ++i)
			{
				var columnIndex:int = seqT.indexOf(i % 10);
				for (var j:int = 0; j < _u.length; ++j)
				{
					columnU.push ( _u[j][columnIndex] );
				}
			}
			
			_k1 = SequentialSubstitution.substituteIntegers(columnU.slice(0, _firstTrans), false);
			_k2 = SequentialSubstitution.substituteIntegers(columnU.slice(_firstTrans, _firstTrans + _secondTrans), false);
			
			// Sequentialize the last row of the U block to get C, the column headers for the straddling checkerboard.
			_c = SequentialSubstitution.substitute( _u[4] );
		}
		
		private function traceIntermediateKeys ():void
		{
			trace ('  _s1:',_s1);
			trace ('  _s2:',_s2);
			trace ('  _mi:',_mi);
			trace ('_date:',_date);
			trace ('   _g:',_g);
			trace ('   _t:',_t);
			for (var i:int = 0; i < _u.length; ++i)
			{
				trace ('_u['+i+']:',_u[i]);
			}
			trace ('_firstTrans:',_firstTrans);
			trace ('_secondTrans:',_secondTrans);
			trace ('  _k1:',_k1);
			trace ('  _k2:',_k2);
		}
	}
}
