package org.tomasino.video
{
    import org.tomasino.logging.*;

    import fl.video.FLVPlayback;
    import fl.video.VideoPlayer;
    import fl.video.flvplayback_internal;

    import flash.events.TimerEvent;
    import flash.net.NetConnection;

    use namespace flvplayback_internal;

    public class FLVPlayback2 extends FLVPlayback
    {
		private var _log:Logger = new Logger ('org.tomasino.video.FLVPlayback2');
		
        public function FLVPlayback2()
        {
            super();
        }

        public function dispose():void
        {
            // stop the video
            stop();

            // kill the timers
            if( skinShowTimer )
            {
                skinShowTimer.stop();
                skinShowTimer.removeEventListener(TimerEvent.TIMER, showSkinNow);
            }
            if( uiMgr )
            {
                uiMgr._volumeBarTimer.reset();
                uiMgr._bufferingDelayTimer.reset();
                uiMgr._seekBarTimer.reset();
                uiMgr._skinAutoHideTimer.reset();
                uiMgr._skinFadingTimer.reset();

                uiMgr._seekBarTimer.removeEventListener(TimerEvent.TIMER, uiMgr.seekBarListener);
                uiMgr._volumeBarTimer.removeEventListener(TimerEvent.TIMER, uiMgr.volumeBarListener);
                uiMgr._bufferingDelayTimer.removeEventListener(TimerEvent.TIMER, uiMgr.doBufferingDelay);
                uiMgr._skinAutoHideTimer.removeEventListener(TimerEvent.TIMER, uiMgr.skinAutoHideHitTest);
                uiMgr._skinFadingTimer.removeEventListener(TimerEvent.TIMER, uiMgr.skinFadeMore);
            }

            // close the net connection
            // this kills all of the playback timers too
            for( var i:int = 0; i < videoPlayers.length; ++i )
            {
                var vp:VideoPlayer = getVideoPlayer(i);
              	try
              	{
	                vp.stop();
	                vp.close();
	                vp = null;
				}
				catch (e:Error)
				{
					_log.warn ('dispose - Video Stream Already Empty');
				}
            }
        }

        /**
         * The missing property to get the number of players in the component.
         *
         * @return Number of players in component
         *
         */
        public function get numPlayers ():Number
        {
        	return videoPlayers.length;
        }
    }
}
