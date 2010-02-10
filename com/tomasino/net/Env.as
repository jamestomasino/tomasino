package com.tomasino.net
{
	import com.tomasino.logging.Logger;
	
	import flash.display.*;
	import flash.net.URLVariables;
	
	public class Env
	{
		private static const SCHEME_FILE:String = "file";
		private static const SCHEME_FTP:String = "ftp";
        private static const SCHEME_HTTP:String = "http";
        private static const SCHEME_HTTPS:String = "https";
        private static const SCHEME_UNKNOWN:String = "unknown";
        private static const schemeValues:Array = new Array( SCHEME_FILE, SCHEME_FTP, SCHEME_HTTP, SCHEME_HTTPS );

		public static const ENV_LOCAL:String = "LOCAL";
		public static const ENV_DEV :String = "DEV";
        public static const ENV_STAGE:String = "STAGE";
        public static const ENV_PREPROD:String = "PREPROD";
        public static const ENV_PROD:String = "PROD";
		
		private static var _localEnvironments:Array = ["://localhost","file://","http:///C:/"];
		private static var _devEnvironments:Array = ["://dev.","://dev-"];
		private static var _stageEnvironments:Array = ["://stage.","://stage-", "://gpt-"];
		private static var _preprodEnvironments:Array = ["://preprod.","://preprod-"];
		
		private var _appUrl:String = "";
		private var urlRegex:RegExp = new RegExp("^(([^:/\\?#]+):)?(//([^/\\?#:]*))?(:(\\d+))?([^\\?#]*)(\\?([^#]*))?(#(.*))?");
		
		private var _scheme:String;
		private var _host:String;
		private var _port:int = 80;
		private var _path:String;
		private var _variables:URLVariables;
		private var _anchor:String;
		
		public static var log:Logger = new Logger ('com.tomasino.net::Env');
		/*
		* Usage:
		* var myEnv:Env = new Env(_root._url); //default url, or
		* var myEnv:Env = new Env("http://stage.site.com:8080/afolder/afile.html?var1=123&var2=234&var3=abc#reg"); // pass any url for which you need environment info
		* trace(myEnv.getEnvironment()); // STAGE
		* trace(myEnv.Scheme); // http
		* trace(myEnv.Host); // stage.site.com
		* trace(myEnv.Port); // 8080
		* trace(myEnv.Path); // /afolder/afile.html
		* trace(myEnv.Variables); // {var1=123, var2=234, var3=abc}
		* trace(myEnv.Anchor); // #reg
		* trace(myEnv.IsSecure); // false
		* trace(myEnv.getBaseUrl()); // http://stage.site.com:8080/
		*/
		public function Env (appUrl:String)
		{
			this._appUrl = (appUrl);
			if (this._appUrl == null)
			{
				Env.log.warn ('Env - appUrl is null, cannot set env');
				return;
			}
			var result:Object = urlRegex.exec(this._appUrl);
			
			if (schemeValues.indexOf (result[2]) == -1)
			{
				this._scheme = SCHEME_UNKNOWN;
			}
			else
			{
				this._scheme = result[2];
			}
			
			this._host= (result[4]==null?"":result[4]);
			this._port = (result[6]==null?80:result[6]);
			this._path = (result[7]==null?"":result[7]);
			this._variables = new URLVariables();
			if (result[8] != null)
			{
				_variables.decode(result[8]);
			}
			this._anchor = (result[11]==null?"":result[11]);
		}
		
		public function isSecure ():Boolean
		{
			return (SCHEME_HTTPS == this._scheme);
		}
		
		public function getEnvironment ():String
		{
			var lowerAppUrl:String = this._appUrl.toLowerCase();
			var envTest:String;
			for each(envTest in _localEnvironments)
			{
				if(lowerAppUrl.indexOf(envTest) != -1)
				{
					return ENV_LOCAL;
				}
			}
			
			for each(envTest in _devEnvironments)
			{
				if(lowerAppUrl.indexOf(envTest) != -1)
				{
					return ENV_DEV;
				}
			}
			
			for each(envTest in _stageEnvironments)
			{
				if(lowerAppUrl.indexOf(envTest) != -1)
				{
					return ENV_STAGE;
				}
			}
			
			for each(envTest in _preprodEnvironments)
			{
				if(lowerAppUrl.indexOf(envTest) != -1)
				{
					return ENV_PREPROD;
				}
			}
			
			return ENV_PROD;
		}
		
		public function getBaseUrl ():String
		{
			var url:String = this._scheme + "://" + this._host;
			if (_port != 80)
			{
				url += ":";
				url += this._port;
			}
			url += "/";
			return url;
		}
		
		public static function addEnvironmentPattern(pattern:String, environment:String):Boolean
		{
			var result:Boolean = false;
			
			switch(environment)
			{
				case ENV_LOCAL:
					_localEnvironments.push(pattern);
					result = true;
				break;
				
				case ENV_DEV:
					_devEnvironments.push(pattern);
					result = true;
				break;
				
				case ENV_STAGE:
					_stageEnvironments.push(pattern);
					result = true;
				break;
				
				case ENV_PREPROD:
					_preprodEnvironments.push(pattern);
					result = true;
				break;
			}
			
			Env.log.info ('addEnvironmentPattern - adding',pattern,'to',environment,'--',result);
			
			return result;
		}
		
		public function toString ():String
		{
			var str:String = "URL: " + this._appUrl;
			str += " ENVIRONMENT: " + this.getEnvironment();
			str += " SCHEME: " + this._scheme;
			str += " HOST: " + this._host;
			str += " PORT: " + this._port;
			str += " PATH: " + this._path;
			str += " VARIABLES: " + this._variables;
			str += " ANCHOR: " + this._anchor;
			return str;
		}
		
		/* GETTERS/SETTERS */
		public function get scheme ():String
		{
			return _scheme;
		}
		
		public function get host ():String
		{
			return _host;
		}
		
		public function get port ():Number
		{
			return _port;
		}
		
		public function get path ():String
		{
			return _path;
		}
		
		public function get variables ():URLVariables
		{
			return _variables;
		}
		
		public function get anchor ():String
		{
			return _anchor;
		}
	}
}
