package com.tomasino.flex.loader
{
	import flash.display.Loader;
	import flash.events.Event;
	import mx.events.FlexEvent;

	public class MoxieLoader extends Loader
	{
		[Bindable] public var debug:Boolean = false;
		
		public function MoxieLoader()
		{
			super();
			this.addEventListener(Event.ENTER_FRAME, checkContent, false, 0, true);
		}
		
		private function checkContent(evt:Event):void{
			if(this.content){
				this.removeEventListener(Event.ENTER_FRAME, checkContent);
				out("MOXIELOADER::FILE LOADED AND INITIALIZED");
				this.dispatchEvent(new Event(Event.COMPLETE));
			}else{
				out("MOXIELOADER::CONTENT LOADING");
			}
		}
		
		private function out(traceString:String):void{
			if(debug){
				trace(traceString);
			}
		}
		
	}
}
