package com.tomasino.logging
{
	import flash.errors.IllegalOperationError;
	
	public class LogLevel
	{
		public static const NONE: int  = -1;
		public static const ALL : int = 0;
		public static const DEBUG : int = 2;
 	 	public static const INFO : int = 4;
 	 	public static const WARN : int = 6;
		public static const ERROR : int = 8;
 	 	public static const FATAL : int = 1000;
		
		public function LogLevel () { throw new IllegalOperationError ('Cannot Instantiate LogLevel'); }
	}
}