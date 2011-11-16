package org.tomasino.net
{
	import org.tomasino.logging.Logger;
	import flash.external.ExternalInterface;
	import org.tomasino.external.Availability;
	
	public class SynchronousLoader
	{
		private static var _log:Logger = new Logger ( 'org.tomasino.net::SynchronousLoader' );
		private static var _availability:Boolean = Availability.available;
		private static const LOAD_JS:String = 'function org_tomasino_net_SynchronousLoader_load ( url, params ) { RequestType = function () { try { return new XMLHttpRequest (); } catch (e0) {} try { return new ActiveXObject("Msxml2.XMLHTTP.6.0"); } catch (e1) {} try { return new ActiveXObject("Msxml2.XMLHTTP.3.0"); } catch (e2) {} try { return new ActiveXObject("Msxml2.XMLHTTP"); } catch (e3) {} return false; }; var xhttp = RequestType (); if (xhttp) { xhttp.open("POST", url, false); xhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded"); xhttp.setRequestHeader("Content-length", params.length); xhttp.setRequestHeader("Connection", "close"); xhttp.send(params); return xhttp.responseText; } else return false; }' ;

		/*
			function org_tomasino_net_SynchronousLoader_load ( url, params )
			{
				RequestType = function ()
				{
					try { return new XMLHttpRequest (); } catch (e0) {}
					try { return new ActiveXObject("Msxml2.XMLHTTP.6.0"); } catch (e1) {}
					try { return new ActiveXObject("Msxml2.XMLHTTP.3.0"); } catch (e2) {}
					try { return new ActiveXObject("Msxml2.XMLHTTP"); } catch (e3) {}
					return false;
				};
				
				var xhttp = RequestType ();
				if (xhttp)
				{
					xhttp.open("POST", url, false);
					xhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
					xhttp.setRequestHeader("Content-length", params.length);
					xhttp.setRequestHeader("Connection", "close");
					xhttp.send(params);
					return xhttp.responseText;
				}
				else
				{
					return false;
				}
			}
		*/
		
		public static function load (url:String, params:String):XML
		{
			var returnObj:String;
			var xmlReturn:XML;
			
			_log.info ('Loading URL:', url, ' with params (' + params + ')');
			
			if (_availability)
			{
				try
				{
					returnObj = ExternalInterface.call (LOAD_JS, url, params);
				}
				catch (e:Error)
				{
					_log.error ('Could not call XMLHttpRequest via ExternalInterface:', e.message);
				}
				
				try
				{
					xmlReturn = new XML (returnObj);
				}
				catch (e:Error)
				{
					_log.error ('Could not parse XML response');
				}
			}
			else
			{
				_log.warn ('ExternalInterface not available');
			}
			
			return xmlReturn;
		}
	}
}