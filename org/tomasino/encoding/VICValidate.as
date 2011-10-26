package org.tomasino.encoding
{
	public class VICValidate 
	{
		public static var standardRegExp:RegExp = /[^A-Za-z0-9]/g;
		public static var messageRegExp:RegExp = /[^A-Za-z0-9\.]/g;	
		
		public static function decode(song:String,code:String,personalID:String,date:Date):Boolean
		{
			var valid:Boolean = true;
			valid &&= validateSong(song);
			valid &&= validateMessage(code);
			valid &&= validatePersonalID(personalID);
			valid &&= validateDate(date);
			
			return valid;
		}		
		public static function encode(song:String,message:String,MI:String,personalID:String,date:Date):Boolean
		{
			var valid:Boolean = true;
			valid &&= validateSong(song);
			valid &&= validateMessage(message);
			valid &&= validateMI(MI);
			valid &&= validatePersonalID(personalID);
			valid &&= validateDate(date);
			
			return valid;
		}
		
		private static function validateSong (song:String):Boolean
		{
			var _s = song;
			_s = _s.replace(standardRegExp,'');
			if (_s.length >= 20) return true;
			
			return false;
		}
		
		private static function validateMessage (message:String):Boolean
		{
			var _msg = message;
			_msg = _msg.replace(messageRegExp, '');
			if (_msg.length) return true;
			
			return false;
		}
		
		private static function validateMI (MI:String):Boolean
		{
			var _mi = MI;
			if (_mi.length != 5) return false;
			
			return true;
		}
		
		private static function validatePersonalID (personalID:String):Boolean
		{
			var _pid = personalID;
			if (int(_pid) < 0||int(_pid) > 16) 
				return false;
		
			return true;
		}
		
		private static function validateDate (date:Date):Boolean
		{
			if (date) return true;
			return false;
		}			
		
	}
	
}