﻿package org.tomasino.tracking.omniture
{
	/* Required: ActionSource.swc
	* You can find this by going to the Admin Console in SiteCatalyst. 
	* You will find this under the Code Manager.
	*/
	import com.omniture.ActionSource;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.net.navigateToURL;
    import flash.net.URLRequest;
	
	public class OmnitureTracker extends Sprite
	{
		public var settings:OmnitureSettings;
		
		private var _actionSource:ActionSource;
		private var _stage:Stage;
		
		// For Exit links
		private var _timer:Timer;
		private var _exitLink:String;
		private var _exitWindow:String = '_self';
		
		public function OmnitureTracker ():void
		{
			_actionSource = new ActionSource();
			settings = new OmnitureSettings(_actionSource);
			
			if (this.stage)
			{
				init();
			}
			else
			{
				addEventListener (Event.ADDED_TO_STAGE, init);
			}
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			_log.info ('Starting Omniture Tracker');
			
			addChild(_actionSource);
			stage.addEventListener (OmnitureEvent.TRACK, onTrack);
		}
		
		public function track (e:OmnitureEvent):void
		{
			onTrack (e);
		}
		
		private function onTrack(e:OmnitureEvent):void
		{
			_log.info ('onTrack');
			
			if (settings.account)
			{
				var data:OmnitureTrackData = e.data;
				
				_actionSource.clearVars();
				
				_actionSource.pageName = data.pageName;
				_actionSource.pageURL = data.pageURL;
				_actionSource.referrer = data.referrer;
				_actionSource.purchaseID = data.purchaseID;
				_actionSource.transactionID = data.transactionID;
				_actionSource.channel = data.channel;
				_actionSource.server = data.server;
				_actionSource.pageType = data.pageType;
				_actionSource.vistorID = data.visitorID;
				_actionSource.variableProvider = data.variableProvider;
				_actionSource.campaign = data.campaign;
				_actionSource.state = data.state;
				_actionSource.zip = data.zip;
				
				for (var i:int = 1; i < data.props.length; ++i)
				{
					_actionSource['prop' + i] = data.props[i];
				}
				
				for (i = 1; i < data.heirs.length; ++i)
				{
					_actionSource['hier' + i] = data.heirs[i];
				}
				
				for (i = 1; i < data.evars.length; ++i)
				{
					_actionSource['eVar' + i] = data.evars[i];
				}
				
				// Products
				var products:String;
				for (i = 0; i < data.products.length; ++i)
				{
					var product:OmnitureProduct = data.products[i] as OmnitureProduct;
					if (product)
					{
						if (products)
							products += ',' + product.toString ();
						else
							products = product.toString ();
					}
				}
				if (products) _actionSource.products = products;
				
				// Events
				_actionSource.events = (data.events != null && data.events.length != 0 ? data.events.toString() : "");
				
				if (data.pageName)
				{
					_actionSource.track();
				}
				else
				{
					// TrackLink
					var url:String = (data.linkURL) ? data.linkURL : this.stage.loaderInfo.url;
					var type:String = data.type || OmnitureTrackData.TYPE_CUSTOM_LINK;
					var name:String = (data.linkName) ? data.linkName : '';
					
					_actionSource.trackLink ( url, type, name );
					
					if (data.type == OmnitureTrackData.TYPE_EXIT_LINK || data.type == OmnitureTrackData.TYPE_FILE_DOWNLOAD || (url != this.stage.loaderInfo.url))
					{
						_timer = new Timer ( settings.delayTracking + 100, 1);
						_timer.addEventListener (TimerEvent.TIMER_COMPLETE, onExitTimer);
						_exitLink = data.linkURL;
						_exitWindow = data.linkWindow || '_self';
						_timer.start();
					}
				}
			}
			else
			{
				throw new IllegalOperationError('OmnitureTracker Failed to Track - Missing Account Name in OmnitureSettings');
			}
		}
		
		private function onExitTimer(e:TimerEvent):void
		{
			var req:URLRequest = new URLRequest(_exitLink);
            try
            {
                    navigateToURL(req, _exitWindow);
            }
            catch (e:Error)
            {
                   trace ('OmnitureTracker::Navigate to URL failed: ', e.message);
            }
		}
		
	}
}
