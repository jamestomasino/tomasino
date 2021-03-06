﻿package org.tomasino.net
{
	import flash.net.URLVariables;
	import org.tomasino.net.SchemeType;
	
	public class URI
	{
		/* Limitations:
		 * 		Does not handle schemes that contain ":" characters.
		 * 		Does not parse usernames & passwords in urls (i.e., http://username:password@domain.com/)
		 */
		private static const URI_REGEX:RegExp = new RegExp ('^(([^:/\\?#]+):)?(//([^/\\?#:]*))?(:(\\d+))?([^\\?#]*)(\\?([^#]*))?(#(.*))?');
		
		protected var _uri:String;
		protected var _scheme:String;
		protected var _host:String;
		protected var _port:int = 80;
		protected var _path:String;
		protected var _pathArray:Array;
		protected var _variables:URLVariables;
		protected var _anchor:String;
		protected var _treeArray:Array;
		protected var _baseUri:String;
		
		public function URI (value:String = null):void
		{
			if (value) uri = value;
		}
		
		public function destroy ():void
		{
			_uri = null;
			_scheme = null;
			_host = null;
			_port = 80;
			_pathArray = null;
			_variables = null;
			_anchor = null;
			_treeArray = null;
			_baseUri = null;
		}
		
		public function set uri (value:String):void
		{
			destroy ();
			
			_uri = value;
			
			var result:Object = URI_REGEX.exec(_uri);
			if (result[2]) _scheme = SchemeType.getScheme (result[2]);
			_host = (result[4] == null?'':result[4]);
			_port = (result[6] == null?80:result[6]);
			_path = (result[7] == null?'':result[7]);
			_pathArray = (_path.substr (0, 1) == '/') ? _path.substr (1).split ('/') : _path.split ('/');
			_variables = new URLVariables ();
			if (result[8] != null) _variables.decode (result[8]);
			_anchor = (result[11] == null?'':result[11]);
		}
		
		public function get anchor():String { return _anchor; }
		
		public function get variables():URLVariables { return _variables; }
		
		public function get pathArray():Array { return _pathArray; }
		
		public function get path():String { return _path; }
		
		public function get port():int { return _port; }
		
		public function get host():String { return _host; }
		
		public function get scheme():String { return _scheme; }
		
		public function get uri():String { return _uri; }
		
		public function get treeList ():Array
		{
			if (!_treeArray)
			{
				_treeArray = new Array ();
				for (var i:int = 0; i < _pathArray.length; ++i)
				{
					var path:String = '';
					for (var j:int = 0; j < i; ++j)
					{
						path += _pathArray[j] + '/';
					}
					_treeArray.push (baseUri + path);
				}
			}
			return _treeArray;
		}
		
		public function get baseUri ():String
		{
			if (!_baseUri)
			{
				_baseUri = _scheme + "://" + _host;
				if (_port != 80)
				{
					_baseUri += ":";
					_baseUri += _port;
				}
				_baseUri += "/";
			}
			return _baseUri;
		}
		
		public function toString ():String
		{
			return _uri;
		}
	}
}