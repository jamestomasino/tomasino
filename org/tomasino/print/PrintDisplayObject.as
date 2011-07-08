package org.tomasino.print
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.printing.*;
	
	public class PrintDisplayObject extends Sprite
	{
		// Might need these one day when this class gets bigger
		public static const SCREEN_TO_PRINT:Number = 300 / 72;
		public static const PRINT_TO_SCREEN:Number = 72 / 300;
		
		public function PrintDisplayObject ()
		{
			super ();
		}
		
		public function print ( disp:DisplayObject, scale:Boolean = true ):void
		{
			if (this.parent)
			{
				var myPrintJob:PrintJob = new PrintJob ();
				var myPrintOptions:PrintJobOptions = new PrintJobOptions (true);
				var result:Boolean = myPrintJob.start ();
				var printArea:Sprite = new Sprite ();
				
				// Create Print Area
				printArea.addChild (disp);
				printArea.x = 5000;
				addChild (printArea);
				
				// Rotate for best fit on page, scale to fill paper
				if (myPrintJob.orientation == PrintJobOrientation.PORTRAIT)
				{
					if (printArea.width > printArea.height)
					{
						printArea.rotation = -90;
						if (scale)
						{
							printArea.height = myPrintJob.pageHeight;
							printArea.scaleX = printArea.scaleY;
						}
					}
					else
					{
						if (scale)
						{
							printArea.height = myPrintJob.pageHeight;
							printArea.scaleX = printArea.scaleY;
						}
					}
					
				}
				else
				{
					if (printArea.width > printArea.height)
					{
						if (scale)
						{
							printArea.width = myPrintJob.pageWidth
							printArea.scaleY = printArea.scaleX;
						}
					}
					else
					{
						printArea.rotation = -90;
						if (scale)
						{
							printArea.width = myPrintJob.pageWidth;
							printArea.scaleY = printArea.scaleX;
						}
					}
					
				}
				
				// Print
				myPrintJob.addPage (printArea, null, myPrintOptions);
				myPrintJob.send ();
				myPrintJob = null;
				
				// Cleanup
				printArea.removeChild (disp);
				removeChild (printArea);
				printArea = null;
				this.parent.removeChild (this);
			}
			else
			{
				throw new Error ('PrintDisplayObject must be in the display list to call print() method.');
			}
		}
	}
}