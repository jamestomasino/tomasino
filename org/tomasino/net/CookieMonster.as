﻿package org.tomasino.net
{
	import org.tomasino.external.Availability;
	import flash.external.ExternalInterface;
	
	public class CookieMonster
	{
		private static var write_cookie:String = 'function Set_Cookie( name, value, expires, path, domain, secure ) { var today = new Date(); today.setTime( today.getTime() ); if ( expires ) { expires = expires * 1000 * 60 * 60 * 24; } var expires_date = new Date( today.getTime() + (expires) ); document.cookie = name + "=" +escape( value ) + ( ( expires ) ? ";expires=" + expires_date.toGMTString() : "" ) + ( ( path ) ? ";path=" + path : "" ) + ( ( domain ) ? ";domain=" + domain : "" ) + ( ( secure ) ? ";secure" : "" ); }';
		private static var get_cookie:String = 'function Get_Cookie( name ) { var start = document.cookie.indexOf( name + "=" ); var len = start + name.length + 1; if ( ( !start ) && ( name != document.cookie.substring( 0, name.length ) ) ) { return null; } if ( start == -1 ) return null; var end = document.cookie.indexOf( ";", len ); if ( end == -1 ) end = document.cookie.length; return unescape( document.cookie.substring( len, end ) ); }';
		private static var _availability:Boolean = Availability.available;
				
		public static function setCookie (name:String, value:String, expires:Date = null, path:String = null, domain:String = null, secure:Boolean = false):void
		{
			if (_availability) ExternalInterface.call (write_cookie, name, value, expires, path, domain, secure);
		}
		
		public static function getCookie (name:String):String
		{
			var returnObj:String;
			if (_availability) returnObj = ExternalInterface.call(get_cookie, name);
			return returnObj;
		}
		
		public static function eatCookie ():String
		{
			return 'Om Nom nom nom';
		}
	}
}
