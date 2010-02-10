package com.tomasino.tracking.google
{
	import flash.external.ExternalInterface;
	import flash.errors.IllegalOperationError;
	import com.tomasino.utils.Debug;
	import com.tomasino.external.Availability;
	
	/****
	 * Reflects the Google Analytics API as of 11/24/08.  This class reports using the most current method "pageTracker._", and also 
	 * provides legacy support for the older "urchinTracker" implementation.
	 */
	public class GoogleAnalytics
	{
		private static var _debug:Boolean = false;
		public static function get debug():Boolean { return _debug}
		public static function set debug(value:Boolean):void { _debug = value;}
		
		private static var _flashPrefix:String = "flash";
		public static function get flashPrefix():String { return _flashPrefix}
		public static function set flashPrefix(value:String):void { _flashPrefix = value;}
		
		private static var _availability:Boolean = Availability.available;
		
		public function GoogleAnalytics()
		{
			throw new Error("GoogleAnalytics cannot be instantiated.");
		}
		
		
		/****
		 * TrackClick takes two parameters, the first is a general category for grouping the item 
		 * clicked into a community of items.  The second parameter is the name of the item clicked, or 
		 * the name that should be recorded on the click.
		 * Example: GoogleAnalytics.TrackClick("TopNavigation", "HomeButton");
		 */
		
		public static function TrackClick(category:String, clickName:String):void
		{
			Track(category, "click", clickName);
		}
		
		/****
		 * TrackRollOver takes two parameters, the first is a general category for grouping the item 
		 * clicked into a community of items.  The second parameter is the name of the item rolled over, or 
		 * the name that should be recorded on the roll over.
		 * Example: GoogleAnalytics.TrackRollOver("TopNavigation", "HomeButton");
		 */
		public static function TrackRollOver(category:String, rollOverName:String):void{
			Track(category, "rollOver", rollOverName);
		}
		
		/****
		 * TrackPageView take a single parameter, the name of the page, or the name of the action to be recorded.
		 * Example: GoogleAnalytics.TrackPageView("HomePage");
		 */
		public static function TrackPageView(action:String):void{
			if(_availability){
				var track:String = "/" + _flashPrefix + "/" + action;
				ExternalInterface.call("urchinTracker('"+track+"')");
				ExternalInterface.call("pageTracker._trackPageview('"+track+"')");
				if(_debug) Debug.out("GoogleAnalytics::TrackPageView", "pageTracker._trackPageview('"+track+"')");
			}else{
				if(_debug) Debug.out("GoogleAnalytics::TrackPageView", "External Interface not available to TrackPageView:", track);
			}
		}
		
		/****
		 * JB - As of 11/24/08 event tracking on Google Analytics is still in Beta, so this API is subject to change.  I've noticed that calls
		 * to events take a much longer time to propogate on the tracking suite on Google.
		 */
		public static function Track(category:String, action:String, optional_label:String = null, optional_value:String = null):void{
			if(_availability){
				var gCategory:String = "'" + category;
				var gAction:String = "', '" + action + "'";
				var gLabel:String = (optional_label == null) ? "" : ", '" + optional_label + "'";
				var gValue:String = (optional_value == null) ? "" : ", " + optional_value;
				var call:String = "pageTracker._trackEvent(" + gCategory + gAction + gLabel + gValue + ")";
				ExternalInterface.call(call);
				if(_debug) Debug.out("GoogleAnalytics::Track", call);
			}
			else
			{
				if(_debug) Debug.out("GoogleAnalytics::Track", "External Interface not available to track action: "+action);
			}
		}
		
	}
}
