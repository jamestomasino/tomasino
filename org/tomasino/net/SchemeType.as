﻿package org.tomasino.net
{
	public class SchemeType
	{
		/* Official IANA-registered schemes */
		public static const AAA:String 				= 'aaa';
		public static const AAAS:String 			= 'aaas';
		public static const ACAP:String 			= 'acap';
		public static const CAP:String 				= 'cap';
		public static const CID:String 				= 'cid';
		public static const CRID:String 			= 'crid';
		public static const DATA:String 			= 'data';
		public static const DAV:String 				= 'dav';
		public static const DICT:String 			= 'dict';
		public static const DNS:String 				= 'dns';
		public static const FAX:String 				= 'fax';
		public static const FILE:String 			= 'file';
		public static const FTP:String 				= 'ftp';
		public static const GO:String 				= 'go';
		public static const GOPHER:String 			= 'gopher';
		public static const H323:String 			= 'h323';
		public static const HTTP:String 			= 'http';
		public static const HTTPS:String 			= 'https';
		public static const ICAP:String 			= 'icap';
		public static const IM:String 				= 'im';
		public static const IMAP:String 			= 'imap';
		public static const INFO:String 			= 'info';
		public static const IPP:String 				= 'ipp';
		public static const IRIS:String 			= 'iris';
		public static const IRIS_BEEP:String 			= 'iris.beep';
		public static const IRIS_XPC:String 			= 'iris.xpc';
		public static const IRIS_XPCS:String 			= 'iris.xpcs';
		public static const IRIS_LWS:String 			= 'iris.lws';
		public static const LDAP:String 			= 'ldap';
		public static const LSID:String 			= 'lsid';
		public static const MAILTO:String 			= 'mailto';
		public static const MID:String 				= 'mid';
		public static const MODEM:String 			= 'modem';
		public static const MSRP:String 			= 'msrp';
		public static const MSRPS:String 			= 'msrps';
		public static const MTQP:String 			= 'mtqp';
		public static const MUPDATE:String 			= 'mupdate';
		public static const NEWS:String 			= 'news';
		public static const NFS:String 				= 'nfs';
		public static const NNTP:String 			= 'nntp';
		public static const OPAQUELOCKTOKEN:String 		= 'opaquelocktoken';
		public static const POP:String 				= 'pop';
		public static const PRES:String 			= 'pres';
		public static const PROSPERO:String 			= 'prospero';
		public static const RTSPV:String 			= 'rtspv';
		public static const SERVICE:String 			= 'service';
		public static const SHTTP:String 			= 'shttp';
		public static const SIP:String 				= 'sip';
		public static const SIPS:String 			= 'sips';
		public static const SNMP:String 			= 'snmp';
		public static const SOAP_BEEP:String 			= 'soap.beep';
		public static const SOAP_BEEPS:String 			= 'soap.beeps';
		public static const TAG:String 				= 'tag';
		public static const TEL:String 				= 'tel';
		public static const TELNET:String 			= 'telnet';
		public static const TFTP:String 			= 'tftp';
		public static const THISMESSAGE:String 			= 'thismessage';
		public static const TIP:String 				= 'tip';
		public static const TV:String 				= 'tv';
		public static const URN:String 				= 'urn';
		public static const VENMI:String 			= 'vemmi';
		public static const WAIS:String 			= 'wais';
		public static const XMLRPC_BEEP:String 			= 'xmlrpc.beep';
		public static const XMPP:String 			= 'xmpp';
		public static const Z39_50R:String 			= 'z39.50r';
		public static const Z39_50S:String 			= 'z39.50s';

		/* Unofficial but common scheme types */
		public static const ABOUT:String 			= 'about';
		public static const ADIUMXTRA:String 			= 'adiumxtra';
		public static const AIM:String 				= 'aim';
		public static const APT:String 				= 'apt';
		public static const AFP:String 				= 'afp';
		public static const AW:String 				= 'aw';
		public static const BOLO:String 			= 'bolo';
		public static const CALLTO:String 			= 'callto';
		public static const CHROME:String 			= 'chrome';
		public static const CONTENT:String 			= 'content';
		public static const CVS:String 				= 'cvs';
		public static const DOI:String 				= 'doi';
		public static const ED2K:String 			= 'ed2k';
		public static const FEED:String 			= 'feed';
		public static const FINGER:String 			= 'finger';
		public static const FISH:String 			= 'fish';
		public static const GG:String 				= 'gg';
		public static const GIZMOPROJECT:String 		= 'gizmoproject';
		public static const GTALK:String 			= 'gtalk';
		public static const IAX2:String 			= 'iax2';
		public static const IRC:String 				= 'irc';
		public static const IRCS:String 			= 'ircs';
		public static const IRC6:String 			= 'irc6';
		public static const ITMS:String 			= 'itms';
		public static const JAR:String 				= 'jar';
		public static const JAVASCRIPT:String 			= 'javascript';
		public static const KEYPARC:String 			= 'keyparc';
		public static const LASTFM:String 			= 'lastfm';
		public static const LDAPS:String 			= 'ldaps';
		public static const MAGNET:String 			= 'magnet';
		public static const MAPS:String 			= 'maps';
		public static const MMS:String 				= 'mms';
		public static const MSNIM:String 			= 'msnim';
		public static const MUMBLE:String 			= 'mumble';
		public static const MVN:String 				= 'mvn';
		public static const NOTES:String 			= 'notes';
		public static const PSYC:String 			= 'psyc';
		public static const RMI:String 				= 'rmi';
		public static const RSYNC:String 			= 'rsync';
		public static const SECONDLIFE:String 			= 'secondlife';
		public static const SGN:String 				= 'sgn';
		public static const SKYPE:String 			= 'skype';
		public static const SPOTIFY:String 			= 'spotify';
		public static const SSH:String 				= 'ssh';
		public static const SFTP:String 			= 'sftp';
		public static const SMB:String 				= 'smb';
		public static const SMS:String 				= 'sms';
		public static const SOLDAT:String 			= 'soldat';
		public static const STEAM:String 			= 'steam';
		public static const SVN:String 				= 'svn';
		public static const TEAMSPEAK:String 			= 'teamspeak';
		public static const UNREAL:String 			= 'unreal';
		public static const UT2004:String 			= 'ut2004';
		public static const VENTRILO:String 			= 'ventrilo';
		public static const VIEW_SOURCE:String 			= 'view-source';
		public static const WEBCAL:String 			= 'webcal';
		public static const WTAI:String 			= 'wtai';
		public static const WYCIWYG:String 			= 'wyciwyg';
		public static const XFIRE:String 			= 'xfire';
		public static const XRI:String 				= 'xri';
		public static const YMSGR:String 			= 'ymsgr';
		
		/* Adobe scheme types */
		public static const RTMP:String 			= 'rtmp';
		public static const RTMPE:String 			= 'rtmpe';
		public static const RTMPTE:String 			= 'rtmpte';
		
		/* Unknown */
	        public static const UNKNOWN:String 			= 'unknown';
		
		private static const SCHEME_VALUES:Array = [AAA,
													AAAS,
													ACAP,
													CAP,
													CID,
													CRID,
													DATA,
													DAV,
													DICT,
													DNS,
													FAX,
													FILE,
													FTP,
													GO,
													GOPHER,
													H323,
													HTTP,
													HTTPS,
													ICAP,
													IM,
													IMAP,
													INFO,
													IPP,
													IRIS,
													IRIS_BEEP,
													IRIS_XPC,
													IRIS_XPCS,
													IRIS_LWS,
													LDAP,
													LSID,
													MAILTO,
													MID,
													MODEM,
													MSRP,
													MSRPS,
													MTQP,
													MUPDATE,
													NEWS,
													NFS,
													NNTP,
													OPAQUELOCKTOKEN,
													POP,
													PRES,
													PROSPERO,
													RTSPV,
													SERVICE,
													SHTTP,
													SIP,
													SIPS,
													SNMP,
													SOAP_BEEP,
													SOAP_BEEPS,
													TAG,
													TEL,
													TELNET,
													TFTP,
													THISMESSAGE,
													TIP,
													TV,
													URN,
													VENMI,
													WAIS,
													XMLRPC_BEEP,
													XMPP,
													Z39_50R,
													Z39_50S,
													ABOUT,
													ADIUMXTRA,
													AIM,
													APT,
													AFP,
													AW,
													BOLO,
													CALLTO,
													CHROME,
													CONTENT,
													CVS,
													DOI,
													ED2K,
													FEED,
													FINGER,
													FISH,
													GG,
													GIZMOPROJECT,
													GTALK,
													IAX2,
													IRC,
													IRCS,
													IRC6,
													ITMS,
													JAR,
													JAVASCRIPT,
													KEYPARC,
													LASTFM,
													LDAPS,
													MAGNET,
													MAPS,
													MMS,
													MSNIM,
													MUMBLE,
													MVN,
													NOTES,
													PSYC,
													RMI,
													RSYNC,
													SECONDLIFE,
													SGN,
													SKYPE,
													SPOTIFY,
													SSH,
													SFTP,
													SMB,
													SMS,
													SOLDAT,
													STEAM,
													SVN,
													TEAMSPEAK,
													UNREAL,
													UT2004,
													VENTRILO,
													VIEW_SOURCE,
													WEBCAL,
													WTAI,
													WYCIWYG,
													XFIRE,
													XRI,
													YMSGR,
													RTMP,
													RTMPE,
													RTMPTE];
		
		public static function getScheme (val:String):String
		{
			if (SCHEME_VALUES.indexOf (val.toLowerCase()) == -1)
			{
				return UNKNOWN;
			}
			else
			{
				return val.toLowerCase ();
			}
		}
	}
}



