package com.tomasino.collections
{
	import com.tomasino.logging.Logger;
	import com.tomasino.collections.TreeHashMap;
	
	public class MapCommand
	{
		private var _type:String;
		private var _map:TreeHashMap;
		public var key:*;
		public var thisLeaf:TreeHash;
		public var nextLeaf:TreeHash;
		
		private var _log:Logger = new Logger (this);
		
		public function MapCommand(map:TreeHashMap)
		{
			_map = map;
		}
		
		public function execute():void
		{
			if (_map && key)
			{
				switch (type)
				{
					case TreeHashMap.CLIMB_UP:
						_map.climbUp(key);
						break;
					case TreeHashMap.CLIMB_DOWN:
						_map.climbDown(key);
						break;
					case TreeHashMap.FALL:
						_map.fall(key);
						break;
				}
			}
			else
			{
				_log.info ('execute - MapCommand not initialized or invalid key');
				_log.info ('execute - key -', key);
				_log.info ('execute - map exists -', (_map != null));
			}
		}
		
		public function set type (val:String):void
		{
			switch (val)
			{
				case TreeHashMap.CLIMB_UP:
				case TreeHashMap.CLIMB_DOWN:
				case TreeHashMap.FALL:
					_type = val;
					break;
				default:
					throw new ArgumentError ('Invalid Type for MapCommand -', val);
					break;
			}
		}
		
		public function get type ():String
		{
			return _type;
		}
		
		public function toString():String
		{
			return '[MapCommand ' + thisLeaf.name + ' --> ' + nextLeaf.name + ']';
		}
	}
}
