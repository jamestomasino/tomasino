package org.tomasino.net.vo
{
	public class CuePointVO
	{
		public var next:CuePointVO;
		public var prev:CuePointVO;
		public var name:String;
		public var parameters:Object;
		public var time:Number;
		public var type:String;
		
		public function CuePointVO(time:Number = 0, name:String = '', type:String = '', parameters:Object = null, prev:CuePointVO = null)
		{
			this.time = time;
			this.name = name;
			this.type = type;

			this.parameters = parameters;

			if (prev)
			{
				this.prev = prev;

				if (prev.next) 
				{
					prev.next.prev = this;
					this.next = prev.next;
				}

				prev.next = this;
			}

		}
		
		public function toString ():String
		{
			var returnstr:String = '[CuePointVo time:' + time + ' name:' + name + ' type:' + type + ']';
			return returnstr;
		}
	}
}

