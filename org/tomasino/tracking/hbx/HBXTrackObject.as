﻿package org.tomasino.tracking.hbx
{
	public class HBXTrackObject
	{
		public static const EVENT_TRACK_CLICK:String = 'click';
		public static const EVENT_TRACK_ROLLOVER:String = 'rollover';
		public static const EVENT_TRACK_PAGEVIEW:String = 'pageview';
		public static const EVENT_TRACK_EXIT:String = 'exit';
		
		private var _strEventType:String;
		private var _strLinkName:String;
		private var _strPageName:String;
		private var _strScope:String;
		
		public function HBXTrackObject(sEventType:String = '', sLinkName:String = '', sPageName:String = '', sScope:String = '')
		{
			var bValid:Boolean = true;
			
			if(sEventType == '' || sEventType == null)
			{
				bValid = false;
				throw new ArgumentError('HBXTrackObject :: Missing or invalid event type');
			}
			
			if(sLinkName == '' || sLinkName == null)
			{
				bValid = false;
				throw new ArgumentError('HBXTrackObject :: Missing or invalid link name');
			}
			
			if(sEventType == EVENT_TRACK_PAGEVIEW && (sPageName == '' || sPageName == null))
			{
				bValid = false;
				throw new ArgumentError('HBXTrackObject :: Missing or invalid page name');
			}
			if(sEventType == EVENT_TRACK_EXIT && (sScope == '' || sScope == null))
			{
				//trace ('HBXTrackObject :: Setting default scope to _self');
				sScope = "_self";
			}
			if(bValid)
			{
				_strEventType = sEventType;
				_strLinkName = sLinkName;
				_strPageName = sPageName;
				_strScope = sScope;
			}
			else
			{
				delete this;
			}
		}
		
		public function get EventType():String
		{
			return _strEventType;
		}
		
		public function get LinkName():String
		{
			return _strLinkName;
		}
		
		public function get PageName():String
		{
			return _strPageName;
		}
		public function get Scope():String
		{
			return _strScope;
		}
		public function clone():HBXTrackObject
		{
			return new HBXTrackObject(_strEventType, _strLinkName, _strPageName, _strScope);
		}
	}
}
