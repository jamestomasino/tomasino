﻿package org.tomasino.data
{
	import flash.utils.ByteArray;

	public class ByteArrayClone
	{
		public function ByteArrayClone()
		{
			//Constructor
		}

		public static function clone(source:Object):*
		{
			var cloneWork:ByteArray = new ByteArray();
			cloneWork.writeObject(source);
			cloneWork.position = 0;
			return (cloneWork.readObject());
		}
	}
}