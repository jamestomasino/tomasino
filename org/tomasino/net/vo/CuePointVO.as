package org.tomasino.net.vo
{
	public class CuePointVO
	{
		public var name:String;
		public var parameters:Object;
		public var time:Number;
		public var type:String;
		
		public function CuePointVO(time:Number = 0, name:String = '', type:String = '', parameters:Object = null)
		{
			this.time = time;
			this.name = name;
			this.type = type;
			this.parameters = parameters;
		}
		
		public function toString ():String
		{
			var returnstr:String = '[CuePointVo time:' + time + ' name:' + name + ' type:' + type + ']';
			return returnstr;
		}
	}
}