package org.tomasino.logging
{
	import flash.errors.IllegalOperationError;
	
	public class Log
	{
		private static var _allowInstantiation:Boolean = false;
		private static var _inst:Log;
		
		public var logLevel:int = 0;
		public var filters:Array = new Array();
		
		private var consoles:Array = new Array ();
		
		public function Log ()
		{
			if (!_allowInstantiation)
			{
				throw new IllegalOperationError ('Cannot instantiate Log. Use Log.inst.');
			}
			
			var traceConsole:TraceConsole = new TraceConsole ();
			consoles.push (traceConsole);
		}
		
		public static function get inst():Log
		{
			if (_inst == null)
			{
				_allowInstantiation = true;
				_inst = new Log();
				_allowInstantiation = false;
			}
			return _inst;
		}
		
		public function log (category:String, level:Number, msg:String):void
		{
			if ((level >= logLevel) && (logLevel != -1))
			{
				var show:Boolean = true;
				if (filters.length)
				{
					show = false;
					for (var i:int = 0; i < filters.length; ++i)
					{
						if (filters[i] is RegExp)
						{
							var matchRegExp:RegExp = filters[i] as RegExp;
							if (matchRegExp.test (category))
							{
								show = true;
								break;
							}
						}
						else if (filters[i] is String)
						{
							var matchString:String = filters[i] as String;
							if (matchString == category.substr (0, matchString.length))
							{
								show = true;
								break;
							}
						}
					}
				}
				
				if (show)
				{
					for (i = 0; i < consoles.length; ++i)
					{
						var console:IConsole = consoles[i] as IConsole;
						console.log (category, level, msg);
					}
				}
			}
		}
		
		public function addConsole (c:IConsole):void
		{
			consoles.push (c);
		}
	}
}