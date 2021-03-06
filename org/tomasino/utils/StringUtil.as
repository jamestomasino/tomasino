﻿package org.tomasino.utils 
{
	public class StringUtil
	{
		private static const htmlPattern:RegExp = /<(.|\n)*?>/ig;
		private static const whitespace:RegExp = /[ \t\r\n]/ig;
		private static const ptag:RegExp = /<p[^>]*>/ig;
		private static const brtag:RegExp = /<br[ ]*\/*>/ig;
		
		private static const unicodeEntities:Array = new Array ( 
			new UnicodeEntity ( /&#160;/ig, ' ' ),
			new UnicodeEntity ( /&#8217;/ig, '\'' ),
			new UnicodeEntity ( /&#8220;/ig, '"' ),
			new UnicodeEntity ( /&#8221;/ig, '"' ),
			new UnicodeEntity ( /&#8211;/ig, '-' )	);
		
		
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
				var unicodeEntity:UnicodeEntity = unicodeEntities[i] as UnicodeEntity;
				val = val.replace ( unicodeEntity.code, unicodeEntity.val );
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
		
		public static function insertString (baseString:String, insertString:String, position:Number):String
        {
            var pre:String = baseString.substr(0, position);
            var post:String = baseString.substr(position);
            return pre + insertString + post;
        }
	}
}

internal class UnicodeEntity
{
	public var code:RegExp;
	public var val:String;
	public function UnicodeEntity(newCode:RegExp, newVal:String)
	{
		code = newCode;
		val = newVal;
	}
}