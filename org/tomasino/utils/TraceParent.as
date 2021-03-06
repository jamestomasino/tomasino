﻿package org.tomasino.utils 
{
	import flash.display.DisplayObject;
	
	public class TraceParent
	{
		public function TraceParent() 
		{
			throw new Error('This Class cannot be instantiated');
		}
		
		/**
		 * Generates string representation of display object heirarchy from stage to target clip. 
		 * @param clip
		 * @return string
		 * 
		 */
		public static function traceParent(clip:DisplayObject):String
		{
			var output:String;
			if(clip.parent != null)
			{
				output = traceParent(clip.parent);
				if (clip.name)
				{
					output += ' -> ' + clip.name;
				}
				else
				{
					output += ' -> ' + clip;
				}
			} 
			else
			{
				if (clip.name)
				{
					output = clip.name;
				}
				else
				{
					output = String(clip);
				}
			}
			return output;
		}
	}
}