package com.tomasino.utils
{
	public class Delegate
	{
		public static function create(handler:Function,...args):Function
		{
			return function(...innerArgs):void
			{
				handler.apply(this,innerArgs.concat(args));
			}
		}
	}
}
