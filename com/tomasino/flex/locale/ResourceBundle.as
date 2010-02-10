package com.tomasino.flex.locale
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	
	/**
	 * ResourceBundle - August 6, 2008
	 * Updated March 10, 2009
	 * The Resource Bundle class is a way to handle language translations in Flex, designed specifically to mimic other 
	 * localization implementations in other languages.  The class is a singleton, and loads in an xml that contains a series of 
	 * resource nodes.  Each node has an ID, which corresponds to the placeholder value that each locale string will replace.
	 * 
	 * UPDATE: The more correct syntax now is listed in the example using getString instead of the older resource getter.  This
	 * change was to remove the Flex Builder warning related to using array binding in expressions.  The old getter is still supported.
	 * 
	 * Example implementation: 
	 * MXML - <mx:Label text="{_resourceBundle.getString('title')}" color="#ffffff" />
	 * AS3 - BindingUtils.bindProperty(testLabel, "text", _resourceBundle, ["resource","title"]);
	 * 
	 * XML Example:
	 * <?xml version="1.0" encoding="UTF-8"?>
	 * <resources>
	 * 	<resource name="title"><![CDATA[Titre]]></resource>
	 * </resources>
	 */
	[Bindable]
	public class ResourceBundle
	{
		private static var instance:ResourceBundle;
		private var _loader:URLLoader;
		private var _assets:Dictionary = new Dictionary(true);
		
		public static const RESOURCE_LOADED:String = "resource_loaded";
		
		public function ResourceBundle(enforcer:SingletonEnforcer) {
			if (enforcer == null) {
				throw new Error( "You Can Only Have One ResourceBundle" );
			}
		}
		
		// Returns the Single Instance
		public static function getInstance() : ResourceBundle {
			if (instance == null) {
				instance = new ResourceBundle( new SingletonEnforcer );
			}
			return instance;
		}
		
		/**
		 * This method accepts a string, and loads in the resource xml file, files a ResourceBundle.RESOURCE_LOADED
		 * event upon completion, and updates all bindings.
		 */
		public function loadResource(fileLocation:String):void{
			_loader = new URLLoader();
			_loader.load(new URLRequest(fileLocation));
			_loader.addEventListener(Event.COMPLETE, onLoadComplete, false, 0, true);
		}
		
		private function onLoadComplete(evt:Event):void{
			_loader.removeEventListener(Event.COMPLETE, onLoadComplete);
			parseXML();
		}
		
		private function parseXML():void{
			var resources:XML = new XML(_loader.data);
			var resourceList:XMLList = resources.descendants('resource');
			for(var k:int = 0; k < resourceList.length(); k ++){
				var resourceNode:XML = resourceList[k];
				_assets[resourceNode.attribute('name').toString()] = resourceNode.toString();
			}
			resources = null;
			_loader = null;
			this.dispatchEvent(new Event("resourceUpdated"));
			this.dispatchEvent(new Event(ResourceBundle.RESOURCE_LOADED));
		}
		
		[Bindable(event="resourceUpdated")]
		public function getString(stringName:String):String{
			return _assets[stringName];
		}
		
		[Bindable(event="resourceUpdated")]
		public function get resource():Dictionary{
			return _assets;
		}

	}
}

class SingletonEnforcer {}
