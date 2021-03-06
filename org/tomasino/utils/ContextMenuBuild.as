﻿package org.tomasino.utils
{
	import flash.display.InteractiveObject;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	public class ContextMenuBuild
	{
		[Embed(source="c:/path/to/build/number/text/file.txt",mimeType="application/octet-stream")]
		private static var BuildTextClass : Class;
		
		public static function addBuildNum(iDisp:InteractiveObject)
		{
			var builtNumberText:String = BuildTextClass();
			
			var buildNumberMenu:ContextMenu = new ContextMenu();
			var buildNumber:ContextMenuItem = new ContextMenuItem('Build #' + builtNumberText);
			sourceLink.separatorBefore = false;
			
			buildNumberMenu.hideBuiltInItems();
			buildNumberMenu.customItems.push(buildNumber, sourceLink);
			iDisp.contextMenu = buildNumberMenu;
		}
	}
}