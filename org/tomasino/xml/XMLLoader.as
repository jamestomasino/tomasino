package org.tomasino.xml
{
	import org.tomasino.logging.Logger;
	import flash.system.Security;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class XMLLoader extends EventDispatcher
	{
		public static var debug:Boolean;
		
		private var _xml:XML;
		private var _xmlStrings:Array;
		private var _xmlPath:String;
		private var _index:int = -1;
		private var _xmlLoader:URLLoader = new URLLoader ();
		
		private var _log:Logger = new Logger ('com.bluediesel.xml::XMLLoader');
		
		public function XMLLoader (...args):void
		{
			_log.info ('Constructor -', args);

			_xmlStrings = args;
			_xmlPath = getNextPath();
			if (_xmlPath != null)
			{
				var xmlRequest:URLRequest = new URLRequest(_xmlPath);
				_xmlLoader.addEventListener(Event.COMPLETE, onXMLLoad);
				_xmlLoader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
				_xmlLoader.load(xmlRequest);
			}
			else
			{
				_log.error ('onXMLLoad - No arguments passed');
			}
		}
		
		private function onXMLLoad(e:Event):void
		{
			_log.info ('onXMLLoad - Load Complete');
			if (testXML(e.target.data))
			{
				_log.info ('onXMLLoad - Parse Success');
				dispatchEvent(new Event(Event.COMPLETE));
			}
			else
			{
				// Invalid XML
				_log.warn ('onXMLLoad - Parse Failed -- Invalid XML Data');
				var nextXML:String = getNextPath();
				if (nextXML)
				{
					var xmlRequest:URLRequest = new URLRequest(nextXML);
					_xmlLoader.load(xmlRequest);
				}
			}
		}
		
		private function testXML (data:String):Boolean
		{
			try
			{
				_xml = new XML (data);
			}
			catch(e:Error)
			{
				_log.warn ('testXML', e);
				return false;
			}
			
			if(_xml.nodeKind() != 'element')
			{
				_log.warn ('testXML - Invalid nodeKind');
				return false;
			}
			
			return true;
		}

		private function onIOError(e:IOErrorEvent):void
		{
			_log.warn ('onIOError - Trying Next Path');
			var nextXML:String = getNextPath();
			if (nextXML)
			{
				var xmlRequest:URLRequest = new URLRequest(nextXML);
				_xmlLoader.load(xmlRequest);
			}
		}
		
		private function getNextPath():String
		{
			++ _index;
			if (_index >= _xmlStrings.length)
			{
				dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR));
				return null;
			}
			else
			{
				if (_xmlStrings[_index] is String)
				{
					return _xmlStrings[_index];
				}
				else
				{
					return getNextPath()
				}
			}
		}
				
		public function get xml ():XML
		{
			return _xml;
		}

	}
}
