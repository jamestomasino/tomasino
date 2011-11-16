﻿package org.tomasino.io
{
	import flash.display.Stage;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.tomasino.events.KeyCodeEvent;
	
	public class KeyCodeReader extends EventDispatcher
	{
		
		private var stage:Stage;
		private var timer:Timer;
		private var isTimerRunning:Boolean = false;
		private var matchHash:Hash = new Hash();
		private var codeArr:Array = new Array();
		
		public function KeyCodeReader ( s:Stage, timeOutDelay:Number = 300 ):void
		{
			stage = s;
			timer = new Timer( timeOutDelay, 1 );
			timer.addEventListener( TimerEvent.TIMER_COMPLETE, timerComplete );
			stage.addEventListener( KeyboardEvent.KEY_DOWN, keyPressed );
		}
		
		public function addMatchCode ( key:Array ):void
		{
			matchHash.add( key.concat() );
		}
		
		public function removeMatchCode ( key:Array ):void
		{
			// Remove key, somehow?
		}
		
		private function keyPressed ( k:KeyboardEvent ):void
		{
			if ( !isTimerRunning )
			{
				isTimerRunning = true;
				timer.start();
			}
			else
			{
				timer.reset();
				timer.start();
			}
			var keyCode:int = k.keyCode;
			// add check for ctrl/shift/alt here eventually
			
			codeArr.push( keyCode );
			checkCodes();
		}
		
		private function timerComplete ( t:TimerEvent = null):void
		{
			codeArr.length = 0;
			isTimerRunning = false;
		}
		
		private function checkCodes ():void
		{
			if (matchHash.testHash( codeArr.concat() ))
			{
				var ke:KeyCodeEvent = new KeyCodeEvent ( KeyCodeEvent.MATCH );
				ke.key = codeArr;
				dispatchEvent ( ke )
				timerComplete();
			}
		}
	}
}

internal class Hash
{
	private var _arr:Array = new Array();
	
	public function Hash (newValues:Array = null) 
	{
		if (newValues)
			add (newValues);
	}
	
	public function isSet (i:int):Boolean
	{
		return (_arr[i]) ? true : false;
	}
	
	public function add (newValues:Array):void
	{
		if (newValues.length)
		{
			var i:int = newValues.shift ();
			if (!isSet(i))
			{
				_arr[i] = new Hash(newValues);
			}
			else
			{
				var h:Hash = _arr[i] as Hash;
				h.add(newValues);
			}
		}
	}
	
	public function testHash (values:Array):Boolean
	{
		if (_arr.length == 0) return true;
		else
		{
			var i:int = values.shift ();
			if (!isSet(i)) return false;
			else
			{
				var h:Hash = _arr[i] as Hash;
				return h.testHash(values);
			}
		}
	}
}
