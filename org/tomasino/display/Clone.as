﻿package org.tomasino.display
{
	public class Clone
	{
		import flash.display.DisplayObject;
		import flash.display.DisplayObjectContainer;
		import flash.geom.Rectangle;
		
		public function Clone (){}
		
		public static function CloneDisplayObject(target:DisplayObject):DisplayObject
		{
			var targetClass:Class = Object(target).constructor;
			
			var duplicate:DisplayObject = new targetClass();
			duplicate.transform = target.transform;
			duplicate.filters = target.filters;
			duplicate.cacheAsBitmap = target.cacheAsBitmap;
			duplicate.opaqueBackground = target.opaqueBackground;
			
			if (target.scale9Grid) 
			{
				var rect:Rectangle = target.scale9Grid;
				// Flash 9 bug where returned scale9Grid is 20x larger than assigned
				rect.x /= 20, rect.y /= 20, rect.width /= 20, rect.height /= 20;
				duplicate.scale9Grid = rect;
			}
			
			if (target.hasOwnProperty("numChildren"))
			{
				var duplicateContainer:DisplayObjectContainer = duplicate as DisplayObjectContainer;
				var targetContainer:DisplayObjectContainer = target as DisplayObjectContainer;
				for (var i:int = 0 ; i < targetContainer.numChildren; i ++)
				{
					duplicateContainer.addChild(CloneDisplayObject(targetContainer.getChildAt(i)));
				}
			}
			
			return duplicate;
		}
	}
}
