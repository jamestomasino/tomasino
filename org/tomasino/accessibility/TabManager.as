package org.tomasino.accessibility
{
	import flash.display.InteractiveObject;
	import flash.utils.Dictionary;

	public class TabManager
	{
		private static var _inst:TabManager;
		private var _hash:Dictionary = new Dictionary(true);
		private var _activeCategory:Object;
		
		public function TabManager (_singletonEnforcer:SingletonEnforcer):void { }
		
		public static function get inst ():TabManager
		{
			if (!_inst)
			{
				_inst = new TabManager (new SingletonEnforcer ());
			}
			return _inst;
		}
		
		public function addTabItem (category:Object, io:InteractiveObject, index:int = -1):void
		{
			// Set this as active category if this is the first item added
			if (!_activeCategory) _activeCategory = category;

			var cat:Array;
			
			// If no existing category, create it
			if (exists(category))
			{
				cat = _hash[category] as Array;
			}
			else
			{
				cat = new Array ();
				_hash[category] = cat;
			}
			
			var existingIndex:int = cat.indexOf (io);
		
			if (existingIndex == -1)
			{
				// If item is already in category...
				if ((index >= 0) && (index < cat.length))
				{
					// Put it in a valid index
					cat.splice (index, 0, io);
				}
				else
				{
					// Put it at the end
					cat.push (io);
				}
			}
			else
			{
				if (existingIndex != index)
				{
					cat.splice (existingIndex, 1);
					if ((index >= 0) && (index < cat.length))
					{
						// Put it in a valid index
						cat.splice (index, 0, io);
					}
					else
					{
						// Put it at the end
						cat.push (io);
					}
				}
			}
			if (_activeCategory != category)
			{
				var activeCategory:Array = _hash[_activeCategory] as Array;
				if (activeCategory.indexOf (io) == -1)
					io.tabEnabled = false;
			}
			else
			{
				io.tabEnabled = true;
			}
			
			//io.focusRect = false;
			updateTabOrder (category);
		}
			
		public function removeTabItem (io:InteractiveObject):void
		{
			for (var key:Object in _hash )
			{
				var cat:Array = _hash[key] as Array;
				if (cat)
				{
					var existingIndex:int = cat.indexOf (io);
					if (existingIndex != -1)
						cat.splice (existingIndex, 1);
				}
			}
		}
		
		public function removeTabItemFromCategory (category:Object, io:InteractiveObject):void
		{
			var cat:Array = _hash[category] as Array;
			if (cat)
			{
				var existingIndex:int = cat.indexOf (io);
				if (existingIndex != -1)
					cat.splice (existingIndex, 1);
			}
		}
		
		public function removeCategory (category:Object):void
		{
			_hash[category] = null;
		}
		
		public function cleanup ():void
		{
			for (var k:Object in _hash )
			{
				var key:Array = k as Array;
				if (key)
				{
					for (var i:int = key.length - 1; i >= 0; i--)
					{
						if (key[i] == null)
						{
							key.splice (i, 1);
						}
					}
				}
			}
		}
		
		public function get activeCategory ():Object { return _activeCategory; }
		
		public function set activeCategory (category:Object):void
		{
			if (exists(category))
			{
				if (category != _activeCategory)
				{
					deactivate (_activeCategory);
					activate (category);
				}
			}
			else
			{
				trace ('Category does not exist:', category);
			}
		}
		
		private function deactivate (category:Object):void
		{
			if (_activeCategory == category) _activeCategory = null;

			if (category)
			{
				var cat:Array = _hash[category] as Array;
				if (cat)
				{
					for (var i:int = 0; i < cat.length; ++i)
					{
						var io:InteractiveObject = cat[i];
						if (io)
						{
							io.tabEnabled = false;
						}
					}
				}
			}
		}
		
		private function activate (category:Object):void
		{
			_activeCategory = category;
			
			if (category)
			{
				var cat:Array = _hash[category] as Array;
				if (cat)
				{
					for (var i:int = 0; i < cat.length; ++i)
					{
						var io:InteractiveObject = cat[i];
						try
						{
							//io.stage.focus = io;
						}
						catch (e:Error)
						{
							// Fail quietly
						}
						if (io)
						{
							io.tabEnabled = true;
						}
					}
				}
			}
		}
		
		private function updateTabOrder (category:Object):void
		{
			if (category)
			{
				var cat:Array = _hash[category] as Array;
				if (cat)
				{
					for (var i:int = 0; i < cat.length; ++i)
					{
						var io:InteractiveObject = cat[i];
						io.tabIndex = i;
					}
				}
			}
		}
		
		private function exists (category:Object):Boolean
		{
			return (_hash[category] == null) ? false : true;
		}
		
	}
}

internal class SingletonEnforcer
{
	public function SingletonEnforcer ()
	{
		// there can be only one
	}
}