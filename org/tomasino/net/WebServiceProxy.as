﻿package org.tomasino.net
{
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	
	import mx.messaging.messages.HTTPRequestMessage;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	public dynamic class WebServiceProxy extends Proxy {
		
		public var serviceURL:String;
		public var httpMethod:String = HTTPRequestMessage.POST_METHOD;
		
		private var methodContainer:Object;
	
	    public function WebServiceProxy() {
	       methodContainer = new Object();
	    }
	
	    override flash_proxy function callProperty(methodName:*, ... args):* {
	        callServiceMethod(methodName,args[0]);
	    }
	    
	    override flash_proxy function getProperty(name:*):* {
	        return methodContainer[name];
	    }
	
	    override flash_proxy function setProperty(name:*, value:*):void {
	        methodContainer[name] = value;
	    }
	    
	    private function callServiceMethod(methodName:String,params:Object = null):void{
			var service:HTTPService = new HTTPService();
			service.method = httpMethod;
			service.url = serviceURL + methodName;
			if(this[methodName+"_Result"])
				service.addEventListener(ResultEvent.RESULT,this[methodName+"_Result"]);
			if(this[methodName+"_Fault"])
				service.addEventListener(FaultEvent.FAULT,this[methodName+"_Fault"]);
			service.send(params);
		}

	}

}
