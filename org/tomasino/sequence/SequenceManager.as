﻿/*
 * Author: James Tomasino
 * Date: 2008-02-06
 * 
 * CHANGELOG:
 *     
 */
package org.tomasino.sequence
{
	import flash.events.EventDispatcher;
	import flash.events.Event;
	
	import org.tomasino.logging.Logger;
	
	public class SequenceManager extends EventDispatcher
	{
		private var _log:Logger = new Logger (this);
		
		public static var EVENT_CHANGE:String = 'EVENT_CHANGE';
		public static var EVENT_COMPLETE:String = 'EVENT_COMPLETE';
		
		private static var _debug:Boolean;
		public static function get debug():Boolean { return _debug; }
		public static function set debug(value:Boolean):void { _debug = value; }
		
		private var _numCount:uint;
		public function get Count():uint {return _numCount;}
		public function set Count(value:uint):void
		{
			_log.info ('Count -', _numCount + ' -> ' + value);
			
			if(value < 0 || value > _numTotal)
			{
				value = _numCount;
			}
			
			if(value != _numCount)
			{
				_numCount = value || 0;
				dispatchEvent(new Event(EVENT_CHANGE));
				
				if(IsComplete)
				{
					dispatchEvent(new Event(EVENT_COMPLETE));
				}
			}
		}
		
		private var _numTotal:uint;
		public function get Total():uint {return _numTotal;}
		public function set Total(value:uint):void
		{
			_log.info ('Total -', _numTotal + ' -> ' + value);
			
			if(value > 0)
			{
				_numTotal = value;
			}
			else
			{
				_numTotal = _numCount || 0;
			}
		}
		
		public function get IsComplete():Boolean {return Count == Total && Total > 0;}
		
		public function SequenceManager(nTotal:uint = 0, nStart:uint = 0):void
		{
			_numCount = nStart || 0;
			Total = nTotal;
		}
		
		public function Reset():void
		{
			_log.info ('Reset');
			_numCount = 0;
		}
	}
}
