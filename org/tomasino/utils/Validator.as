﻿package org.tomasino.utils
{ 
	public class Validator
	{
		public static const EMAIL:String = 'email';
		public static const STRING:String = 'string';
		public static const PHONE:String = 'phone';
		public static const ZIPCODE:String = 'zipcode';
		
		public static var emailExpression:RegExp = new RegExp('^[A-Z0-9\!\#\$\%\&\'\*\+\-\/\=\?\\^\_\`\.\{\|\}\~]{1,64}@([A-Z0-9-]{1,63})\.{1,}[A-Z0-9]{2,6}$','i');
		public static var phoneExpression:RegExp = /^(1\s*[-\/\.]?)?(\((\d{3})\)|(\d{3}))\s*[-\/\.]?\s*(\d{3})\s*[-\/\.]?\s*(\d{4})\s*(([xX]|[eE][xX][tT])\.?\s*(\d+))*$/;
		public static var zipExpression:RegExp = /^[0-9]{5}([- \/]?[0-9]{4})?$/
		
		static public function validate(value:String, type:String):Boolean
		{
			switch(type)
			{
				case EMAIL:
					return email(value);
				break;
				
				case STRING:
					return string(value);
				break;
				
				case PHONE:
					return phone(value);
				break;
				
				case ZIPCODE:
					return zipCode(value);
				break;
			}
			
			return false;
		}
		
		static public function email(value:String):Boolean
		{
			return emailExpression.test(value);
		}
		
		static public function string(value:String):Boolean
		{
			if(value.length > 0){
				return true;
			}else{
				return false;
			}
		}
		
		static public function phone(value:String):Boolean
		{
			return phoneExpression.test(value);
		}
		
		static public function zipCode(value:String):Boolean
		{
			return zipExpression.test(value);
		}
	}
}
