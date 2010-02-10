/**
 * Copyright (c) 2008 Gareth Arch
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

/** 
 * This utility class packages together various date and time functions.  Most of them duplicate the functionality
 * found in the corresponding ColdFusion date/time functions, and argument-wise are set up the same way.
 */
 
package com.tomasino.flex.utils {

	import mx.formatters.DateFormatter;

	public class DateUtils {
		
		// Days of week
		public static const MONDAY:String		= "monday";
		public static const TUESDAY:String		= "tuesday";
		public static const WEDNESDAY:String	= "wednesday";
		public static const THURSDAY:String		= "thursday";
		public static const FRIDAY:String		= "friday";
		public static const SATURDAY:String		= "saturday";
		public static const SUNDAY:String		= "sunday";
		
		// Months of year
		public static const JANUARY:String		= "january";
		public static const FEBRUARY:String		= "february";
		public static const MARCH:String		= "march";
		public static const APRIL:String		= "april";
		public static const MAY:String			= "may";
		public static const JUNE:String			= "june";
		public static const JULY:String			= "july";
		public static const AUGUST:String		= "august";
		public static const SEPTEMBER:String	= "september";
		public static const OCTOBER:String		= "october";
		public static const NOVEMBER:String		= "november";
		public static const DECEMBER:String		= "december";

		// Date parts
		public static const YEAR:String			= "fullYear";
		public static const MONTH:String		= "month";
		public static const WEEK:String			= "week";
		public static const DAY_OF_MONTH:String	= "date";
		public static const HOURS:String		= "hours";
		public static const MINUTES:String		= "minutes";
		public static const SECONDS:String		= "seconds";
		public static const MILLISECONDS:String	= "milliseconds";
		public static const DAY_OF_WEEK:String	= "day";
		
		// Numeric value of "last", to get last item for a specific time
		public static const LAST:Number			= -1;
		
		// Date masks
		public static const SHORT_DATE_MASK:String	= "MM/DD/YY";
		public static const MEDIUM_DATE_MASK:String	= "MMM D, YYYY";
		public static const LONG_DATE_MASK:String	= "MMMM D, YYYY";
		public static const FULL_DATE_MASK:String	= "EEEE, MMMM D, YYYY";
		
		// Time masks
		public static const SHORT_TIME_MASK:String	= "L:NN A";
		public static const MEDIUM_TIME_MASK:String	= "L:NN:SS A";
		// TZD = TimeZoneDesignation = GMT + or - X hours, non-standard, requires a slight hack
		public static const LONG_TIME_MASK:String	= MEDIUM_TIME_MASK + " TZD";
		
		// Internal values for using in date/time calculations
		private static const SECOND_VALUE:uint	= 1000;
		private static const MINUTE_VALUE:uint	= DateUtils.SECOND_VALUE * 60;
		private static const HOUR_VALUE:uint	= DateUtils.MINUTE_VALUE * 60;
		private static const DAY_VALUE:uint		= DateUtils.HOUR_VALUE * 24;
		private static const WEEK_VALUE:uint	= DateUtils.DAY_VALUE * 7;
		
		// Internal variable used in date/time formatting
		private static var _dateFormatter:DateFormatter;
		private static function get dateFormatter():DateFormatter {
			if ( !_dateFormatter ) {
				_dateFormatter = new DateFormatter;
			}
			return _dateFormatter;
		}
		
		// a generic object for holding day of the week values
		private static var _objDaysOfWeek:Object = null;
		public static function get objDaysOfWeek():Object {
			if ( !_objDaysOfWeek ) {
				_objDaysOfWeek = {};
				_objDaysOfWeek[ DateUtils.SUNDAY ]		= 0;
				_objDaysOfWeek[ DateUtils.MONDAY ]		= 1;
				_objDaysOfWeek[ DateUtils.TUESDAY ]		= 2;
				_objDaysOfWeek[ DateUtils.WEDNESDAY ]	= 3;
				_objDaysOfWeek[ DateUtils.THURSDAY ]	= 4;
				_objDaysOfWeek[ DateUtils.FRIDAY ]		= 5;
				_objDaysOfWeek[ DateUtils.SATURDAY ]	= 6;
			}
			return _objDaysOfWeek;
		}
		
		// a generic object for holding month values
		private static var _objMonth:Object = null;
		public static function get objMonth():Object {
			if ( !_objMonth ) {
				_objMonth = {};
				_objMonth[ DateUtils.JANUARY ]		= 0;
				_objMonth[ DateUtils.FEBRUARY ]		= 1;
				_objMonth[ DateUtils.MARCH ]		= 2;
				_objMonth[ DateUtils.APRIL ]		= 3;
				_objMonth[ DateUtils.MAY ]			= 4;
				_objMonth[ DateUtils.JUNE ]			= 5;
				_objMonth[ DateUtils.JULY ]			= 6;
				_objMonth[ DateUtils.AUGUST ]		= 7;
				_objMonth[ DateUtils.SEPTEMBER ]	= 8;
				_objMonth[ DateUtils.OCTOBER ]		= 9;
				_objMonth[ DateUtils.NOVEMBER ]		= 10;
				_objMonth[ DateUtils.DECEMBER ]		= 11;
			}
			return _objMonth;
		}
		
		public function DateUtils() {
		}
		
		/**
		 * @private
		 * 
		 * This function will remove any invalid characters from the date/time mask based upon a pattern
		 * 
		 * @param mask			The string for matching
		 * @param pattern		The valid characters for this mask
		 * @param defaultValue	The default value to return to the calling page should the mask not match the pattern
		 * 
		 * @return				Returns a validated <code>mask</code> based upon the original pattern
		 */
		private static function removeInvalidDateTimeCharacters( mask:String, pattern:String, defaultValue:String ):String {
			// test for invalid date and time characters
			if ( mask.replace( new RegExp( pattern, "ig" ), "" ).length > 0 ) {
				// if user is passing an invalid mask, default to defaultValue
				mask = defaultValue;
			}
			// temporarily replace TZD with lowercase tzd for replacing later
			return mask.replace( new RegExp( "TZD", "i" ), "tzd" );
		}
		
		/**
		 * Formats a date into a certain date/time format
		 * 
		 * @param date	The date to format
		 * @param mask	How the date should be formatted
		 * 
		 * @return		A formatted date
		 */
		public static function dateTimeFormat( date:Date, mask:String="MM/DD/YYYY L:NN:SS A" ):String {
			return buildDateTime( date, mask, "(Y|M|D|E|A|J|H|K|L|N|S|TZD|\\W)+", DateUtils.SHORT_DATE_MASK + ' ' + DateUtils.SHORT_TIME_MASK );
		}
		
		/**
		 * Formats a time into a certain time format
		 * 
		 * @param date	The date to format
		 * @param mask	How the date should be formatted
		 * 
		 * @return		A formatted time
		 */
		public static function timeFormat( date:Date, mask:String=DateUtils.SHORT_TIME_MASK ):String {
			return buildDateTime( date, mask, "(A|:|J|H|K|L|N|S|TZD|\\s)+", DateUtils.SHORT_TIME_MASK );
		}
		
		/**
		 * Formats a date into a certain date format
		 * 
		 * @param date	The date to format
		 * @param mask	How the date should be formatted
		 * 
		 * @return		A formatted date
		 */
		public static function dateFormat( date:Date, mask:String=DateUtils.SHORT_DATE_MASK ):String {
			return buildDateTime( date, mask, "(Y|M|D|E|\\W)+", DateUtils.SHORT_DATE_MASK );
		}
		
		/**
		 * @private
		 * 
		 * Formats a date into a certain date/time format
		 * 
		 * @param date			The date to format
		 * @param mask			The string for matching
		 * @param pattern		The valid characters for this mask
		 * @param defaultValue	The default value to return to the calling page should the mask not match the pattern
		 * 
		 * @return		A formatted date
		 */
		private static function buildDateTime( date:Date, mask:String, pattern:String, defaultValue:String ):String {
			dateFormatter.formatString = removeInvalidDateTimeCharacters( mask, pattern, defaultValue );
			
			return dateFormatter.format( date ).replace( new RegExp( "TZD", "i" ), buildTimeZoneDesignation( date ) );
		}
		
		/**
		 * @private
		 * 
		 * Calculates a timeZoneOffset, and converts it to a string, in standard GMT XX:XX format
		 * 
		 * @param date	The date on which to calculate the offset
		 * 
		 * @return		The formatted time zone designation
		 */
		private static function buildTimeZoneDesignation( date:Date ):String {
			if ( !date ) {
				return "";
			}
			var timeZoneAsString:String = "GMT ";
			// timezoneoffset is the number that needs to be added to the local time to get to GMT, so
			// a positive number would actually be GMT -X hours
			if ( date.getTimezoneOffset() / 60 > 0 && date.getTimezoneOffset() / 60 < 10 ) {
				timeZoneAsString += "-0" + ( date.getTimezoneOffset() / 60 ).toString();
			} else if ( date.getTimezoneOffset() < 0 && date.timezoneOffset / 60 > -10 ) {
				timeZoneAsString += "0" + ( -1 * date.getTimezoneOffset() / 60 ).toString();
			}
			// add zeros to match standard format
			timeZoneAsString += "00";

			return timeZoneAsString;
		}
		
		/**
		 * Adds the specified number of "date parts" to a date, e.g. 6 days
		 * 
		 * @param datePart	The part of the date that will be added
		 * @param number	The total number of "dateParts" to add to the date
		 * @param date		The date on which to add
		 * 
		 * @return			The new date
		 */
		public static function dateAdd( datePart:String, number:Number, date:Date ):Date {
			var _returnDate:Date = new Date( date );
		
			switch ( datePart ) {
				case DateUtils.YEAR:
				case DateUtils.MONTH:
				case DateUtils.DAY_OF_MONTH:
				case DateUtils.HOURS:
				case DateUtils.MINUTES:
				case DateUtils.SECONDS:
				case DateUtils.MILLISECONDS:
					_returnDate[ datePart ] += number;
					break;
				case DateUtils.WEEK:
					_returnDate[ DateUtils.DAY_OF_MONTH ] += number * 7;
					break;
				default:
					/* Unknown date part, do nothing. */
					break;
			}
			return _returnDate;
		}
		
		/**
		 * Gets the day of the week
		 * 
		 * @param date	The date for which to get the day of the week
		 * 
		 * @return		A number representing the day of the week, 0 to 6
		 */
		public static function dayOfWeek( date:Date ):Number {
			return date.getDay();
		}
		
		/**
		 * Gets the ordinal value or day of the year
		 *
		 * @param date	The date for which to get the day of the year
		 * 
		 * @return		A number representing the day of the year, 1 to 365 or 366 for a leap year
		 */
		public static function dayOfYear( date:Date ):Number {
			// add one as it has to include first of year
			return DateUtils.dateDiff( DateUtils.DAY_OF_MONTH, new Date( date.fullYear, DateUtils.monthAsNumber( DateUtils.JANUARY ), 1 ), date ) + 1;
		}
		
		/**
		 * Gets the week of the year
		 * 
		 * @param date	The date for which to get the week of the year
		 * 
		 * @return		A number representing the week of the year, 1 to 53 ( as there are slightly more than 52 weeks of days in a year)
		 */
		public static function weekOfYear( date:Date ):Number {
			return Math.ceil( DateUtils.dayOfYear( date ) / 7 );
		}
		
		/**
		 * Converts the day of the week to a Flex day of the week
		 * 
		 * @param date	The human readable day of week
		 * 
		 * @return		The Flex converted day of week or 0 aka Sunday
		 */
		public static function toFlexDayOfWeek( localDayOfWeek:Number ):Number {
			return ( localDayOfWeek > 0 && localDayOfWeek < 8 ) ? localDayOfWeek - 1 : 0;
		}
		
		/**
		 * Gets the Xth day of the month.
		 * e.g. get the 3rd Wednesday of the month
		 * 
		 * @param iteration		The iteration of the month to get e.g. 4th or Last
		 * @param strDayOfWeek	The day of the week as a string
		 * @param date			The date containing the month and year
		 * 
		 * @return				The date of the xth dayOfWeek of the month 
		 */
		public static function dayOfWeekIterationOfMonth( iteration:Number, strDayOfWeek:String, date:Date ):Date {
			// get the numeric day of the week for the requested day
			var _dayOfWeek:Number = dayOfWeekAsNumber( strDayOfWeek );
			// get the date for the first of the month
			var _firstOfMonth:Date = new Date( date.fullYear, date.month, 1 );
			// calculate how many days to add to get to the requested day from the first of the month
			var _daysToAdd:Number = _dayOfWeek - DateUtils.dayOfWeek( _firstOfMonth );
			// if dayOfWeek is before the first of the month, get the dayOfWeek for the following week
			if ( _daysToAdd < 0 ) {
				_daysToAdd += 7;
			}
			// set the date to the first day of the week for the requested date
			var _firstDayOfWeekOfMonth:Date = DateUtils.dateAdd( DateUtils.DAY_OF_MONTH, _daysToAdd, _firstOfMonth );
			// return the date if iteration is 1
			if ( iteration == 1 ) {
				return _firstDayOfWeekOfMonth;
			} else {
				// if requesting an iteration that is more than is in that month or requesting the last day of week of month
				// return last date for that day of week of month
				if ( ( DateUtils.totalDayOfWeekInMonth( strDayOfWeek, date ) < iteration ) || ( iteration == DateUtils.LAST ) ) {
					iteration = DateUtils.totalDayOfWeekInMonth( strDayOfWeek, date );
				}
				// subtract 1 as it starts from the first dayOfWeek of month
				return DateUtils.dateAdd( DateUtils.WEEK, iteration - 1, _firstDayOfWeekOfMonth );
			}
		}
		
		/**
		 * Gets the days in the month
		 * 
		 * @param date	The date to check
		 * 
		 * @return		The number of days in the month
		 */
		public static function daysInMonth( date:Date ):Number {
			// get the first day of the next month
			var _localDate:Date = new Date( date.fullYear, DateUtils.dateAdd( DateUtils.MONTH, 1, date ).month, 1 );
			// subtract 1 day to get the last day of the requested month
			return DateUtils.dateAdd( DateUtils.DAY_OF_MONTH, -1, _localDate ).date;
		}
		
		/**
		 * Gets the total number of dayOfWeek in the month
		 * 
		 * @param strDayOfWeek	The day of week to check
		 * @param date			The date containing the month and year
		 * 
		 * @return				The number of <code>strDayOfWeek</code> in that month and year
		 */
		public static function totalDayOfWeekInMonth( strDayOfWeek:String, date:Date ):Number {
			var _startDate:Date = DateUtils.dayOfWeekIterationOfMonth( 1, strDayOfWeek, date );
			var _totalDays:Number = DateUtils.dateDiff( DateUtils.DAY_OF_MONTH, _startDate, new Date( date.fullYear, date.month, DateUtils.daysInMonth( date ) ) );
			// have to add 1 because have to include first day that is found i.e. if wed is on 2nd of 31 day month, would total 5, of if wed on 6th, would total 4
			return Math.floor( _totalDays / 7 ) + 1;
		}
		
		/**
		 * Converts the month to a Flex month
		 * 
		 * @param date	The human readable month
		 * 
		 * @return		The Flex converted month or 0 aka January
		 */
		public static function toFlexMonth( localMonth:Number ):Number {
			return ( localMonth > 0 && localMonth < 13 ) ? localMonth - 1 : 0;
		}
		
		/**
		 * Determines whether a value is actually a valid date
		 * 
		 * @param value	The date value
		 * 
		 * @return		<code>true</code> means this is a valid date, <code>false</code> means it is not a valid date
		 */
		public static function isDate( value:String ):Boolean {
			return Date.parse( value ) > 0;
		}
		
		/**
		 * Formats a date to the string version of the day of the week
		 * 
		 * @param date	The date to format
		 * 
		 * @return		A formatted day of week
		 */
		public static function dayOfWeekAsString( date:Date ):String {
			return DateUtils.dateFormat( date, "EEEE" );
		}
		
		/**
		 * Formats a date to the numeric version of the day of the week
		 * 
		 * @param strDayOfWeek	The day of week to convert
		 * 
		 * @return				A formatted day of week or -1 if day not found
		 */
		public static function dayOfWeekAsNumber( strDayOfWeek:String ):Number {
			return ( objDaysOfWeek[ strDayOfWeek ] >= 0 ) ? objDaysOfWeek[ strDayOfWeek ] : -1;
		}
		
		/**
		 * Formats a date to the string version of the month
		 * 
		 * @param date	The date to format
		 * 
		 * @return		A formatted month
		 */
		public static function monthAsString( date:Date ):String {
			return DateUtils.dateFormat( date, "MMMM" );
		}
		
		/**
		 * Formats a month to the numeric version of the month
		 * 
		 * @param strMonth	The month to convert
		 * 
		 * @return			A formatted month or -1 if month not found
		 */
		public static function monthAsNumber( strMonth:String ):Number {
			return ( objMonth[ strMonth ] >= 0 ) ? objMonth[ strMonth ] : -1;
		}
		
		/**
		 * Gets the number of days in the year
		 * 
		 * @param date	The date to check
		 * 
		 * @return		The total number of days in the year
		 */
		public static function daysInYear( date:Date ):Number {
			return DateUtils.dateDiff(
						DateUtils.DAY_OF_MONTH,
						new Date( date.fullYear, DateUtils.monthAsNumber( DateUtils.JANUARY ), 1 ),
						DateUtils.dateAdd( DateUtils.YEAR, 1, new Date( date.fullYear, DateUtils.monthAsNumber( DateUtils.JANUARY ), 1 ) ) );
		}
		
		/**
		 * Determines whether the year is a leap year or not
		 * 
		 * @param date	The date to check
		 * 
		 * @return		<code>true</code> means it is a leap year, <code>false</code> means it is not a leap year.
		 */
		public static function isLeapYear( date:Date ):Boolean {
			return daysInYear( date ) > 365;
		}
		
		/**
		 * Determines the number of "dateParts" difference between 2 dates
		 * 
		 * @param datePart	The part of the date that will be checked
		 * @param startDate	The starting date
		 * @param endDate	The ending date
		 * 
		 * @return			The number of "dateParts" difference
		 */
		public static function dateDiff( datePart:String, startDate:Date, endDate:Date ):Number {
			var _returnValue:Number = 0;

			switch ( datePart ) {
				case DateUtils.MILLISECONDS:
					_returnValue = endDate.time - startDate.time;
					break;
				case DateUtils.SECONDS:
					_returnValue = Math.floor( DateUtils.dateDiff( DateUtils.MILLISECONDS, startDate, endDate ) / DateUtils.SECOND_VALUE );
					break;
				case DateUtils.MINUTES:
					_returnValue = Math.floor( DateUtils.dateDiff( DateUtils.MILLISECONDS, startDate, endDate ) / DateUtils.MINUTE_VALUE );
					break;
				case DateUtils.HOURS:
					_returnValue = Math.floor( DateUtils.dateDiff( DateUtils.MILLISECONDS, startDate, endDate ) / DateUtils.HOUR_VALUE );
					break;
				case DateUtils.DAY_OF_MONTH:
					// TODO: Need to figure out DST problem i.e. 23 hours at DST start, 25 at end.
					// Math.floor causes rounding down error with DST start at dayOfYear
					_returnValue = Math.floor( DateUtils.dateDiff( DateUtils.MILLISECONDS, startDate, endDate ) / DateUtils.DAY_VALUE );
					break;
				case DateUtils.WEEK:
					_returnValue = Math.floor( DateUtils.dateDiff( DateUtils.MILLISECONDS, startDate, endDate ) / DateUtils.WEEK_VALUE );
					break;
				case DateUtils.MONTH:
					// if start date is after end date, switch values and take inverse of return value
					if ( DateUtils.dateDiff( DateUtils.MILLISECONDS, startDate, endDate ) < 0 ) {
						_returnValue -= DateUtils.dateDiff( DateUtils.MONTH, endDate, startDate );
					} else {
						 // get number of months based upon years
						_returnValue = DateUtils.dateDiff( DateUtils.YEAR, startDate, endDate ) * 12;
						// subtract months then perform test to verify whether to subtract one month or not
						// the check below gets the correct starting number of months (but may need to have one month removed after check)
						if ( endDate.month != startDate.month ) {
							_returnValue += ( endDate.month <= startDate.month ) ? 12 - startDate.month + endDate.month : endDate.month - startDate.month;
						}
						// have to perform same checks as YEAR
						// i.e. if end date day is <= start date day, and end date milliseconds < start date milliseconds
						if ( ( endDate[ DateUtils.DAY_OF_MONTH ] < startDate[ DateUtils.DAY_OF_MONTH ] ) ||
								( endDate[ DateUtils.DAY_OF_MONTH ] == startDate[ DateUtils.DAY_OF_MONTH ] &&
									endDate[ DateUtils.MILLISECONDS ] < startDate[ DateUtils.MILLISECONDS ] ) ) {
							_returnValue -= 1;
						}
					}
					break;
				case DateUtils.YEAR:
					_returnValue = endDate.fullYear - startDate.fullYear;
					// this fixes the previous problem with dates that ran into 2 calendar years
					// previously, if 2 dates were in separate calendar years, but the months were not > 1 year apart, then it was returning too many years
					// e.g. 11/2008 to 2/2009 was returning 1, but should have been returning 0 (zero)
					// if start date before end date and months are less than 1 year apart, add 1 to year to fix offset issue
					// if end date before start date and months are less than 1 year apart, subtract 1 year to fix offset issue
					// added month and milliseconds check to make sure that a date that was e.g. 9/11/07 9:15AM would not return 1 year if the end date was 9/11/08 9:14AM
					if ( _returnValue != 0 ) {
						// if start date is after end date
						if ( _returnValue < 0 ) {
							// if end date month is >= start date month, and end date day is >= start date day, and end date milliseconds > start date milliseconds
							if ( ( endDate[ DateUtils.MONTH ] > startDate[ DateUtils.MONTH ] ) ||
									( endDate[ DateUtils.MONTH ] == startDate[ DateUtils.MONTH ] && endDate[ DateUtils.DAY_OF_MONTH ] > startDate[ DateUtils.DAY_OF_MONTH ] ) ||
									( endDate[ DateUtils.MONTH ] == startDate[ DateUtils.MONTH ] && endDate[ DateUtils.DAY_OF_MONTH ] == startDate[ DateUtils.DAY_OF_MONTH ] &&
										endDate[ DateUtils.MILLISECONDS ] > startDate[ DateUtils.MILLISECONDS ] ) ) {
								_returnValue += 1;
							}
						} else {
							// if end date month is <= start date month, and end date day is <= start date day, and end date milliseconds < start date milliseconds
							if ( ( endDate[ DateUtils.MONTH ] < startDate[ DateUtils.MONTH ] ) ||
									( endDate[ DateUtils.MONTH ] == startDate[ DateUtils.MONTH ] && endDate[ DateUtils.DAY_OF_MONTH ] < startDate[ DateUtils.DAY_OF_MONTH ] ) ||
									( endDate[ DateUtils.MONTH ] == startDate[ DateUtils.MONTH ] && endDate[ DateUtils.DAY_OF_MONTH ] == startDate[ DateUtils.DAY_OF_MONTH ] &&
										endDate[ DateUtils.MILLISECONDS ] < startDate[ DateUtils.MILLISECONDS ] ) ) {
								_returnValue -= 1;
							}
						}
					}
					break;
			
			}

			return _returnValue;
			
		}
		
	}
}
