package com.tomasino.utils
{
	public class StringUtil
	{
		private static const htmlPattern:RegExp = /<(.|\n)*?>/ig;
		private static const whitespace:RegExp = /[ \t\r\n]/ig;
		private static const ptag:RegExp = /<p[^>]*>/ig;
		private static const brtag:RegExp = /<br[ ]*\/*>/ig;
		private static const unicodeEntities:Array = new Array ( 	{ code:/&#160;/ig, val:' ' },
																	{ code:/&#8217;/ig, val:'\'' },
																	{ code:/&#8220;/ig, val:'"' },
																	{ code:/&#8221;/ig, val:'"' },
																	{ code:/&#8211;/ig, val:'-' }
																								);
		/**
		 * Strips HTML from a string and returns result
		 * @param	val String with HTML Markup
		 * @return	String sans HTML Markup
		 */
		public static function stripHTML (val:String):String
		{
			return val.replace( htmlPattern, "");
		}
		
		public static function unicodeEntityDecode ( val:String ):String
		{
			for (var i:int = 0; i < unicodeEntities.length; ++i)
			{
				var reg:RegExp = unicodeEntities[i].code as RegExp;
				var rep:String = unicodeEntities[i].val as String;
				val = val.replace ( reg, rep );
			}
			return val;
		}
		
		public static function cleanPTags ( val:String ):String
		{
			return val.replace ( ptag, "\n\n");
		}
		
		public static function clearBRTags ( val:String ):String
		{
			return val.replace ( brtag, "\n");
		}
		
		public static function cleanExtraWhitespace ( val:String ):String
		{
			return val.replace ( whitespace, ' ');
		}
	}
}