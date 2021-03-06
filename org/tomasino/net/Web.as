﻿package org.tomasino.net
{
	import org.tomasino.external.Availability;
	import org.tomasino.logging.Logger;
	
    import flash.net.navigateToURL;
    import flash.net.URLRequest;
	import flash.external.ExternalInterface;
	
    public class Web
    {
		private static var _log:Logger = new Logger ('org.tomasino.net.Web');
		private static const WINDOW_OPEN_FUNCTION : String = "window.open";
		private static var _available:Boolean = Availability.available;
		
        public static function getURL(url:String, window:String = "_self"):void
        {
            var req:URLRequest = new URLRequest(url);
			_log.info ('getURL - ' + url);

			try
            {
                    navigateToURL(req, window);
            }
            catch (e:Error)
            {
                _log.error ('Navigate to URL failed: ', e.message);
            }
        }
		
		public static function openWindow (url:String, window:String = "_blank", features:Object = null) : void
		{
			var featureString:String;
			if (features is PopupFeatures)
			{
				featureString = PopupFeatures(features).toString ();
			}
			else
			{
				var popupFeatures:PopupFeatures = new PopupFeatures (features);
				featureString = popupFeatures.toString ();
			}
			
            if (_available)
			{
				ExternalInterface.call (WINDOW_OPEN_FUNCTION, url, window, featureString);
			}
			else
			{
				_log.warn ('Navigate surprssed due to environment -', url);
			}
        }
    }
}