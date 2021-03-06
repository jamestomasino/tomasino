﻿package org.tomasino.net
{
	import org.tomasino.logging.Logger;
	
	public class Env extends URI
	{
		public static const ENV_LOCAL:String = 'LOCAL';
		public static const ENV_TEST :String = 'TEST';
        public static const ENV_STAGE:String = 'STAGE';
        public static const ENV_PREPROD:String = 'PREPROD';
        public static const ENV_PROD:String = 'PROD';
		
		private static var _localEnvironments:Array = ['://localhost','file://','http:///C:/','.local'];
		private static var _testEnvironments:Array = ['://test'];
		private static var _stageEnvironments:Array = ['://stage'];
		private static var _preprodEnvironments:Array = ['://preprod'];
		
		public static var log:Logger = new Logger ('org.tomasino.net::Env');
		
		public function Env (value:String)
		{
			super (value);
		}
		
		public function isSecure ():Boolean
		{
			return (SchemeType.HTTPS == _scheme);
		}
		
		public function getEnvironment ():String
		{
			var lowerAppUrl:String = _uri.toLowerCase ();
			
			var envTest:String;
			for each(envTest in _localEnvironments)
			{
				if(lowerAppUrl.indexOf(envTest) != -1)
				{
					return ENV_LOCAL;
				}
			}
			
			for each(envTest in _testEnvironments)
			{
				if(lowerAppUrl.indexOf(envTest) != -1)
				{
					return ENV_TEST;
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
		
		public static function addEnvironmentPattern(pattern:String, environment:String):Boolean
		{
			var result:Boolean = false;
			
			switch(environment)
			{
				case ENV_LOCAL:
					_localEnvironments.push(pattern);
					result = true;
				break;
				
				case ENV_TEST:
					_testEnvironments.push(pattern);
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
		
		override public function toString ():String
		{
			var str:String = '[Env';
			str += ' url:"' + _uri;
			str += '" environment:"' + getEnvironment();
			str += '" scheme:"' + scheme;
			str += '" host:"' + host;
			str += '" port:"' + port;
			str += '" path:"' + path;
			str += '" variables:"' + variables;
			str += '" anchor:"' + anchor;
			str += '"]';
			return str;
		}
	}
}
