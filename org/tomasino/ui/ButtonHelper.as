package org.tomasino.ui
{
	import flash.display.Sprite;
	
	public class ButtonHelper
	{
		public static function makeButton (...clips):void
		{
			for (var i:int = 0;i<clips.length;++i)
			{
				var clip:Sprite = clips[i] as Sprite;
				clip.useHandCursor = true;
				clip.buttonMode = true;
				clip.mouseChildren = false;
			}
		}
		
		public static function makeNotButton (...clips):void
		{
			for (var i:int = 0;i<clips.length;++i)
			{
				var clip:Sprite = clips[i] as Sprite;
				clip.useHandCursor = false;
				clip.buttonMode = false;
				clip.mouseChildren = true;
			}
		}
	}
}