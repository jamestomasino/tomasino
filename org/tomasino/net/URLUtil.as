﻿package org.tomasino.net
{

    import flash.external.ExternalInterface;

    public class URLUtil    {

        protected static const WINDOW_OPEN_FUNCTION : String = "window.open";


        /**
         * Opens a new window using ExternalInterface to call javascript window.open
         *
         * @param url The url to open in the new window
         * @param window The name of the window to target (defaults to "_blank")
         * @param features The window features to pass to the window.open
         *
         * The features parameter is a comma delimited string of features that
         * instructs window.open to open the new window. The string is formatted as follows:
         * <code>"menubar=1,resizable=1,width=350,height=250,location=1,status=1,scrollbars=1"</code>
         *
         * Available features are:
         * status  	The status bar at the bottom of the window.
         * toolbar 	The standard browser toolbar, with buttons such as Back and Forward.
         * location 	The Location entry field where you enter the URL.
         * menubar 	The menu bar of the window
         * directories 	The standard browser directory buttons, such as What's New and What's Cool
         * resizable 	Allow/Disallow the user to resize the window.
         * scrollbars 	Enable the scrollbars if the document is bigger than the window
         * height 	Specifies the height of the window in pixels. (example: height='350')
         * width 	Specifies the width of the window in pixels.
         *
         */
        public static function openWindow(url : String, window : String = "_blank", features : String = "") : void {
            ExternalInterface.call(WINDOW_OPEN_FUNCTION, url, window, features);
        }

    }

}