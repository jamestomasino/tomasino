package com.tomasino.flex.seo
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	
	/**
	 * HTMLParser - May 05, 2009
	 * The HTMLParser class is based on the GAIA framework class that parses a pages html content.  The
	 * difference in this implementation is that it does not just pull in the contents of the copy div, it
	 * actually grabs all divs on the page, and stores them by their id.  Different pages can be passed in
	 * by calling loadHTML.  Please note that divs that do not have an id are not stored for retrieval, so this 
	 * can be an effective way to exclude copy that you do not want.
	 * 
	 * Example implementation: 
	 * MXML - <mx:Label text="{_parser.getDiv('content')}" color="#ffffff" />
	 * 
	 */
	

	[Bindable]
	public class HTMLParser extends EventDispatcher
	{
		private var _pageHTML:XML;
		private var _divs:Array;
		
		public static const HTML_LOADED:String = "html_loaded";
		
		public function HTMLParser(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public function loadHTML(pageLocation:String):void{
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onLoaderComplete);
			loader.load(new URLRequest(pageLocation));
		}
		
		private function onLoaderComplete(e:Event):void{
			_pageHTML = XML(e.target.data);
			parsePage();
		}
		
		private function parsePage():void{
			XML.ignoreWhitespace = false;
			XML.prettyPrinting = false;
			default xml namespace = new Namespace("http://www.w3.org/1999/xhtml");
			var copyTags:XMLList = _pageHTML..div.(hasOwnProperty("@id"));
			_divs = new Array();
			var len:int = copyTags.length();
			for(var k:int = 0; k < len; k ++){
				_divs[copyTags[k].@id] = copyTags[k];
			}
			this.dispatchEvent(new Event("divsUpdated"));
			this.dispatchEvent(new Event(HTMLParser.HTML_LOADED));
		}
		
		[Bindable(event="divsUpdated")]
		public function getDiv(divID:String):String{
			return _divs[divID];
		}
		
	}
}
