package com.tomasino.collections
{
	import com.tomasino.logging.Logger;
	
	import flash.errors.IllegalOperationError;
	import flash.utils.Dictionary;
	
	
	public class TreeHash extends Hash
	{
		protected var tree:Dictionary = new Dictionary(true);
		protected var _keysArr:Array = new Array();
		protected var _parent:TreeHash;
		public var name:*;
		
		private var _log:Logger = new Logger (this);
		
		public function TreeHash(key:* = null, value:* = null)
		{
			super(key, value);
		}
		
		public function branchExists (k:Array):Boolean
		{
			var keys:Array = k.concat();
			var isValidPath:Boolean = true;
			if (keys.length != 0)
			{
				var firstElement:* = keys.shift();
				
				if (firstElement == name)
				{
					if ( containsBranch(firstElement) )
					{
						isValidPath = isValidPath && tree[firstElement].exists (keys);
					}
				}
				else
				{
					isValidPath = false
				}
			}
			else
			{
				isValidPath = false;
			}
			return isValidPath;
		}
		
		public function addBranch ( key:*, branch:TreeHash ):void
		{
			_keysArr.push (key);
			_log.info ('addBranch - key - ', key );
			tree[ key ] = branch;
			branch.name = key;
			branch.parent = this;
		}
		
		public function removeBranch ( key:* ):void
		{
			delete tree[ key ];
		}
		
		public function containsBranch ( key:* ):Boolean
		{
			return tree.hasOwnProperty( key );
		}
		
		public function getBranch ( key:* ):TreeHash
		{
			return tree[ key ];
		}
		
		public function getAllBranchKeys ():Array
		{
			return _keysArr.concat();
		}
		
		public function getLeaf ( k:Array ):TreeHash
		{
			var keys:Array = k.concat();
			var leaf:TreeHash;
			
			if ( branchExists (keys) )
			{
				if (keys[0] == this.name)
				{
					keys.shift();
				}
				leaf = getLeafRecur ( this, keys );
			}
			else
			{
				throw new IllegalOperationError ('TreeHash::getLeaf - Invalid Leaf');
			}
			
			return leaf;
		}
		
		private function getLeafRecur ( leaf:TreeHash, keys:Array ):TreeHash
		{
			if(keys.length == 0)
			{
				return leaf;
			}
			else
			{
				var firstElement:* = keys.shift();
				var newLeaf:TreeHash = leaf.getBranch(firstElement);
				leaf = getLeafRecur( newLeaf, keys );
			}

			return leaf;
		}
		
		public function getBranchKeys ( value:TreeHash ):Array
		{
			var keys:Array = new Array();
			for (var key:* in tree )
			{
				if ( tree[key] == value )
				{
					keys.push (key)
				}
			}
			return keys;
		}
		
		public function get treeLength ():int
		{
			var length:int = 0;
			for (var key:* in tree)
			{
				length++;
			}
			return length;
		}
		
		public function get isTreeEmpty ():Boolean
		{
			return treeLength <= 0;
		}
		
		public function clearTree() : void
        {
            for ( var key:* in tree )
            {
                remove( key );
            }
        }
        public function reparent (key:*, val:*):void
        {
        	if (_parent.containsBranch( key ))
        	{
	       		_parent.removeBranch( key );
	        	val.addBranch ( key, this );
	        	_parent = val;
	        }
        }

        public function set parent (val:*):void
        {
        	if (_parent == null)
        	{
        		_parent = val;
        	}
        }

        public function get parent ():*
        {
        	return _parent;
        }

        public function toString ():String
        {
        	var output:String = '[' + name + ']\n';
        	output += toFormatString ( this, '\t' );
        	return output;
        }

        public function toFormatString ( branch:TreeHash, indent:String = ''):String
		{
			var output:String = '';
        	for (var key:* in branch.tree )
			{
				output += indent + '[' + key + ']\n';
				if ( branch.containsBranch( key ) )
				{
					var nextBranch = branch.getBranch( key );
					output += toFormatString ( nextBranch, indent + '\t' );
				}
			}

        	return output;
		}
	}
}
