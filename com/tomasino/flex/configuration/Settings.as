package com.tomasino.flex.configuration
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.core.Application;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;

 	[Event(name="result", type="mx.rpc.events.ResultEvent")]
	[Event(name="fault", type="mx.rpc.events.FaultEvent")]

  	public class Settings {

    		public static const LOCAL:String = "LOCAL";
			public static const STAGE:String = "STAGE";
			public static const PREPROD:String = "PREPROD";
			public static const PROD:String = "PROD";

    		protected static var dispatcher:EventDispatcher;

    		private static var _settings:XML;
    		private static var _environment:String;


    		/*
    			Event dispatching methods
    			Best way to dispatch events from static classess
    		*/
    		public static function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void {
      			if (dispatcher == null) { dispatcher = new EventDispatcher(); }
      			dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
      		}
    		public static function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void {
      			if (dispatcher == null) { return; }
      			dispatcher.removeEventListener(type, listener, useCapture);
      		}
    		public static function dispatchEvent(event:Event):void {
      			if (dispatcher == null) { return; }
      			dispatcher.dispatchEvent(event);
      		}


    		/*
    			Loads the settings file
    		*/
	  		public static function load(url:String = "settings.xml"):void
			{
				var service:HTTPService = new HTTPService();
				service.resultFormat = "e4x";
				service.url = url;
				service.method = "GET";
				service.makeObjectsBindable = true;
				service.addEventListener(ResultEvent.RESULT,load_result);
				service.addEventListener(FaultEvent.FAULT,dispatchEvent);
				service.send();
			}
			
			/*
    			Handles result event of settings being loaded
    		*/
			private static function load_result(e:ResultEvent):void
			{
				_settings = XML(e.result); // store our settings xml
				dispatchEvent(e); // dispatch the result event
			}
			
			/*
    			Analyzises the url of the current swf and returns the corresponding constant value
    		*/
			public static function get environment():String
			{
				if(!_environment){
			
					var url:String = Application.application.url;
					if(!url)throw(new Error("Properties of the Environment class can only be used after the creation complete even has fired."));
					if(url.search("file:///") > -1 || url.search("//localhost") > -1 || url.search("//local.") > -1){
						_environment = LOCAL;
					}else if(url.search("//stage.") > -1){
						_environment = STAGE;
					}else if(url.search("//preprod.") > -1){
						_environment = PREPROD;
					}else{
						_environment = PROD;
					}
				}
				return _environment;
			}
			
			/*
    			Returns the settings xml
    		*/
			public static function get settings():XML
			{
				return _settings;
			}
			
			/*
    			Returns a property nodes value attribute based on environment
				First it looks in the corresponding environment node then
				moves up to the global space if not found
    		*/
			public static function getProperty(name:String):String
			{
				var value:String;
				try{
					value = _settings.Environmental[environment].Property.(@name == name).@value;
					if(value.length == 0)value = _settings.Global.Property.(@name == name).@value;
				}catch(e:Error)
				{
					value = _settings.Global.Property.(@name == name).@value;
				}
				return value;
			}
			
			/*
    			Returns a single node from the settings file based on environment
				First it looks in the corresponding environment node then
				moves up to the global space if not found
				
				By only allowing single node selection we force good policies
				of containing list items in a named parent element
				
				Example: If we want to get all template nodes first we specify the templates node
				
				<Templates>
					<Template />
				</Template>
				
				
    		*/
			public static function getNode(name:String):XML
			{
				var xml:XML;
				try
				{
					xml = _settings.Environmental[environment].descendants(name)[0];
					if(xml == null)xml = _settings.Global.descendants(name)[0];
				}
				catch(e:Error)
				{
					xml = _settings.Global.descendants(name)[0];
				}
				return xml;
			}
			
			
    }
}
