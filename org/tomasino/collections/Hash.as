package org.tomasino.collections
{
    import flash.utils.Dictionary;
    public class Hash
    {
        protected var map:Dictionary;

        public function Hash(key:* = null, value:* = null)
        {
            map = new Dictionary(true);
            if (key != null)
            {
            	add (key, value);
            }
        }

        public function add(key:*, value:*) : void
        {
            map[key] = value;
        }

        public function remove(key:*) : void
        {
            delete map[key];
        }

        public function containsKey(key:*) : Boolean
        {
			for (var k:Object in map)
			{
				if (k == key) return true;
			}
            return false;
        }

        public function containsValue(value:*) : Boolean
        {
            var result:Boolean = false;

            for ( var key:* in map )
            {
                if ( map[key] == value )
                {
                    result = true;
                    break;
                }
            }
            return result;
        }

        public function getKey(value:*) : *
        {
            var id:Object = null;

            for ( var key:* in map )
            {
                if ( map[key] == value )
                {
                    id = key;
                    break;
                }
            }
            return id;
        }

        public function get keys() : Array
        {
            var keys:Array = [];

            for (var key:* in map)
            {
                keys.push( key );
            }
            return keys;
        }

        public function getValue(key:*) : *
        {
            return map[key];
        }

        public function get values() : Array
        {
            var values:Array = [];

            for (var key:* in map)
            {
                values.push( map[key] );
            }
            return values;
        }

        public function get hashLength() : int
        {
            var length:int = 0;

            for (var key:* in map)
            {
                length++;
            }
            return length;
        }

        public function get isHashEmpty() : Boolean
        {
            return hashLength <= 0;
        }

        public function resetHash() : void
        {
            for ( var key:* in map )
            {
                map[key] = undefined;
            }
        }

        public function clearHash() : void
        {
            for ( var key:* in map )
            {
                remove( key );
            }
        }

        public function get entries() : Array
        {
            var list:Array = new Array();

            for ( var key:* in map )
            {
                list.push( { key:key, value:map[key] } );
            }
            return list
        }

        public function get dict():Dictionary
        {
        	return map;
        }
    }
}
