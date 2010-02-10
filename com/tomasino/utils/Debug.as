﻿package com.tomasino.utils
{
	import flash.system.Capabilities;
	import com.tomasino.external.QueryString;
	
	public class Debug
	{
		public static var headersOnly:Boolean = false;
		public static var enabled:Boolean = false;
		private static var lastheading:String = "";
		
		public function Debug (){}
		
		private static function init():Boolean
		{
			var d:String = QueryString.params['debug'] as String;
			if (d)
				if (d.toLowerCase() == 'true') 
					enabled = true;
			
			if (Capabilities.playerType == "External")
				enabled = true;
							
			return true;
		}
		private static var _initializer:Boolean = init();
		
		public static function out(heading:String, ...msg):void
		{
			if (enabled)
			{
				var t:String = ''; // Define output string
				
				if (heading == lastheading)
				{
					if (!headersOnly) t += '\t' + msg.join(' ');
				}
				else
				{
					if (!headersOnly) t += (lastheading) ? '\n' : '';
					t += '==> ' + heading;
					if (!headersOnly) t += '\n\t' + msg.join(' ');
				}
				
				lastheading = heading;
				if (t) trace(t);
			}
		}
	}
}
