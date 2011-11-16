package org.tomasino.tracking.omniture
{
	/* Required: ActionSource.swc
	 * You can find this by going to the Admin Console in SiteCatalyst. 
	 * You will find this under the Code Manager.
	 */
	import com.omniture.ActionSource;
	import flash.events.EventDispatcher;

	public class OmnitureSettings extends EventDispatcher
	{
		private var _s:ActionSource;
		
		private var _account:String;
		
		private var _dc:String = '122';
		private var _vmk:String;
		private var _trackingServer:String;
		private var _trackingSecureServer:String;
		private var _visitorNamespace:String;
		private var _movieID:String;
		private var _autoTrack:Boolean = false;
		private var _charSet:String = 'UTF-8';
		private var _cookieDomainPeriods:int = 2;
		private var _cookieLifetime:String = 'session';
		private var _currencyCode:String = 'USD';
		private var _linkLeaveQueryString:Boolean = true;
		private var _trackClickMap:Boolean = true;
		private var _trackDownloadLinks:Boolean = true;
		private var _trackExternalLinks:Boolean = true;
		private var _delayTracking:Number = 500;
		private var _debugTracking:Boolean = false;
		private var _trackLocal:Boolean = false;
		
		public function get account():String { return _account; }
		
		public function set account(value:String):void 
		{
			_account = value;
			_s.account = _account;
		}
		
		public function get dc():String { return _dc; }
		
		public function set dc(value:String):void 
		{
			_dc = value;
			_s.dc = _dc;
		}
		
		public function get vmk():String { return _vmk; }
		
		public function set vmk(value:String):void 
		{
			_vmk = value;
			_s.vmk = _vmk;
		}
		
		public function get trackingServer():String { return _trackingServer; }
		
		public function set trackingServer(value:String):void 
		{
			_trackingServer = value;
			_s.trackingServer = _trackingServer;
		}
		
		public function get trackingSecureServer():String { return _trackingSecureServer; }
		
		public function set trackingSecureServer(value:String):void 
		{
			_trackingSecureServer = value;
			_s.trackingServerSecure = _trackingSecureServer;
		}
		
		public function get visitorNamespace():String { return _visitorNamespace; }
		
		public function set visitorNamespace(value:String):void 
		{
			_visitorNamespace = value;
			_s.visitorNamespace = _visitorNamespace;
		}
		
		public function get movieID():String { return _movieID; }
		
		public function set movieID(value:String):void 
		{
			_movieID = value;
			_s.movieID = _movieID;
		}
		
		public function get autoTrack():Boolean { return _autoTrack; }
		
		public function set autoTrack(value:Boolean):void 
		{
			_autoTrack = value;
			_s.autoTrack = _autoTrack;
		}
		
		public function get charSet():String { return _charSet; }
		
		public function set charSet(value:String):void 
		{
			_charSet = value;
			_s.charSet = _charSet;
		}
		
		public function get cookieDomainPeriods():int { return _cookieDomainPeriods; }
		
		public function set cookieDomainPeriods(value:int):void 
		{
			_cookieDomainPeriods = value;
			_s.cookieDomainPeriods = _cookieDomainPeriods;
		}
		
		public function get cookieLifetime():String { return _cookieLifetime; }
		
		public function set cookieLifetime(value:String):void 
		{
			_cookieLifetime = value;
			_s.cookieLifetime = _cookieLifetime;
		}
		
		public function get currencyCode():String { return _currencyCode; }
		
		public function set currencyCode(value:String):void 
		{
			_currencyCode = value;
			_s.currencyCode = _currencyCode;
		}
		
		public function get linkLeaveQueryString():Boolean { return _linkLeaveQueryString; }
		
		public function set linkLeaveQueryString(value:Boolean):void 
		{
			_linkLeaveQueryString = value;
			_s.linkLeaveQueryString = _linkLeaveQueryString;
		}
		
		public function get trackClickMap():Boolean { return _trackClickMap; }
		
		public function set trackClickMap(value:Boolean):void 
		{
			_trackClickMap = value;
			_s.trackClickMap = _trackClickMap;
		}
		
		public function get trackDownloadLinks():Boolean { return _trackDownloadLinks; }
		
		public function set trackDownloadLinks(value:Boolean):void 
		{
			_trackDownloadLinks = value;
			_s.trackDownloadLinks = _trackDownloadLinks;
		}
		
		public function get trackExternalLinks():Boolean { return _trackExternalLinks; }
		
		public function set trackExternalLinks(value:Boolean):void 
		{
			_trackExternalLinks = value;
			_s.trackExternalLinks = _trackExternalLinks;
		}
		
		public function get delayTracking():Number { return _delayTracking; }
		
		public function set delayTracking(value:Number):void 
		{
			_delayTracking = value;
			_s.delayTracking = _delayTracking;
		}
		
		public function get debugTracking():Boolean { return _debugTracking; }
		
		public function set debugTracking(value:Boolean):void 
		{
			_debugTracking = value;
			_s.debugTracking = _debugTracking;
		}
		
		public function get trackLocal():Boolean { return _trackLocal; }
		
		public function set trackLocal(value:Boolean):void 
		{
			_trackLocal = value;
			_s.trackLocal = _trackLocal;
		}
		
		public function OmnitureSettings (s:ActionSource):void
		{
			_s = s;
			_s.account = _account;
			_s.dc = _dc;
			_s.vmk = _vmk;
			_s.trackingServer = _trackingServer;
			_s.trackingServerSecure = _trackingSecureServer;
			_s.visitorNamespace = _visitorNamespace;
			_s.movieID = _movieID;
			_s.autoTrack = _autoTrack;
			_s.charSet = _charSet;
			_s.cookieDomainPeriods = _cookieDomainPeriods;
			_s.cookieLifetime = _cookieLifetime;
			_s.currencyCode = _currencyCode;
			_s.linkLeaveQueryString = _linkLeaveQueryString;
			_s.trackClickMap = _trackClickMap;
			_s.trackDownloadLinks = _trackDownloadLinks;
			_s.trackExternalLinks = _trackExternalLinks;
			_s.delayTracking = _delayTracking;
			_s.debugTracking = _debugTracking;
			_s.trackLocal = _trackLocal;
		}
	}
}
