﻿package org.tomasino.tracking
{
	public class TrackingData
	{
		// Exit Links
		public var exitLink:String;
		public var exitScope:String;
		
		// Spotlight Tags
		public var spotlightURL:String;
		
		// SearchTracking
		public var searchVars:Array;
		public var searchIDC:Number;
		public var searchLead:Number;
		
		// GoogleAnalytics
		public var googleCategory:String;
		public var googleClickName:String;
		public var googleRollOverName:String;
		public var googlePageName:String;
		
		// Sagemetrics
		public var sageType:String;
		public var sageCategory:String;
		
		// HBX
		public var hbxClickName:String;
		public var hbxRollOverName:String;
		public var hbxPageName:String;
		
		// Omniture
		public var omnitureLinkUrl:String;
		public var omnitureLinkName:String;
		public var omnitureEVars:Array;
		public var omnitureEvents:Array;
		
		public function TrackingData():void
		{
		}
	}
}
