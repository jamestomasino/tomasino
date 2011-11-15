package org.tomasino.logging
{
	public class TraceConsole implements IConsole
	{
		private var _lastcategory:String;
		
		public function TraceConsole ():void { }
		
		public function log (category:String, level:Number, message:String):void
		{
			var t:String = ''; // Define output string
			if (category != _lastcategory)
			{
				t += (_lastcategory) ? '\n' : '';
				t += '==> ' + category + '\n';
			}
			
			t += '\t';
			
			switch (level)
			{
				case LogLevel.DEBUG:
					t += 'DEBUG -- ';
					break;
				case LogLevel.INFO:
					t += 'INFO  -- ';
					break;
				case LogLevel.WARN:
					t += 'WARN  -- ';
					break;
				case LogLevel.ERROR:
					t += 'ERROR -- ';
					break;
				case LogLevel.FATAL:
					t += 'FATAL -- ';
					break;
			}
			
			t += message;
			
			_lastcategory = category;
			
			if (t) trace(t);
		}
	}
}