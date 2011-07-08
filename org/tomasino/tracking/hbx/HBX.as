/*
 * Author: Guy Wyatt
 * Date: 2007-10-24
 * 
 * CHANGELOG:
 *     080403: JT - HBX TrackExit is case insensitive now.
 *     080407: JT - Reversed MLC & Pagename for the last time.
 *     080430: JT - Added illegal character stripping
 *     081015: JT - Added disabled property
 */
 
package org.tomasino.tracking.hbx
{
    import org.tomasino.net.Web;
	import org.tomasino.logging.Logger;
    import org.tomasino.utils.DynamicTimer;
    
    import flash.errors.IllegalOperationError;
    import flash.events.TimerEvent;
    import flash.external.ExternalInterface;
	
	public class HBX
	{
		private static var _log:Logger = new Logger ('org.tomasino.tracking.hbx.HBX');
		
		private static var _disabled:Boolean = false;
		public static function get disabled():Boolean {return _disabled;}
		public static function set disabled(value:Boolean):void {_disabled = value;}
		
		// switch to turn forced lowercase on/off.  default to on
		private static var _boolUseLowerCase:Boolean = true;
		public static function get UseLowerCase():Boolean {return _boolUseLowerCase;}
		public static function set UseLowerCase(value:Boolean):void {_boolUseLowerCase = value;}
		
		private static var _objTrackDelayed:HBXTrackDelayed;
		private static var _availability:Boolean;
		public static var mlc:String;
		
		public function HBX()
		{
			throw new IllegalOperationError("HBX cannot be instantiated.");
		}

		// Initializer
		private static function _initialize():Boolean 
		{ 
			try
			{
				_availability = ExternalInterface.call('function() { return (typeof hbx != "undefined"); }') as Boolean;
				ExternalInterface.addCallback('test', function():Boolean {return true});
			}
			catch (e:Error)
			{
				_log.error("_initialize -", "HBX Disabled due to Security Error");
				_availability = false;
			}
			_log.info("_initialize -", "HBX Availability =", _availability);
			return true; 
		}
		private static var _initializer:Boolean = _initialize();
		
		
		public static function TrackClick(sDescription:String):void
		{
			_log.info('TrackClick -', sDescription);			
			if (_availability)
			{
				Track( CreateClick( HBXStrip (sDescription) ) );
			}
		}
		
		public static function TrackRollover(sDescription:String,nDelay:int):void
		{
			_log.info('TrackRollover -', sDescription + ' | ' + nDelay);			
			if (_availability)
			{
				Track( CreateRollover( HBXStrip (sDescription) ),nDelay );
			}
		}
		
		public static function TrackPageview(sMLC:String, sPageName:String):void
		{
			if (!mlc) mlc = sMLC;
			_log.info('TrackPageview -', sMLC + ' | ' + sPageName);			
			if (_availability)
			{
				Track( CreatePageview(HBXStripMLC (sMLC) ,sPageName) );
			}
		}
		public static function Cancel():void
		{
			if (_availability)
			{
				if(_objTrackDelayed)
				{
					_objTrackDelayed.Cancel();
					_objTrackDelayed = undefined;
				}
				else
				{
					throw new Error('HBX::Cancel -- Delayed track object does not exist');
				}
			}
		}
		public static function TrackExit (sDescription:String, sExitLink:String, sScope:String):void
		{
			_log.info('TrackExit -', sDescription + ' | ' + sExitLink + ' | ' + sScope);
			if (_availability)
			{
				Track (CreateExit ( HBXStrip (sDescription), sExitLink, sScope));
			}
		}
		private static function Track(oTrackObj:HBXTrackObject, nDelay:Number=0):void
		{
			var sLinkName:String = UseLowerCase ? oTrackObj.LinkName.toLowerCase() : oTrackObj.LinkName;
			var sPageName:String = UseLowerCase ? oTrackObj.PageName.toLowerCase() : oTrackObj.PageName;
			
			if(nDelay < 0)
			{
				nDelay = 0;
			}
			
			_objTrackDelayed = new HBXTrackDelayed(oTrackObj, nDelay);
			_objTrackDelayed.addEventListener(HBXEventDelayComplete.EVENT_DELAY_COMPLETE, SendTrackingData);
			_objTrackDelayed.Start();
		}
		private static function SendTrackingData(event:HBXEventDelayComplete):void
		{
			// force to lowercase or not based on static boolean
			var sLinkName:String = UseLowerCase ? event.TrackObject.LinkName.toLowerCase() : event.TrackObject.LinkName;
			var sPageName:String = UseLowerCase ? event.TrackObject.PageName.toLowerCase() : event.TrackObject.PageName;
			var sExternalLink:String = event.TrackObject.PageName;
			var sScope:String = event.TrackObject.Scope;

			_log.info('SendTrackingData -', event.TrackObject.EventType + ' | ' + sLinkName + ' | ' + sPageName);
			
			switch (event.TrackObject.EventType)
			{
				case HBXTrackObject.EVENT_TRACK_CLICK:
				case HBXTrackObject.EVENT_TRACK_ROLLOVER:
					if (!_disabled) ExternalInterface.call("_hbLink", sLinkName);
				break;
				
				case HBXTrackObject.EVENT_TRACK_PAGEVIEW:
					if (!_disabled) ExternalInterface.call("_hbPageView", sPageName, sLinkName);
				break;
				case HBXTrackObject.EVENT_TRACK_EXIT :
					if (!_disabled) ExternalInterface.call ("_hbLink",sLinkName);
					var timer:DynamicTimer = new DynamicTimer(500,1);
					timer['sLink'] = sExternalLink;
					timer['sScope'] = sScope;
					timer.addEventListener(TimerEvent.TIMER_COMPLETE, GetURL);
					timer.start();
				break;
			}
		}
		private static function GetURL(e:TimerEvent):void
		{
			var sLink:String = e.target.sLink;
			var sScope:String = e.target.sScope;
			Web.getURL(sLink, sScope);
		}
		private static function HBXStrip (s:String):String
		{
			s = s.split("&").join ("");
			s = s.split("'").join ("");
			s = s.split("#").join ("");
			s = s.split("$").join ("");
			s = s.split("%").join ("");
			s = s.split("^").join ("");
			s = s.split("*").join ("");
			s = s.split(":").join ("");
			s = s.split("!").join ("");
			s = s.split("<").join ("");
			s = s.split(">").join ("");
			s = s.split("~").join ("");
			s = s.split(";").join ("");
			s = s.split("®").join ("");
			s = s.split(" ").join ("+");
			s = s.split("/").join ("-");
			return s;
		}
		private static function HBXStripMLC (s:String):String
		{
			s = s.split("&").join ("");
			s = s.split("'").join ("");
			s = s.split("#").join ("");
			s = s.split("$").join ("");
			s = s.split("%").join ("");
			s = s.split("^").join ("");
			s = s.split("*").join ("");
			s = s.split(":").join ("");
			s = s.split("!").join ("");
			s = s.split("<").join ("");
			s = s.split(">").join ("");
			s = s.split("~").join ("");
			s = s.split(";").join ("");
			s = s.split("®").join ("");
			s = s.split(" ").join ("+");
			return s;
		}
		private static function CreateClick(sDescription:String):HBXTrackObject
		{
			return new HBXTrackObject(HBXTrackObject.EVENT_TRACK_CLICK,sDescription);
		}
		
		private static function CreateRollover(sDescription:String):HBXTrackObject
		{
			return new HBXTrackObject(HBXTrackObject.EVENT_TRACK_ROLLOVER,sDescription);
		}
		
		private static function CreatePageview(sMLC:String, sPageName:String):HBXTrackObject
		{
			return new HBXTrackObject(HBXTrackObject.EVENT_TRACK_PAGEVIEW,sMLC,sPageName);
		}
		private static function CreateExit (sDescription:String, sExitLink:String, sScope:String):HBXTrackObject
		{
			return new HBXTrackObject (HBXTrackObject.EVENT_TRACK_EXIT, sDescription, sExitLink, sScope);
		}		
	}
}
