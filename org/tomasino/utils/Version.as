﻿package org.tomasino.utils
{
	import flash.utils.getDefinitionByName;
	import flash.system.Capabilities;
	
	public class Version
	{
		static private var _majorFlashVersion:int;
		static private var _minorFlashVersion:int;
		static private var _buildFlashVersion:int;
		static private var _compileFlashVersion:int;
		
		static private function calculateVersions ():void
		{
			var pattern:RegExp = /^(\w*) (\d*),(\d*),(\d*),(\d*)$/;
			var result:Object = pattern.exec(Capabilities.version);
			_majorFlashVersion = parseInt (result[2]);
			_minorFlashVersion = parseInt (result[3]);
			_buildFlashVersion = parseInt (result[4]);
			
			try
			{
				if (flash.utils.getDefinitionByName ("flash.net.NetStreamInfo") != null)
				{
					_compileFlashVersion = 10;
				}
			}
			catch (error:Error)
			{
			}
			
			if (_compileFlashVersion == 0)
			{
				_compileFlashVersion = 9;
			}
		}
		
		static public function isFlash10 ():Boolean
		{
			if (_majorFlashVersion == 0) calculateVersions ();
			
			return (10 <= _majorFlashVersion);
		}
		
		static public function isFlash10Compiled ():Boolean
		{
			if (_compileFlashVersion == 0) calculateVersions ();
			
			return (10 <= _compileFlashVersion);
		}
		
		static public function get MAJOR_FLASH_VERSION ():int
		{
			if (_majorFlashVersion == 0) calculateVersions ();
			return _majorFlashVersion;
		}
		
		static public function get MINOR_FLASH_VERSION ():int
		{
			if (_majorFlashVersion == 0) calculateVersions ();
			return _minorFlashVersion;
		}
		
		static public function get BUILD_FLASH_VERSION ():int
		{
			if (_majorFlashVersion == 0) calculateVersions ();
			return _buildFlashVersion;
		}
		
		static public function get COMPILE_FLASH_VERSION ():int
		{
			if (_compileFlashVersion == 0) calculateVersions ();
			return _compileFlashVersion;
		}
	}
}
		