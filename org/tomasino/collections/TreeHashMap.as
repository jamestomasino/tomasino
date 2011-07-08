package org.tomasino.collections
{
	import org.tomasino.logging.Logger;
	
	public class TreeHashMap extends TreeHash
	{
		public static const CLIMB_UP:String = 'climbup';
		public static const CLIMB_DOWN:String = 'climbdown';
		public static const FALL:String = 'fall';
		
		protected var _currentKey:Array;
		protected var _currentLeaf:TreeHash;
		protected var _path:Array = new Array ();
		
		private var _log:Logger = new Logger (this);
		
		public function TreeHashMap(branchKey:*)
		{
			this.name = branchKey;
			_currentKey = [branchKey];
			_currentLeaf = this;
		}
		
		public function path ( keys:Array ):Array
		{
			if ( branchExists(keys) )
			{
				var pathArr:Array = new Array();
				
				for (var i:int = 0; i < _currentKey.length; ++i)
				{
					if (i >= keys.length)
					{
						break;
					}
					
					if (keys[i] != _currentKey[i])
					{
						break;
					}
				}
				
				if (i < _currentKey.length)
				{
					for (var k:int = i; k < _currentKey.length; ++k)
					{
						var commandDown:MapCommand = new MapCommand(this);
						commandDown.type = CLIMB_DOWN;
						commandDown.key = _currentKey[k];
						var thisLeafKeys:Array = _currentKey.slice(0,k+1);
						var nextLeafKeys:Array = _currentKey.slice(0,k);
						commandDown.thisLeaf = getLeaf(thisLeafKeys);
						commandDown.nextLeaf = getLeaf(nextLeafKeys);
						pathArr.unshift ( commandDown );
						_log.info ('path -', commandDown.thisLeaf.name, '-->', commandDown.nextLeaf.name);
					}
				}
				
				if (i < keys.length)
				{
					for (var j:int = i; j < keys.length; ++j)
					{
						var commandUp:MapCommand = new MapCommand(this);
						commandUp.type = CLIMB_UP;
						commandUp.key = keys[j];
						thisLeafKeys = keys.slice(0,j);
						nextLeafKeys = keys.slice(0,j+1);
						commandUp.thisLeaf = getLeaf(thisLeafKeys);
						commandUp.nextLeaf = getLeaf(nextLeafKeys);
						
						pathArr.push ( commandUp );
						_log.info ('path -', commandUp.thisLeaf.name, '-->', commandUp.nextLeaf.name);
					}
				}
				
				return pathArr;
			}
			else
			{
				_log.info ('path - Invalid Path');
				return null;
			}
		}
		
		public function climbUp ( key:* ):Boolean
		{
			if (_currentLeaf.containsBranch ( key ) )
			{
				// Update key
				_currentKey.push ( key );
				
				// Shove copy of full position into path, Frankie's mom
				_path.push ( _currentKey.concat() );
				
				// Set new leaf
				_currentLeaf = _currentLeaf.getBranch( key );
				return true;
			}
			return false;
		}
		
		public function climbDown ( key:* = null ):void
		{
			// param optional but not used.
			if (_path.length > 1)
			{
				// Step backwards in Path and use that new position.
				_path.pop();
				var newKey:Array = _path[_path.length-1] as Array;
				_currentKey = newKey.concat();
				_currentLeaf = getLeaf ( _currentKey );
			}
			else
			{
				fall();
			}
		}
		
		public function fall ( key:* = null ):void
		{
			// param optional but not used.
			_path.length = 0; // Kill path if we fall.
			
			if (_currentKey.length > 1)
			{
				_currentKey.pop();
				_currentLeaf = _currentLeaf.parent;
			}
		}
		
		public function get currentKey ():Array
		{
			return _currentKey.concat();
		}
		
		public function get currentLeaf ():TreeHash
		{
			return _currentLeaf;
		}
		
	}
}
