/*
 * Author: Moxie Interactive
 * Date: 2008
 * 
 * CHANGELOG:
 *     02-03-2009: DN – Added trackJS and trackJSExut which call a js file which loads track.swf. This was needed due to the fact
 *					  that the site sits on RTM servers and track.swf/Sagemetrics logs sit on Garnier servers.
 *     02-12-2009: JT - Fixed traces to use _debug and Debug. Removed baseref requirement.
 *     
 *     
 */

 
package org.tomasino.tracking.sagemetrics
{
	import com.adobe.net.DynamicLoader;
	import com.adobe.net.DynamicURLLoader;
	
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	import flash.external.ExternalInterface;	
	
	import org.tomasino.net.Web;
	import org.tomasino.logging.Logger;
	import org.tomasino.external.Availability;
	
	public class SagemetricManager
	{
		private static var _log:Logger = new Logger ('org.tomasino.tracking.sagemetrics.SagemetricManager');
		
		private static var _baseURL:String = "";
		private static var _prefix:String = "track.swf?"
		private static var _urlToLoad:String;
		private static var _scope:String;
		private static var _t:Timer;
		private static var _availability:Boolean = Availability.available;
		
		public function SagemetricManager ():void
		{
			throw new Error("SagemetricManager cannot be instantiated.");
		}
		
		public static function set baseURL (val:String):void
		{
			if ( val.indexOf("?") != -1 ) 
			{
				val = val.substr(0, val.indexOf("?"));
			}
			if (val.lastIndexOf("/") != -1)
			{
				_baseURL = val.substr( 0, val.lastIndexOf("/") ) + "/" + _prefix;
			}
			else if (val == "")
			{
				_baseURL = _prefix;
			}
			else
			{
				_baseURL = val + "/" + _prefix;
			}
			_log.info("baseURL = ", _baseURL);
		}		
		
		public static function trackExit( type:String, cat:String, url:String, scope:String ) : void 
		{
			_log.info("trackExit -", "type =", type, "cat =", cat, "scope =", scope);

			var rndSeed:int = Math.abs(Math.random() * 10000000000000);

			var parameters:String = "";
			parameters += "nocache=" + rndSeed;
			parameters += "&type=" + escape(type);
			
			if (cat.length > 0)
			{
				parameters += "&cat=" + escape(cat);
			}

			var path:String = _baseURL + parameters;

			if (_baseURL.toLowerCase().indexOf("file://") == -1)
			{			
				_log.info("trackExit -", "Sending");
				
				var loader:DynamicURLLoader = new DynamicURLLoader();
				loader.trackurl = url;
				loader.trackscope = scope;
				loader.addEventListener(Event.COMPLETE, OnLoadComplete);
				loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
				loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
				
				try 
				{
					loader.load (new URLRequest(path));
				} catch (error:Error)
				{
					_log.error("trackExit -", "Error loading swf");	
				}
			}	
    	}

		public static function track (type:String, cat:String):void
		{

			_log.info ("track -",  type, cat);

			var rndSeed:int = Math.abs(Math.random() * 10000000000000);

			var parameters:String = "";
			parameters += "nocache=" + rndSeed;
			parameters += "&type=" + escape(type);
			
			if (cat.length > 0)
			{
				parameters += "&cat=" + escape(cat);
			}

			var path:String = _baseURL + parameters;

			if (_baseURL.toLowerCase().indexOf("file://") == -1)
			{
				var loader:DynamicURLLoader = new DynamicURLLoader();
				loader.addEventListener(Event.COMPLETE, OnLoadComplete);
				loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
				loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
				
				try 
				{
					loader.load (new URLRequest(path));
				} catch (error:Error)
				{
					_log.error("track -", "Error loading swf");	
				}
			}
		}
		
		/*
		*
		* @param type 	Type of click event
		* @param cat  	Object clicked
		*
		*/
		
		public static function trackJS(type:String, cat:String):void
		{
			if (_baseURL == null)
			{
				throw new Error("Error: baseURL property not set.");
			}
			_log.info("trackJS -", type, cat);


			var rndSeed:int = Math.abs(Math.random() * 10000000000000);

			var parameters:String = "";
			parameters += "nocache=" + rndSeed;
			parameters += "&type=" + escape(type);
			
			if (cat.length > 0)
			{
				parameters += "&cat=" + escape(cat);
			}

			var path:String = _baseURL + parameters;

			if(_availability)
			{
				ExternalInterface.call('clickIT', path);
			}
		}
		
		/*
		*
		* @param type 	Type of click event
		* @param cat  	Object clicked
		* @param url 	URL destination
		* @param scope 	Determines how the new window is to open
		*/		
		
		public static function trackJSExit( type:String, cat:String, url:String, scope:String):void
		{
			if (_baseURL == null)
			{
				throw new Error("Error: baseURL property not set.");
			}
			_log.info("trackJSExit -", type, cat);

			var rndSeed:int = Math.abs(Math.random() * 10000000000000);

			var parameters:String = "";
			parameters += "nocache=" + rndSeed;
			parameters += "&type=" + escape(type);
			
			if (cat.length > 0)
			{
				parameters += "&cat=" + escape(cat);
			}

			var path:String = _baseURL + parameters;

			if(_availability)
			{
				ExternalInterface.call('clickIT', path);
			}
			if (url != null)
			{
				Web.getURL(url, scope);
			}							
		}				
		
		private static function OnLoadComplete(event:Event):void
		{
			var loader:DynamicURLLoader = DynamicURLLoader(event.target);

			if (loader.trackurl != null)
			{
				_log.info("OnLoadComplete -", "loader.trackurl " + loader.trackurl, loader.trackscope);
				Web.getURL(loader.trackurl, loader.trackscope);
			}
		}
		private static function securityErrorHandler(event:SecurityErrorEvent):void 
		{
			_log.error("securityErrorHandler -" , event);
        }

        private static function httpStatusHandler(event:HTTPStatusEvent):void 
		{
			
        }

        private static function ioErrorHandler(event:IOErrorEvent):void 
		{
			_log.error("ioErrorHandler -" , event);
        }

		
	}
}
