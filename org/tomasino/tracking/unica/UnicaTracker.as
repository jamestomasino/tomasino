package org.tomasino.tracking.unica
{
	import org.tomasino.external.Availability;
	import flash.external.ExternalInterface;

	public class UnicaTracker
	{
		public static function eventTag ( arg:String = null ):void
		{
			if (Availability.available)
			{
				if (arg)
				{
					ExternalInterface.call ( 'ntptEventTag', arg );
				}
				else
				{
					ExternalInterface.call ( 'ntptEventTag' );
				}
			}
		}

		public static function addPair ( arg1:String, arg2:String ):void
		{
			if (Availability.available)
			{
				ExternalInterface.call ( 'ntptAddPair', arg1, arg2 );
			}
		}

		public static function dropPair ( arg:String ):void
		{
			if (Availability.available)
			{
				ExternalInterface.call ( 'ntptDropPair', arg );
			}
		}
	}

}
