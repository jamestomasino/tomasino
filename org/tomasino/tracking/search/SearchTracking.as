package org.tomasino.tracking.search
{
	import org.tomasino.logging.Logger;
	
	import flash.display.Sprite;
	import flash.errors.IllegalOperationError;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.net.sendToURL;
	
	public class SearchTracking
	{	
		private static var _log:Logger = new Logger ('org.tomasino.tracking.search.SearchTracking');
		
		public function SearchTracking():void
		{
			throw new IllegalOperationError("Error: Instantiation failed: This is a static class.");
		}
		
		/*
		* 
		* @param site    Describes the site
		* @param page	 Describes page or button information that was accessed
		*     
		*/		
		
		public static function TrackClick(vars:Array, _idc:Number, _lead:Number):void
		{
            var url:String = "http://track.polenord.net/transform.php";
            var variables:URLVariables = new URLVariables();
            
            for(var i:int = 0; i < vars.length; ++i)
            {
            	if (vars[i]) variables['var'+(i + 1)] = vars[i];
            }
            
            variables.idc = _idc;
            variables.lead = _lead;
            
            var request:URLRequest = new URLRequest(url);
            request.data = variables;
			request.method = URLRequestMethod.GET;			
			_log.info ("TrackClick -", "sendToURL: " + request.url + "?" + request.data);
            try 
			{
                sendToURL(request);
            }
            catch (e:Error) 
			{
				_log.error("TrackClick -", "sendToURL FAILED")
            }
		}
	}
}
