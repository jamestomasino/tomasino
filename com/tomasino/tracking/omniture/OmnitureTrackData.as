package com.tomasino.tracking.omniture
{
	
	/**
	 * Omniture Tracking Data Value Object
	 * @author tomasino
	 */
	public class OmnitureTrackData
	{
		public static const TYPE_CUSTOM_LINK:String = 'o';
		public static const TYPE_FILE_DOWNLOAD:String = 'd';
		public static const TYPE_EXIT_LINK:String = 'e';
		
		// for track
		public var pageName:String;
		public var pageURL:String;
		public var referrer:String;
		public var purchaseID:String;
		public var transactionID:String;
		public var channel:String;
		public var server:String;
		public var pageType:String;
		public var visitorID:String;
		public var variableProvider:String;
		public var campaign:String;
		public var state:String;
		public var zip:String;
		public var events:Array = new Array();
		public var products:Array = new Array();
		public var props:Array = new Array();
		public var evars:Array = new Array();
		public var heirs:Array = new Array ();
		
		// for trackLink
		public var type:String;
		public var linkName:String;
		public var linkURL:String;
		public var linkWindow:String;
	}
}