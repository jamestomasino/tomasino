﻿package org.tomasino.tracking.google
{
	import flash.external.ExternalInterface;
	import flash.errors.IllegalOperationError;
	
	import org.tomasino.logging.Logger;
	import org.tomasino.external.Availability;
	
	public class GoogleAnalytics
	{
		private static var _log:Logger = new Logger ('org.tomasino.tracking.google.GoogleAnalytics');
		
		private static var _availability:Boolean = Availability.available;
		
		public function GoogleAnalytics()
		{
			throw new Error("GoogleAnalytics cannot be instantiated.");
		}
		

		/**
		 * TrackClick takes two parameters, the first is a general category for grouping the item 
		 * clicked into a community of items.  The second parameter is the name of the item clicked, or 
		 * the name that should be recorded on the click.
		 * Example: GoogleAnalytics.TrackClick("TopNavigation", "HomeButton");
		 * 
		 * @param category Category of click track
		 * @param clickName Name of click track
		 * 
		 */
		public static function TrackClick(category:String, clickName:String):void
		{
			Track(category, "click", clickName);
		}
		
		/**
		 * TrackRollOver takes two parameters, the first is a general category for grouping the item 
		 * clicked into a community of items.  The second parameter is the name of the item rolled over, or 
		 * the name that should be recorded on the roll over.
		 * Example: GoogleAnalytics.TrackRollOver("TopNavigation", "HomeButton");
		 * 
		 * @param category Category of rollOver track
		 * @param rollOverName Name of rollOver track
		 * 
		 */
		public static function TrackRollOver(category:String, rollOverName:String):void{
			Track(category, "rollOver", rollOverName);
		}
		
		/**
		 * TrackPageView records a pageview via GoogleAnalytics.
		 *   
		 * @param action Name of the page viewed.
		 * 
		 */
		public static function TrackPageView(action:String):void{
			if(_availability)
			{
				var track:String = action;
				ExternalInterface.call("_gaq.push(['_trackPageview', '" + track + "']);");
				_log.info("TrackPageView -", "_trackPageview('"+track+"')");
			}
			else
			{
				_log.error("TrackPageView -", "External Interface not available.");
			}
		}
		
		/**
		 * Track is a direct map of the GoogleAnalytics _trackEvent in JavaScript. The parameters are the same.
		 *   
		 * @param category Category of track event
		 * @param action Action of track event
		 * @param opt_label Label of track event (optional)
		 * @param opt_value Value of track event (optional)
		 * 
		 */
		public static function Track(category:String, action:String, opt_label:String = null, opt_value:String = null):void{
			if(_availability)
			{
				var trackingCall:String = "_gaq.push(['_trackEvent', '" + category + "', '" + action + "'";
				if (opt_label) trackingCall += ", '" + opt_label + "'";
				if (opt_value) trackingCall += ", " + opt_value;
				trackingCall += "])";
				ExternalInterface.call(trackingCall);
				_log.info("Track -", trackingCall);
			}
			else
			{
				_log.error("Track -", "External Interface not available.");
			}
		}
	}
}
