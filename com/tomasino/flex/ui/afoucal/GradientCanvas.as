package com.tomasino.flex.ui.afoucal {
	
	/**
	 * @author Arnaud FOUCAL - http://afoucal.free.fr - afoucal@free.fr
	 * @licence
	 * This component is free for use, modification and distribution under the following condition:
	 * Just mention the name and the url of the author in a part of your product that is visible to the user (about section, documentation...)
	 * 
	 * 
	 * @version 1.0
	 * 1st release
	 *  
	 * @version 1.5
	 * - Added borders (+all related styles)
	 *  
	 * @version 2.0
	 * - Multi background gradient implemented
	 * - added : numberGradients, colorConfiguration properties
	 * 
	 * @version 2.1
	 * - colorsConfiguration is now also a style and can be used in css
	 * - improvement of borders drawing
	 * 
	 * @version 2.1.1
	 * - Avoided some compiler warnings (duplicated var declaration)
	 * 
	 * @version 2.1.2
	 * - Fixed a bug when the component has only 1 border color
	*/
	
	import flash.display.Graphics;
	import flash.display.CapsStyle;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	import flash.geom.Matrix;
	import mx.core.IUIComponent;
	import mx.core.UIComponent;
	import mx.utils.ArrayUtil;
	
	import mx.containers.Canvas;
	
	[Exclude(name = "backgroundColor", kind = "style")]
	
	/**
	 * Defines the type of the backgroun gradient. The gradient can be "linear" or "radial".
	 * 
	 * @ default "linear"
	 */
	[Style(name = "gradientType", type = "Array", format = "String", enumeration = "linear, radial", inherit = "no")]
	
	/**
	 * Defines the type of the border gradient. The gradient can be "linear" or "radial".
	 * 
	 * @ default "linear"
	 */
	[Style(name = "bordergradientType", type = "String", format = "String", enumeration = "linear, radial", inherit = "no")]
	
	/**
	 * An array of all colors defining the gradient for the background.
	 * 
	 * @default 0xFFFFFF 
	 */
	[Style(name = "fillColors", type = "Array", format = "Color", inherit = "no")]
	
	/**
	 * An array defining the number of colors in each gradient.
	 * 
	 * Example:
	 * [3,2] means 3 colors for the first gradient and 2 for the second one.
	 * 
	 * @default [1] 
	 */
	[Style(name = "colorsConfiguration", type = "Array", format = "Number", inherit = "no")]	
	
	/**
	 * An array of all colors defining the gradient for the border.
	 * 
	 * @default 0xFFFFFF 
	 */
	[Style(name = "borderColors", type = "Array", format = "Color", inherit = "no")]
	
	/**
	 * Bounding box thickness.
	 * 
	 * @default 0
	 */
	[Style(name = "borderThickness ", type = "Number", format = "Length", inherit = "no")]
	
	/**
	 * An array defining the alpha of each color in the background gradient. Values must be between 0 and 1.
	 * You must have the same number of alphas values than the number of colors in the gradient.
	 * 
	 * @default 1
	 */
	[Style(name = "fillAlphas", type = "Array", format = "Number", inherit = "no")]
	
	/**
	 * An array defining the alpha of each color in the gradient of the border. Values must be between 0 and 1.
	 * You must have the same number of alphas values than the number of colors in the gradient.
	 * 
	 * @default 1
	 */
	[Style(name = "borderAlphas", type = "Array", format = "Number", inherit = "no")]
	
	/**
	 * For the background : an array of color distribution ratios; valid values are 0 to 255. This value defines the percentage of the width where the color is sampled at 100%. The value 0 represents the left-hand position in the gradient box, and 255 represents the right-hand position in the gradient box.
	*
	* <b>Note</b>: This value represents positions in the gradient box, not the coordinate space of the final gradient, which might be wider or thinner than the gradient box. Specify a value for each value in the colors parameter.
	 * 
	 * The values in the array must increase sequentially; for example, [0, 63, 127, 190, 255]. 
	 */
	[Style(name = "gradientRatio", type = "Array", format = "Number", inherit = "no")]
	
	/**
	 * For the border : an array of color distribution ratios; valid values are 0 to 255. This value defines the percentage of the width where the color is sampled at 100%. The value 0 represents the left-hand position in the gradient box, and 255 represents the right-hand position in the gradient box.
	*
	* <b>Note</b>: This value represents positions in the gradient box, not the coordinate space of the final gradient, which might be wider or thinner than the gradient box. Specify a value for each value in the colors parameter.
	 * 
	 * The values in the array must increase sequentially; for example, [0, 63, 127, 190, 255]. 
	 */
	[Style(name = "bordergradientRatio", type = "Array", format = "Number", inherit = "no")]
	
	/**
	 * The value from the SpreadMethod class that specifies which spread method to use for the background gradient.
	 * Possible vaues are : "pad", "reflect", "repeat".
	 * 
	 * @default "pad"
	 */
	[Style(name = "spreadMethod", type = "Array", format = "String", enumeration = "pad, reflect, repeat", inherit = "no")]
	
	/**
	 * The value from the SpreadMethod class that specifies which spread method to use for the border gradient.
	 * Possible vaues are : "pad", "reflect", "repeat".
	 * 
	 * @default "pad"
	 */
	[Style(name = "borderSpreadMethod", type = "String", format = "String", enumeration = "pad, reflect, repeat", inherit = "no")]
	
	/**
	 * The value from the InterpolationMethod class that specifies which value to use for background gradient.
	 * Possible values are : "linearRGB" or "rgb".
	 * 
	 * @default "rgb"
	 */
	[Style(name = "interpolationMethod", type = "Array", format = "String", enumeration = "rgb, linearRGB", inherit = "no")]
	
	/**
	 * The value from the InterpolationMethod class that specifies which value to use for border gradient.
	 * Possible values are : "linearRGB" or "rgb".
	 * 
	 * @default "rgb"
	 */
	[Style(name = "borderInterpolationMethod", type = "String", format = "String", enumeration = "rgb, linearRGB", inherit = "no")]
	
	/**
	 * The number that controls the location of the focal point of the background gradient.
	 * 0 means that the focal point is in the center.
	 * 1 means that the focal point is at one border of the gradient circle.
	 * -1 means that the focal point is at the other border of the gradient circle.
	 * A value less than -1 or greater than 1 is rounded to -1 or 1.
	 * 
	 * @default 0
	 */
	[Style(name = "focalPointRatio", type = "Array", format = "Number", inherit = "no")]
	
	/**
	 * The number that controls the location of the focal point of the border gradient.
	 * 0 means that the focal point is in the center.
	 * 1 means that the focal point is at one border of the gradient circle.
	 * -1 means that the focal point is at the other border of the gradient circle.
	 * A value less than -1 or greater than 1 is rounded to -1 or 1.
	 * 
	 * @default 0
	 */
	[Style(name = "borderfocalPointRatio", type = "Number", format = "Number", inherit = "no")]
	
	/**
	 * Defines the rotation of the background gradient., in degree.
	 * This style has no visual result with a radial gradient excepted if the focal point ratio is different than 0.
	 * 
	 * @default 0
	 */
	[Style(name = "angle", type = "Array", format = "Number", inherit = "no")]
	
	/**
	 * Defines the rotation of the border gradient., in degree.
	 * This style has no visual result with a radial gradient excepted if the focal point ratio is different than 0.
	 * 
	 * @default 0
	 */
	[Style(name = "borderAngle", type = "Number", format = "Number", inherit = "no")]
	
	/**
	 * How far the background gradient is horizontally offset from the origin.
	 * 
	 * @default 0
	 */
	[Style(name = "offsetX", type = "Array", format = "Number", inherit = "no")]
	
	/**
	 * How far the border gradient is horizontally offset from the origin.
	 * 
	 * @default 0
	 */
	[Style(name = "borderOffsetX", type = "Number", format = "Number", inherit = "no")]
	
	/**
	 * How far the background gradient is vertically offset from the origin.
	 * 
	 * @default 0
	 */
	[Style(name = "offsetY", type = "Array", format = "Number", inherit = "no")]
	
	/**
	 * How far the border gradient is vertically offset from the origin.
	 * 
	 * @default 0
	 */
	[Style(name = "borderOffsetY", type = "Number", format = "Number", inherit = "no")]
	
	/**
	 * Radius 
	 */
	[Style(name = "cornerRadius", type = "Number", format = "Number", inherit = "no")]
	
	/**
	 * Radius of the upper-left corner of the canvas, in pixels
	 * 
	 * @default 0
	 */
	[Style(name = "topLeftRadius", type = "Number", format = "Number", inherit = "no")]
	
	/**
	 * Radius of the upper-right corner of the canvas, in pixels.
	 * 
	 * @default 0
	 */
	[Style(name = "topRightRadius", type = "Number", format = "Number", inherit = "no")]
	
	/**
	 * Radius of the bottom-left corner of the canvas, in pixels.
	 * 
	 * @default 0
	 */
	[Style(name = "bottomLeftRadius", type = "Number", format = "Number", inherit = "no")]
	
	/**
	 * Radius of the bottom-right corner of the canvas, in pixels.
	 * 
	 * @default 0
	 */
	[Style(name = "bottomRightRadius", type = "Number", format = "Number", inherit = "no")]
	
	/**
	 * <p>The GradientCanvas extends the class mx:Canvas by adding capabilities of styling the background.</p>
	 * <p>The GradientCanvas has a gradient background that can be totally customized.
	 * The corners of the canvas can be rounded individually.</p>
	 *    
	 *  @mxml
	 *
	 *  <p>The <code>&lt;GradientCanvas&gt;</code> tag inherits all the tag attributes of its superclass. Use the following syntax:</p>
	 *  <pre>
	 *  &lt;com:GradientCanvas&gt;
	 *    ...
	 *      <i>child tags</i>
	 *    ...
	 *  &lt;/GradientCanvas&gt;
	 *  </pre>
	 * 
	 *  @see http://livedocs.adobe.com/flex/3/langref/flash/display/Graphics.html#beginGradientFill() beginGradientFill
	 */
	public class GradientCanvas extends Canvas
	{
		// Variables for background gradients
		private var _gradientType : String;
		private var _fillColors : Array;
		private var _fillAlphas : Array;
		private var _gradientRatio : Array;
		private var _angle : Array;
		private var _offsetx : Array;
		private var _offsety : Array;
		private var _spreadMethod : String;
		private var _interpolationMethod : String;
		private var _focalPointRatio : Array;
		
		// Variables for the Canvas border
		private var _borderThickness : Number;
		private var _bgradientType : String;
		private var _bfillColors : Array;
		private var _bfillAlphas : Array;
		private var _bgradientRatio : Array;
		private var _bangle : Number;
		private var _boffsetx : Number;
		private var _boffsety : Number;
		private var _bspreadMethod : String;
		private var _binterpolationMethod : String;
		private var _bfocalPointRatio : Number;
		private var _topLeftRadius : Number;
		private var _topRightRadius : Number;
		private var _bottomLeftRadius : Number;
		private var _bottomRightRadius : Number;
		
		private var _colorsconfig : Array = new Array(1);
		/**
		 * Represents of the number of colors composing each gradient of the background.
		 * 
		 * Example :
		 * [3,2] means 3 colors for the first gradient and 2 for the second one.
		 * 
		 * @default 1
		 */
		public function get colorsConfiguration() : Array
		{
			return _colorsconfig;
		}
		/**
		 * @private
		 */
		public function set colorsConfiguration(val:Array) : void
		{
			_colorsconfig = val;
			invalidateDisplayList();
		}
		
		// Number of background gradients
		private var _ngradients : Number = _colorsconfig.length;
		/**
		 *  Returns the number of gradients that compose the background of the c	anvas.
		 * Read-only.
		 */
		public function get numberGradients() : Number
		{
			return _colorsconfig.length;
		} 
		
		// Default value of  GradientCanvas styles
		public static const DEFAULT_GRADIENTTYPE : String = "linear";
		public static const DEFAULT_FILLCOLORS : String = "0xFFFFFF";
		public static const DEFAULT_COLORSCONFIGURATION : Number = 1;
		public static const DEFAULT_FILLALPHAS : Number = 1;
		public static const DEFAULT_GRADIENTRATIO : Number = 255;
		public static const DEFAULT_BORDERTHICKNESS : Number = 0;
		public static const DEFAULT_ANGLE : Number = 0;
		public static const DEFAULT_OFFSETX : Number = 0;
		public static const DEFAULT_OFFSETY : Number = 0;
		public static const DEFAULT_SPREADMETHOD : String = "pad";
		public static const DEFAULT_INTERPOLATIONMETHOD : String = "rgb";
		public static const DEFAULT_FOCALPOINTRATIO : Number = 0;
		public static const DEFAULT_CORNERRADIUS : Number = 0;
		public static const DEFAULT_TOPLEFTRADIUS : Number = 0;
		public static const DEFAULT_TOPRIGHTRADIUS : Number = 0;
		public static const DEFAULT_BOTTOMLEFTRADIUS : Number = 0;
		public static const DEFAULT_BOTTOMRIGHTRADIUS : Number = 0;
			
		/**
		 * Constructor
		 */
		public function GradientCanvas()
		{
			super();
		}
		
		/**
		 * Overrive the function of the super Class and add the following:
		 * <ul><li> defines default values of the new styles,</li>
		 * <li> draws the background defined by customized styles.</li></ul>
		 * 
		 * @param w:Number The width of the GradientCanvas.
		 * @param h:Number The height of the GradientCanvas.
		 */
		override protected function updateDisplayList (w : Number, h : Number) :void
		{
			super.updateDisplayList (w, h);
			
			// Check if styles have changed
			if (bStylePropChanged==true) 
			{
				getAllStyles();
	
				// ready to draw!
				var _g : Graphics = graphics;
				_g.clear ();
				
				// so, draw !
				// Gradients
                var corners:Object = { tl: _topLeftRadius, tr: _topRightRadius, bl: _bottomLeftRadius, br: _bottomRightRadius };
				var i:Number;
				for ( i = 0 ; i < _colorsconfig.length ; i++)
				{
					var _gradmatrix : Matrix = new Matrix();
					_gradmatrix.createGradientBox (w, h, Math.PI * _angle[i] / 180, _offsetx[i], _offsety[i]);
					
                    drawRect (0, 0, w, h, corners, _fillColors[i], _fillAlphas[i], _gradmatrix, _gradientType.split(',')[i], _gradientRatio[i], 
						_spreadMethod.split(',')[i], _interpolationMethod.split(',')[i], _focalPointRatio[i]);
				}
				
				// Borders
				if (_borderThickness > 0)
				{
					var _gradbordermatrix : Matrix = new Matrix();
					_gradbordermatrix.createGradientBox (w+2*_borderThickness, h+2*_borderThickness, Math.PI*_bangle/180, _boffsetx, _boffsety);					
					
					var hole:Object = new Object();
					hole.x = 0;
					hole.y = 0;
					hole.w = w;
					hole.h = h;
					
					drawRect ( -_borderThickness, -_borderThickness, w + 2 * _borderThickness, h + 2 * _borderThickness, 
						corners, _bfillColors, _bfillAlphas, _gradbordermatrix, _bgradientType, _bgradientRatio, _bspreadMethod, _binterpolationMethod, _bfocalPointRatio, hole);
				}
			}
		}
		
		/**
		*  Extracted and partially adapted from Flex docs:
		* 
		* 	Programatically draws a rectangle into this skin's Graphics object.
		*
		*  <p>The rectangle can have rounded corners.
		*  Its edges are stroked with the current line style of the Graphics object.
		*  It can have a solid color fill, a gradient fill, or no fill.
		*  A solid fill can have an alpha transparency.
		*  A gradient fill can be linear or radial. You can specify up to 15 colors and alpha values at specified points along the gradient, and you can specify a rotation angle
		*  or transformation matrix for the gradient.
		*  Finally, the rectangle can have a rounded rectangular hole carved out of it.</p>
		*
		*	@param x Horizontal position of upper-left corner of rectangle within this skin.
		*
		*	@param y Vertical position of upper-left corner of rectangle within this skin.
		*
		*	@param width Width of rectangle, in pixels.
		*
		*	@param height Height of rectangle, in pixels.
		*
		*	@param cornerRadius Corner radius/radii of rectangle.
		*  Can be <code>null</code>, a Number, or an Object.
		*  If it is <code>null</code>, it specifies that the corners should be square rather than rounded.
		*  If it is a Number, it specifies the same radius, in pixels, for all four corners.
		*  If it is an Object, it should have properties named <code>tl</code>, <code>tr</code>, <code>bl</code>, and
		*  <code>br</code>, whose values are Numbers specifying the radius, in pixels, for the top left, top right,
		*  bottom left, and bottom right corners.
		*  For example, you can pass a plain Object such as <code>{ tl: 5, tr: 5, bl: 0, br: 0 }</code>.
		*  The default value is null (square corners).
		*
		*	@param color The RGB color(s) for the fill.
		*  Can be <code>null</code>, a uint, or an Array.
		*  If it is <code>null</code>, the rectangle not filled.
		*  If it is a uint, it specifies an RGB fill color.
		*  For example, pass <code>0xFF0000</code> to fill with red.
		*  If it is an Array, it should contain uints specifying the gradient colors.
		*  For example, pass <code>[ 0xFF0000, 0xFFFF00, 0x0000FF ]</code> to fill with a red-to-yellow-to-blue gradient.
		*  You can specify up to 15 colors in the gradient. The default value is null (no fill).
		*
		*	@param alpha Alpha value(s) for the fill.
		*  Can be null, a Number, or an Array.
		*  This argument is ignored if <code>color</code> is null.
		*  If <code>color</code> is a uint specifying an RGB fill color, then <code>alpha</code> should be a Number specifying
		*  the transparency of the fill, where 0.0 is completely transparent and 1.0 is completely opaque.
		*  You can also pass null instead of 1.0 in this case to specify complete opaqueness.
		*  If <code>color</code> is an Array specifying gradient colors, then <code>alpha</code> should be an Array of Numbers, of the
		*  same length, that specifies the corresponding alpha values for the gradient.
		*  In this case, the default value is <code>null</code> (completely opaque).
		*
		*  @param gradientMatrix Matrix object used for the gradient fill. 
		*  The utility methods <code>rotatedGradientMatrix()</code> is used to create the value for this parameter.
		*
		*	@param gradientType Type of gradient fill. The possible values are <code>GradientType.LINEAR</code> or <code>GradientType.RADIAL</code>.
		*  (The GradientType class is in the package flash.display.)
		*
		*	@param gradientRatios (optional default [0,255])
		*  Specifies the distribution of colors. The number of entries must match the number of colors defined in the <code>color</code> parameter.
		*  Each value defines the percentage of the width where the color is sampled at 100%. The value 0 represents the left-hand position in 
		*  the gradient box, and 255 represents the right-hand position in the gradient box.
		* 
		* 	@param spreadMethod
		* 	A value from the SpreadMethod class that specifies which spread method to use.
		* 
		* 	@param interpolationMethod
		* 	A value from the InterpolationMethod class that specifies which value to use.
		* 
		* 	@param focalPointRatio
		* 	A number that controls the location of the focal point of the gradient.
		*
		*	@param hole (optional) A rounded rectangular hole that should be carved out of the middle
		*  of the otherwise solid rounded rectangle
		*  { x: #, y: #, w: #, h: # }
		*
		*  @see flash.display.Graphics#beginGradientFill()
		*/
		private function drawRect(x:Number, y:Number, w:Number, h:Number,
                                  r:Object = null, c:Object = null,
                                  alpha:Object = null, rot:Object = null,
                                  gradient:String = null, ratios:Array = null,
                                  sprd:String = null, intp:String = null,
								  fclp:Number = 0, hole:Object = null):void
		{
			// Quick exit if w or h is zero. No time to loose drawing nothing
			if (!w || !h)
			return;
			
			var _g : Graphics = graphics;
			
			_g.beginGradientFill (gradient, c as Array, alpha as Array, ratios, rot as Matrix, sprd, intp, fclp);
			_g.drawRoundRectComplex (x, y, w, h, r.tl, r.tr, r.bl, r.br);
			
			// Carve a rectangular hole out of the middle of the rounded rect.
			if (hole)
			{
				_g.drawRoundRectComplex(hole.x, hole.y, hole.w, hole.h, r.tl, r.tr, r.bl, r.br);
			}			
			
			_g.endFill();
		}
		
		/**
		 * @private
		 * Gathers all styles and assigns values to the class props
		 */
		private function getAllStyles():void
		{
			// Temporary array to build styles
			var arr:Array;
			var i:Number;
			var j:Number;
			/*
			* Retrieves the user-defined styles or assign default values
			*/
			if (getStyle('gradientType')!=undefined) {
				_gradientType = getStyle ('gradientType'); }
				else {
					_gradientType = DEFAULT_GRADIENTTYPE;
					}
					
			if (getStyle('bordergradientType')!=undefined) {
				_bgradientType = getStyle ('bordergradientType'); }
				else {
					_bgradientType = DEFAULT_GRADIENTTYPE;
					}
					
			if (getStyle('colorsConfiguration')!=undefined) {
				_colorsconfig = ArrayUtil.toArray(getStyle ('colorsConfiguration')); }
				else {
					_ngradients = _colorsconfig.length;
					}
					
			if (getStyle ('fillColors') != undefined) {
				_fillColors = new Array();
				arr = new Array();
				arr = getStyle ('fillColors').toString().split(",");
				
				for (i = 0 ; i < _colorsconfig.length ; i++)
				{
					_fillColors.push(arr.slice(0, _colorsconfig[i]));
					arr = arr.slice(_colorsconfig[i]);
				}
			} 
				else {
					_fillColors = new Array(DEFAULT_FILLCOLORS);
					}
				
					
			if (getStyle ('borderColors') != undefined) {
				_bfillColors = new Array();
				arr = new Array();
				arr = getStyle ('borderColors').toString().split(",");
				
				for (j = 0 ; j < arr.length ; j++)
				{
					_bfillColors.push( arr[ j ] );
				}
			}
			else {
				_bfillColors = new Array(DEFAULT_FILLCOLORS);
				}
					
			if (getStyle ('borderThickness') != undefined) {
				_borderThickness = getStyle ('borderThickness'); }
				else {
					_borderThickness = DEFAULT_BORDERTHICKNESS;
					}

			if (getStyle('fillAlphas') != undefined) {
				_fillAlphas = new Array();
				arr = new Array();
				arr = getStyle ('fillAlphas').toString().split(",");
				for ( i = 0 ; i < _colorsconfig.length ; i++)
				{
					_fillAlphas.push(arr.slice(0, _colorsconfig[i]));
					arr = arr.slice(_colorsconfig[i]);
				}
			}
				else {
				// build the default value array of alphas according to the number of colors
					_fillAlphas = new Array();
					for ( i = 0; i < _colorsconfig.length; i++) {
						arr = new Array();
						for (j = 0 ; j < _colorsconfig[i] ; j++) {
							arr.push(DEFAULT_FILLALPHAS); }
						_fillAlphas.push(arr);
					}
				}
					
			if (getStyle('borderAlphas') != undefined) {
				_bfillAlphas = new Array();
				arr = new Array();
				arr = getStyle ('borderAlphas').toString().split(",");
				
				for (j = 0 ; j < arr.length ; j++)
				{
					_bfillAlphas.push( arr[ j ] );
				}
			}
				else {
				// build the default value array of alphas according to the number of colors
					_bfillAlphas = new Array();
					for ( i = 0; i < _bfillColors.length; i++) {
						_bfillAlphas.push (DEFAULT_FILLALPHAS);}
					}
			
			if (getStyle ('gradientRatio') != undefined) {
				_gradientRatio = getStyle ('gradientRatio');
				arr = new Array();
				arr = getStyle ('gradientRatio').toString().split(",");
				var newfill:Array = new Array();
				for ( i = 0 ; i < _colorsconfig.length ; i++)
				{
					newfill.push(arr.slice(0, _colorsconfig[i]));
					arr = arr.slice(_colorsconfig[i]);
				}
				_gradientRatio = newfill;
				}
				else {
					// build the default value array of ratio according to the number of colors
					_gradientRatio = new Array();
					for ( i = 0; i < _colorsconfig.length; i++) {
						_gradientRatio.push(generateDefaultRatio(_colorsconfig[i]));}
					}
				
			if (getStyle ('bordergradientRatio') != undefined) {
				_bgradientRatio = getStyle ('bordergradientRatio'); }
				else {
					// build the default value array of ratio according to the number of colors
					_bgradientRatio = new Array();
					for ( i = 0; i < _bfillColors.length; i++) {
						_bgradientRatio = generateDefaultRatio(_bfillColors.length);}
					}
				
			if (getStyle('angle') != undefined)	{
				arr = new Array();
				arr.push(getStyle('angle'));
				_angle = arr[0].toString().split(",");
				}	
				else {
					_angle = new Array();
					for ( i = 0 ; i < _colorsconfig.length ; i++) {
						_angle.push(DEFAULT_ANGLE); }
					}
				
			if (getStyle('borderAngle') != undefined) {
				_bangle = getStyle('borderAngle'); }
				else {
					_bangle = DEFAULT_ANGLE;
					}
				
			if (getStyle ('spreadMethod') != undefined)	{
				_spreadMethod = getStyle ('spreadMethod'); }
				else {
					_spreadMethod = DEFAULT_SPREADMETHOD;
					}
				
			if (getStyle ('borderSpreadMethod') != undefined) {
				_bspreadMethod = getStyle ('borderSpreadMethod'); }
				else {
					_bspreadMethod = DEFAULT_SPREADMETHOD;
					}
				
			if (getStyle ('interpolationMethod') != undefined) {
				_interpolationMethod = getStyle ('interpolationMethod'); }
				else {
					_interpolationMethod = DEFAULT_INTERPOLATIONMETHOD;
					}
					
			if (getStyle ('borderInterpolationMethod') != undefined)	 {
				_binterpolationMethod = getStyle ('borderInterpolationMethod'); }
				else {
					_binterpolationMethod = DEFAULT_INTERPOLATIONMETHOD;
					}
				
			if (getStyle ('focalPointRatio') != undefined) {
				_focalPointRatio = new Array();
				arr = new Array();
				arr.push(getStyle ('focalPointRatio'));
				_focalPointRatio = arr[0].toString().split(",");
				}
				else {
					_focalPointRatio = new Array();
					for ( i = 0 ; i < _colorsconfig.length ; i++) {
						_focalPointRatio.push(DEFAULT_FOCALPOINTRATIO); }
					}
				
			if (getStyle ('borderfocalPointRatio') != undefined) {
				_bfocalPointRatio = getStyle ('borderfocalPointRatio'); }
				else {
					_bfocalPointRatio = DEFAULT_FOCALPOINTRATIO;
					}
					
			if (getStyle ('offsetX') != undefined) {
				arr = new Array();
				arr.push(getStyle ('offsetX'));
				_offsetx = arr[0].toString().split(",");
				}
				else {
					_offsetx = new Array();
					for ( i = 0 ; i < _colorsconfig.length ; i++) {
						_offsetx.push(DEFAULT_OFFSETX); }
					}
					
			if (getStyle ('borderOffsetX') != undefined) {
				_boffsetx = getStyle ('borderOffsetX'); }
				else {
					_boffsetx = DEFAULT_OFFSETX;
					}
					
			if (getStyle ('offsetY') != undefined) {
				arr = new Array();
				arr.push(getStyle ('offsetY'));
				_offsety = arr[0].toString().split(",");
				}
				else {
					_offsety = new Array();
					for ( i = 0 ; i < _colorsconfig.length ; i++) {
						_offsety.push(DEFAULT_OFFSETY); }
					}
					
			if (getStyle ('borderOffsetY') != undefined) {
				_boffsety = getStyle ('borderOffsetY'); }
				else {
					_boffsety = DEFAULT_OFFSETY;
					}
			
			// Check if at least 1 individual corner has style and then use each corner as style
			if ( (getStyle ('topLeftRadius') != 0 && getStyle ('topLeftRadius') != undefined) ||
			(getStyle ('topRightRadius') != 0 && getStyle ('topRightRadius') != undefined) ||
			(getStyle ('bottomLeftRadius') != 0 && getStyle ('bottomLeftRadius') != undefined) ||
			(getStyle ('bottomRightRadius') != 0 && getStyle ('bottomRightRadius') != undefined))
			{ 
				if (getStyle ('topLeftRadius') != undefined) {
					_topLeftRadius = getStyle ('topLeftRadius'); }
					else {
						_topLeftRadius = DEFAULT_TOPLEFTRADIUS;
						}
						
				if (getStyle ('topRightRadius') != undefined) {
					_topRightRadius = getStyle ('topRightRadius'); }
					else {
					_topRightRadius = DEFAULT_TOPRIGHTRADIUS;
					}
					
				if (getStyle ('bottomLeftRadius') != undefined) {
					_bottomLeftRadius = getStyle ('bottomLeftRadius'); }
					else {
						_bottomLeftRadius = DEFAULT_BOTTOMLEFTRADIUS;
						}
						
				if (getStyle ('bottomRightRadius') != undefined) {
					_bottomRightRadius = getStyle ('bottomRightRadius'); }
					else {
						_bottomRightRadius = DEFAULT_BOTTOMRIGHTRADIUS;
						}
			}
			// if all individual corners have their default value, the cornerRadius is used as style for the 4 corners
			else
			{
				 _topLeftRadius = getStyle ('cornerRadius');
				 _topRightRadius = getStyle ('cornerRadius');
				 _bottomLeftRadius = getStyle ('cornerRadius');
				 _bottomRightRadius = getStyle ('cornerRadius');
			}			
		}
		
		/**
		 * @private
		 * Returns an array containing a homogeneous gradient of colors.
		 * 
		 * @param n:Number The number of colors in the gradient 
		 */
		private  function generateDefaultRatio (n:Number) :Array
		{
			var avg : Number = 255 / (n -1);
			var arr : Array = new Array();
			
			for (var i : Number = 0; i < n; i++)
			{
				var currentratio : Number = 255 - avg * i;
				arr.push (currentratio);
				arr.sort (Array.NUMERIC);
			}
			
			return arr;
		}
		
		// Define flag to indicate that a style property changed.
		private var bStylePropChanged:Boolean = true;
		
		/**
		 * Overrides the super Class method to detect changes to the new style properties.
		 * 
		 * @param styleProp:String The name of the style property, or null if all styles for this component have changed.
		 */
	       override public function styleChanged (styleProp:String) :void
	       {
			super.styleChanged (styleProp);
				
			// Check to see if style changed. 
			if (styleProp=='fillColors' || styleProp=='fillAlphas' || styleProp=='cornerRadius' || styleProp=='angle' || styleProp=='spreadMethod' ||  
			styleProp=='gradientType' || styleProp=='gradientRatio' || styleProp=='offsetX' || styleProp=='offsetY' || styleProp=='interpolationMethod' || 
			styleProp=='topLeftRadius' || styleProp=='topRightRadius' || styleProp=='bottomLeftRadius' || styleProp=='bottomRightRadius' || styleProp=='focalPointRatio' || 
			styleProp=='gradientType' || styleProp=='borderColors' || styleProp=='borderAlphas' || styleProp=='bordergradientRatio' || styleProp=='borderThickness' ||
			styleProp=='borderOffsetX' || styleProp=='borderOffsetY' || styleProp=='borderfocalPointRatio' || styleProp=='borderSpreadMethod' ||
			styleProp=='borderInterpolationMethod' || styleProp=='borderAngle' || styleProp=='colorsConfiguration')
			{
				bStylePropChanged = true; 
				invalidateDisplayList();
				return;
			}
	        }
	}
}
