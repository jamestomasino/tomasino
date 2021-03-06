﻿package org.tomasino.utils 
{
	import com.adobe.utils.StringUtil;
	
	public class LatLongDist
	{
		private static const a = 6378137;			// WGS-84 ellipsiod
		private static const b = 6356752.3142;		// WGS-84 ellipsiod
		private static const f = 1/298.257223563;	// WGS-84 ellipsiod
		private static const R = 6371000; // earth's mean radius in meters
		
		/* All distances are in meters */
		
		public function LatLongDist()
		{
		}
			
		/*  Vincenty Inverse Solution of Geodesics on the Ellipsoid  */

		public static function convertToDec (latlong:String):Number
		{
			latlong = com.adobe.utils.StringUtil.trim(latlong); // trim whitespace off ends
			
			var isNeg:Boolean;
			if (latlong.substr(-1).toUpperCase() == 'S' || latlong.substr(-1).toUpperCase() == 'W') isNeg = true;
			
			latlong = latlong.replace(/[\−]/g, '-'); // Wikipedia uses funky hyphens for minus signs
			latlong = latlong.replace(/[^0-9\-\.]/g,' '); // Get rid of anything not a number or decimal place or negative
			latlong = latlong.replace(/ {2,}/g, ' '); // condense whitespace
			latlong = com.adobe.utils.StringUtil.trim(latlong); // trim whitespace off ends
			
			var dms:Array = latlong.split(/ /); // split
			var deg:Number;

			if (dms[0] && dms[0] < 0) isNeg = true;
			
			switch (dms.length) 
			{
			    case 3:
			    	deg = Number(Math.abs(dms[0])) + Number(dms[1]) / 60 + Number(dms[2]) / 3600; 
			    	break;
			    case 2: 
			    	deg = Number(Math.abs(dms[0])) + Number(dms[1]) / 60; 
			    	break;
			    case 1:
			    	deg = Number (Math.abs(dms[0]));
			    	break;
			    default: 
					return NaN;
			}
			
			if (isNeg && deg > 0) deg *= -1;
			return deg;
		}

		public static function vincenty (lat1:Number, lon1:Number, lat2:Number, lon2:Number) 
		{
			var lambda:Number = toRad(lon2-lon1);
			var L:Number = lambda;
			var lambdaP:Number = lambda + 1; // So we can get past the first test
			
			var U1:Number = Math.atan((1-f) * Math.tan(toRad(lat1)));
			var U2:Number = Math.atan((1-f) * Math.tan(toRad(lat2)));
			var sinU1:Number = Math.sin(U1)
			var cosU1:Number = Math.cos(U1);
			var sinU2:Number = Math.sin(U2)
			var cosU2:Number = Math.cos(U2);
			
			var iterLimit:Number = 100;
			while (Math.abs(lambda-lambdaP) > 0.000000000001 && --iterLimit > 0)
			{
				var sinLambda:Number = Math.sin(lambda)
				var cosLambda:Number = Math.cos(lambda);
				var sinSigma:Number = Math.sqrt( (cosU2 * sinLambda) * (cosU2 * sinLambda) + (cosU1 * sinU2 - sinU1 * cosU2 * cosLambda) * (cosU1 * sinU2-  sinU1 * cosU2 * cosLambda));
				if (sinSigma == 0) return 0;  // co-incident points
				var cosSigma:Number = sinU1 * sinU2 + cosU1 * cosU2 * cosLambda;
				var sigma:Number = Math.atan2 (sinSigma, cosSigma);
				var sinAlpha:Number = cosU1 * cosU2 * sinLambda / sinSigma;
				var cosSqAlpha:Number = 1 - sinAlpha * sinAlpha;
				var cos2SigmaM:Number = cosSigma - 2 * sinU1 * sinU2 / cosSqAlpha;
				if (isNaN(cos2SigmaM)) cos2SigmaM = 0;  // equatorial line: cosSqAlpha=0 (§6)
				var C:Number = f / 16 * cosSqAlpha * (4 + f * (4 - 3 * cosSqAlpha));
				lambdaP = lambda;
				lambda = L + (1 - C) * f * sinAlpha * (sigma + C * sinSigma * (cos2SigmaM + C * cosSigma * (-1 + 2 * cos2SigmaM * cos2SigmaM)));
			}
			
			if (iterLimit==0) return NaN  // formula failed to converge
			
			var uSq:Number = cosSqAlpha * (a * a - b * b) / (b * b);
			var A:Number = 1 + uSq / 16384 * (4096 + uSq * (-768 + uSq * (320 - 175 * uSq)));
			var B:Number = uSq / 1024 * ( 256 + uSq * (-128 + uSq * (74 - 47 * uSq)));
			var deltaSigma:Number = B * sinSigma * (cos2SigmaM + B / 4 * (cosSigma * (-1 + 2 * cos2SigmaM*cos2SigmaM) - B / 6 * cos2SigmaM * (-3 + 4 * sinSigma * sinSigma) * (-3 + 4 * cos2SigmaM * cos2SigmaM)));
			var s:Number = b * A * (sigma - deltaSigma);
			  
			return s;
		}
		
		public static function haversine (lat1:Number, lon1:Number, lat2:Number, lon2:Number):Number
		{
		  var dLat:Number = toRad(lat2-lat1);
		  var dLon:Number = toRad(lon2-lon1);
		  lat1 = toRad(lat1);
		  lat2 = toRad(lat2);
		
		  var a:Number = Math.sin(dLat/2) * Math.sin(dLat/2) + Math.cos(lat1) * Math.cos(lat2) * Math.sin(dLon/2) * Math.sin(dLon/2);
		  var c:Number = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
		  var d:Number = R * c;
		  return d;
		  
		}

		public static function cosinelaw (lat1:Number, lon1:Number, lat2:Number, lon2:Number):Number
		{
			lat1 = toRad(lat1);
			lat2 = toRad(lat2);
			
  			var d:Number = Math.acos( Math.sin(lat1) * Math.sin(lat2) + Math.cos(lat1) * Math.cos(lat2) * Math.cos( toRad(lon2-lon1) ) ) * R;
  			return d;
		}

		public static function bearing (lat1:Number, lon1:Number, lat2:Number, lon2:Number):Number
		{
			lat1 = toRad(lat1);
		  	lat2 = toRad(lat2);
			var dLon:Number = toRad(lon2-lon1);
		
			var y:Number = Math.sin(dLon) * Math.cos(lat2);
			var x:Number = Math.cos(lat1) * Math.sin(lat2) - Math.sin(lat1) * Math.cos(lat2) * Math.cos(dLon);
			return toBrng(Math.atan2(y, x));
		}

		private static function toRad(val:Number):Number 
		{
		  return val * Math.PI / 180;
		}
		
		private static function toDeg (val:Number):Number
		{
		  return val * 180 / Math.PI;
		}
		
		private static function toBrng (val:Number):Number
		{
			return ( toDeg(val) + 360 ) % 360;
		}
		
		private static function toDMS (val:Number):String
		{
			var d:Number = Math.abs(val);
 
			var deg:Number = Math.floor(d);
			var min:Number = Math.floor((d-deg)*60);
			var sec:Number = Math.round((d-deg-min/60)*3600);

			return String(deg + '\u00B0' + min + '\'' + sec + '\"');
		}
		
		public static function toLat(val:Number):String
		{
			return toDMS(val) + ( val < 0 ? 'S' : 'N');  // knock off initial '0' for lat!
		}
		
		public static function toLon(val:Number):String
		{
			return toDMS(val) + ( val > 0 ? 'E' : 'W');
		}
	}
}