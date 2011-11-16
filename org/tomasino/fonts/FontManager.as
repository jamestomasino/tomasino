package org.tomasino.fonts
{
	import org.tomasino.logging.Logger;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.IOErrorEvent;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.text.Font;
		
	public class FontManager extends EventDispatcher
	{
		protected var _log:Logger = new Logger (this);
		
		protected static var _enumerated:Array;
		
		protected static var _fonts:Array = new Array ();
		protected static var _isLoading:Boolean = false;
		protected static var _loadingFonts:Array = new Array ();
		protected static var _currentlyLoadingFont:FontVO;
		protected static var _context:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);
		
		public function FontManager ()
		{
			
		}
		
		public function register (id:String, path:String):void
		{
			for each (var font:FontVO in _fonts)
			{
				if (font.id == id) return;
			}

			var fontVO:FontVO = new FontVO(id, path);
			_fonts.push ( fontVO );
		}
		
		public static function isLoaded(id:String):Boolean
		{
			var valid:Boolean = false;
			_enumerated = Font.enumerateFonts(true);
			for (var i:int = 0; i < _enumerated.length; ++i)
			{
				if (_enumerated[i].fontName == id)
				{
					valid = true;
				}
			}
			return valid;
		}
		
		public function loadFont (id:String):void
		{
			for each (var font:FontVO in _fonts)
			{
				if (font.id == id)
				{
					if (!font.loaded)
					{
						font.loaded = true;
						_loadingFonts.push (font);
					}
					return;
				}
			}
			_log.warn ("Cannot find Font named '" + id + "'");
		}

		public function start ():void
		{
			if (!_isLoading)
			{
				if (_loadingFonts.length)
				{
					_isLoading = true;
					var currentLoadLength:int = _loadingFonts.length;
					var loader:Loader = new Loader ();
					loader.contentLoaderInfo.addEventListener (Event.COMPLETE, onFontsLoad, false, 0, true);
					loader.contentLoaderInfo.addEventListener (IOErrorEvent.IO_ERROR, onFontsFail, false, 0, true);
					loader.load (new URLRequest (_loadingFonts[0].path), _context);
					_currentlyLoadingFont = _loadingFonts.shift ();
				}
				else
				{
					_currentlyLoadingFont = null;
					dispatchEvent (new Event(Event.COMPLETE));
				}
			}
		}

		private function onFontsLoad ( event:Event ):void
		{
			LoaderInfo (event.target).removeEventListener (Event.COMPLETE, onFontsLoad, false);
			LoaderInfo (event.target).removeEventListener (IOErrorEvent.IO_ERROR, onFontsFail, false);
			_isLoading = false;
			start ();
		}

		private function onFontsFail ( event:IOErrorEvent ):void
		{
			LoaderInfo (event.target).removeEventListener (Event.COMPLETE, onFontsLoad, false);
			LoaderInfo (event.target).removeEventListener (IOErrorEvent.IO_ERROR, onFontsFail, false);
			_log.error ("Invalid path to Font named '" + _currentlyLoadingFont.id + "'");
			_isLoading = false;
			start ();
		}
	}
}

internal class FontVO
{
	public var id:String;
	public var path:String;
	public var loaded:Boolean = false;

	public function FontVO (_id:String = null, _path:String = null)
	{
		id = _id;
		path = _path;
	}
}
