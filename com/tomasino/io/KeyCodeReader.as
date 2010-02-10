package com.tomasino.io
{
	import flash.display.Stage;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import com.tomasino.events.KeyCodeEvent;
	
	public class KeyCodeReader extends EventDispatcher
	{
		
		private var stage:Stage;
		private var timer:Timer;
		private var isTimerRunning:Boolean = false;
		private var codeArr:Array = new Array();
		private var stringsArr:Array = new Array();
		
		public function KeyCodeReader ( s:Stage, timeOutDelay:Number = 300 ):void
		{
			stage = s;
			timer = new Timer (timeOutDelay, 1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, timerComplete);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyPressed);
		}
		
		public function addMatchCode (key:Array):void
		{
			var stringKey:String = String.fromCharCode.apply(null,key);
			addMatchString (stringKey);
		}
		
		public function addMatchString (key:String):void
		{
			var index:int = stringsArr.indexOf(key);
			if (index == -1)
			{
				stringsArr.push(key);
			}
		}
		
		public function removeMatchCode (key:Array):void
		{
			var stringKey:String = String.fromCharCode.apply(null,key);
			removeMatchString (stringKey);
		}
		
		public function removeMatchString (key:String):void
		{
			var index:int = stringsArr.indexOf(key);
			if (index != -1)
			{
				stringsArr.splice(index,1);
			}
		}
		
		private function keyPressed ( k:KeyboardEvent ):void
		{
			if (!isTimerRunning)
			{
				isTimerRunning = true;
				timer.start();
			}
			else
			{
				timer.reset();
				timer.start();
			}
			var keyCode:int = k.charCode;
			// add check for ctrl/shift/alt here eventually
			
			codeArr.push(keyCode);
			checkCodes();
		}
		
		private function timerComplete ( t:TimerEvent ):void
		{
			codeArr.length = 0;
			isTimerRunning = false;
		}
		
		private function checkCodes ():void
		{
			var key:String = String.fromCharCode.apply(null,codeArr);
			var index:int = stringsArr.indexOf(key);
			if (index != -1)
			{
				var ke:KeyCodeEvent = new KeyCodeEvent (KeyCodeEvent.MATCH);
				ke.key = key;
				dispatchEvent ( ke )
			}
		}
	}
}