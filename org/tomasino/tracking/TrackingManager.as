﻿package org.tomasino.tracking
{
	import org.tomasino.net.Web;
	import org.tomasino.tracking.types.ITrackingType;
	
	import flash.errors.IllegalOperationError;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class TrackingManager extends EventDispatcher
	{
		// Statics for Singleton Construction
		private static var _instance:TrackingManager;
		private static var _allowInstantiation:Boolean;
		
		// All other vars are instance
		private var _typeList:Array = new Array();
		private var _exitTimer:Timer = new Timer(200,1);
		private var _exitLink:String;
		private var _exitScope:String = '_self';
		private var _isInitialized:Boolean;
		
		public function TrackingManager()
		{
			if (!_allowInstantiation) 
			{
				// There can be only one!!!
				throw new IllegalOperationError("Error: Instantiation failed: Use TrackingManager.instance instead of new.");
			}
			
			_isInitialized = false;
			_exitTimer.addEventListener(TimerEvent.TIMER_COMPLETE, exitLink);
		}

		public static function get instance():TrackingManager 
		{
			if (_instance == null) 
			{
				_allowInstantiation = true;
				_instance = new TrackingManager();
				_allowInstantiation = false;
			}
			return _instance;
		}
		
		
		public function track (e:TrackingEvent):void
		{
			var t:TrackingData = e.data;
			
			_exitLink = t.exitLink;
			_exitScope = t.exitScope || '_self';
			
			for (var i:int = 0; i < _typeList.length; ++i)
			{
				var trackingType:ITrackingType = _typeList[i] as ITrackingType;
				trackingType.track(t);
			}
			
			if (_exitLink)
			{
				_exitTimer.start();	
			}
			
		}
		
		private function exitLink(e:TimerEvent):void
		{
			Web.getURL(_exitLink, _exitScope);
			_exitLink = null;
			_exitScope = null;
		}
		
		public function init (...types):void
		{
			var t:Array = types as Array;
			
			for (var i:int = 0; i < t.length; ++i)
			{
				if (t[i] is ITrackingType)
				{
					var trackingType:ITrackingType = t[i] as ITrackingType;
				}
				else
				{
					// if this isn't a proper type, remove it from the list
					t.splice(i,1);
					// gotta decrement i so nothing gets skipped
					--i;
				}
			}
			_typeList = t;
			
			_isInitialized = true;
		}
		
		/**
		 * Has the init() method been called on this instance?
		 * 
		 * @return boolean representing whether or not this instance's init() method has been called.
		 */
		public function get initialized():Boolean {
			return _isInitialized;	
		}
	}
}
