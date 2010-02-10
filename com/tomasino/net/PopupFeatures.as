package com.tomasino.net
{
	public class PopupFeatures
	{
		public var status:Boolean = true;
		public var toolbar:Boolean = true;
		public var location:Boolean = true;
		public var menubar:Boolean = true;
		public var directories:Boolean = true;
		public var resizable:Boolean = true;
		public var scrollbars:Boolean = true;
		public var height:int = -1;
		public var width:int = -1;

		public function PopupFeatures (srcObj:Object = null)
		{
			if (srcObj)
			{
				for (var key:String in srcObj)
				{
					switch (key.toLowerCase())
					{
						case 'status':
							status = (String (srcObj[key]).toLowerCase () == 'true' || String (srcObj[key]) == '1' || srcObj[key] == true) ? true : false;
							break;
						case 'toolbar':
							toolbar = (String (srcObj[key]).toLowerCase () == 'true' || String (srcObj[key]) == '1' || srcObj[key] == true) ? true : false;
							break;
						case 'location':
							location = (String (srcObj[key]).toLowerCase () == 'true' || String (srcObj[key]) == '1' || srcObj[key] == true) ? true : false;
							break;
						case 'menubar':
							menubar = (String (srcObj[key]).toLowerCase () == 'true' || String (srcObj[key]) == '1' || srcObj[key] == true) ? true : false;
							break;
						case 'directories':
							directories = (String (srcObj[key]).toLowerCase () == 'true' || String (srcObj[key]) == '1' || srcObj[key] == true) ? true : false;
							break;
						case 'resizable':
							resizable = (String (srcObj[key]).toLowerCase () == 'true' || String (srcObj[key]) == '1' || srcObj[key] == true) ? true : false;
							break;
						case 'scrollbars':
							scrollbars = (String (srcObj[key]).toLowerCase () == 'true' || String (srcObj[key]) == '1' || srcObj[key] == true) ? true : false;
							break;
						case 'height':
							height = parseInt (srcObj[key]);
							break;
						case 'width':
							width = parseInt (srcObj[key]);
							break;
					}
				}
			}
		}
		
		public function toString ():String
		{
			var outputString:String = '';
			outputString += 'status=';
				outputString += (status) ? '1' : '0';
			outputString += ',toolbar=';
				outputString += (toolbar) ? '1' : '0';
			outputString += ',location=';
				outputString += (location) ? '1' : '0';
			outputString += ',menubar=';
				outputString += (menubar) ? '1' : '0';
			outputString += ',directories=';
				outputString += (directories) ? '1' : '0';
			outputString += ',resizable=';
				outputString += (resizable) ? '1' : '0';
			outputString += ',scrollbars=';
				outputString += (scrollbars) ? '1' : '0';
			outputString += (height >= 0) ? ',height=' + String (height) : '';
			outputString += (width >= 0) ? ',width=' + String (width) : '';

			return outputString;
		}
	}
}