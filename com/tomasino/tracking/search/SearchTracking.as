/*
* Author: Daniel Nedelcu
* Date: 02-05-2009
*
*
* CHANGELOG:
*	     02-05-2009 DN Created class
*		 02-12-2009 JT Changing traces to use Debug
*/

package com.tomasino.tracking.search
{
	import com.tomasino.utils.Debug;
	
	import flash.display.Sprite;
	import flash.errors.IllegalOperationError;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.net.sendToURL;
	
	public class SearchTracking
	{	
	
		private static var _debug:Boolean;
		public static function get debug():Boolean {return _debug;}
		public static function set debug(value:Boolean):void {_debug = value;}
		
		
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
            if (_debug) Debug.out('SearchTracking::TrackClick', "sendToURL: " + request.url + "?" + request.data);
            try 
			{
                sendToURL(request);
            }
            catch (e:Error) 
			{
				if (_debug) Debug.out('SearchTracking::TrackClick', 'sendToURL FAILED')
            }
		}
	}
}
