package com.tomasino.flex.ui{
    import flash.display.Bitmap;
    import flash.display.Loader;
    import flash.events.Event;
    import flash.system.LoaderContext;
    
    import mx.controls.Image;
    import mx.core.mx_internal;
    
    use namespace mx_internal;
    
    public class SmoothImage extends Image {
        
        public var smoothing:Boolean = false;
        public var checkPolicyFile:Boolean = false;
        
        public function SmoothImage():void {
            super();
            
			if(checkPolicyFile)
			{
				var context:LoaderContext = new LoaderContext();
				context.checkPolicyFile = true;
				this.loaderContext = context;
			}
        }
        
        override mx_internal function contentLoaderInfo_completeEventHandler(event:Event):void {
        	
        	if(smoothing)
        	{
        		try
        		{
            		var smoothLoader:Loader = event.target.loader as Loader;
            		var smoothImage:Bitmap = smoothLoader.content as Bitmap;
            		smoothImage.smoothing = true;
          		}
          		catch(error:Error)
          		{
          			trace('SmoothImage::contentLoaderInfo_completeEventHandler -- Cannot add smoothing to image due to security sandbox violation.  Check the crossdomain.xml file.');
          		}
            }
            
            super.contentLoaderInfo_completeEventHandler(event);
        }
        
    }
}
