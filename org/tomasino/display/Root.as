/*
 * Author: James Tomasino
 * Date: 2009-06-07
 * 
 * CHANGELOG:
 *     081210: JT - Adding Library instantiation method
 *	   090303: JT - Updated definitions of root and stage onAddedToStage
 */

package org.tomasino.display
{

	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.utils.getDefinitionByName;

	public class Root extends MovieClip
	{

		public static var stage:Stage;
		public static var root:Root;

		public function Root ()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			Root.stage = this.stage;
			Root.root = this;
		}
		private function onAddedToStage (e:Event):void
		{
			Root.stage = this.stage;
			Root.root = this;
		}
		public function instantiateLibraryItem (s:String):*
		{
			var c:Class=getDefinitionByName(s)  as  Class;
			var r:* =new c();
			return r;
		}
	}
}
