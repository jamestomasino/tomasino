package org.tomasino.utils 
{
	public class ObscureText
	{
		private static var chars:Array = new Array ();
		chars [65] = ['À','Á','Â','Ã','Ä','Å'];
		chars [66] = ['ß','Β'];
		chars [67] = ['Ç','Ĉ','Ċ'];
		chars [68] = ['Ð','Đ'];
		chars [69] = ['È','É','Ê','Ë','€','Ĕ','Ė'];
		chars [71] = ['Ĝ','Ğ','Ġ','Ģ'];
		chars [72] = ['Ħ','Ĥ'];
		chars [73] = ['Ì','Í','Î','Ï','Ĩ','Ī','Ĭ'];
		chars [74] = ['Ĵ'];
		chars [75] = ['ĸ'];
		chars [76] = ['Ļ','Ŀ','Ł'];
		chars [78] = ['Ñ','Ń','Ņ','Ň','Ŋ'];
		chars [79] = ['Ò','Ó','Ô','Õ','Ö','Ø','Ō','Ŏ','Ő'];
		chars [82] = ['Ŗ'];
		chars [83] = ['Š','Ŝ','Š'];
		chars [84] = ['Ŧ'];
		chars [85] = ['Ù','Ú','Û','Ü','Ũ','Ū','Ŭ','Ů','Ű','Ų'];
		chars [87] = ['Ŵ'];
		chars [89] = ['Ý','Ÿ','Ŷ','Ÿ'];
		chars [90] = ['Ž'];

		chars [97] = ['à','á','â','ã','ä','å','ą'];
		chars [98] = ['þ'];
		chars [99] = ['ç','ć','ĉ','ċ','č'];
		chars [100] = ['ď','đ'];
		chars [101] = ['è','é','ê','ë','ĕ','ė','ě'];
		chars [102] = ['ƒ'];
		chars [103] = ['ĝ','ğ','ġ','ģ'];
		chars [104] = ['ĥ','ħ'];
		chars [105] = ['ì','í','î','ï','ĩ','ī','ĭ'];
		chars [106] = ['ĵ'];
		chars [108] = ['ĺ','ļ','ľ','ŀ','ł'];
		chars [110] = ['ñ','ń','ņ','ň','ŉ','ŋ'];
		chars [111] = ['ð','ò','ó','ô','õ','ö','ø','ō','ŏ','ő'];
		chars [114] = ['ŕ','ŗ','ř'];
		chars [115] = ['š','ś','ŝ','ş','š'];
		chars [116] = ['†','ţ','ť','ŧ'];
		chars [117] = ['ù','ú','û','ü','ũ','ū','ŭ','ů','ű','ų'];
		chars [119] = ['ŵ'];
		chars [120] = ['×'];
		chars [121] = ['ý','ÿ'];
		chars [122] = ['ź','ż','ž'];

		/**
		 * Returns a unicode character that looks visually similar to original character. 
		 * @param num
		 * @return unicode character
		 * 
		 */
		public static function charByCode ( num:int ):String
		{
			if (chars[num] != null)
			{
				var charList:Array = chars[num] as Array;
				var returnString:String = charList.shift();
				charList.push (returnString);
				return returnString;
			}
			else
			{
				return String.fromCharCode ( num );
			}
		}
	}
}


