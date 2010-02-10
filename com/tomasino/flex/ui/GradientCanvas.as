package com.tomasino.flex.ui
{
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.display.SpreadMethod;
	import flash.geom.Matrix;
	
	import mx.containers.Canvas;
	import mx.styles.CSSStyleDeclaration;
	import mx.styles.StyleManager;

	[Style(name="gradientColors",type="Array",format="Color",inherit="no")]
	[Style(name="gradientAlphas",type="Array",format="Number",inherit="no")]
	[Style(name="gradientRotation",type="Number",format="Number",inherit="no")]
	[Style(name="gradientTX",type="Number",format="Number",inherit="no")]
	[Style(name="gradientTY",type="Number",format="Number",inherit="no")]
	[Style(name="spreadMethod",type="String",format="String",inherit="no")]
	[Style(name="cornerRadius",type="Number",format="Number",inherit="no")]
	
	public class GradientCanvas extends Canvas
	{
		private var _isStyleChanged:Boolean = true;
		private var _gradientColors:Array;
		private var _gradientAlphas:Array;
		private var _gradientRotation:Number;
		private var _gradientTX:Number;
		private var _gradientTY:Number;
		private var _ratios:Array = [0x00,0xFF];
		private var _cornerRadius:Number;
		private var _spreadMethod:String;
		
		public function GradientCanvas()
		{
			super();
		}
		
		private static var classConstructed:Boolean = classConstruct();
		
		private static function classConstruct():Boolean{
			if(!StyleManager.getStyleDeclaration("GradientCanvas")){
				var styles:CSSStyleDeclaration = new CSSStyleDeclaration();
				styles.defaultFactory = function():void{
					this.gradientColors = [0xffffff,0x000000];
					this.gradientAlphas = [0.5,0.5];
					this.gradientRotation = 1.58;
					this.gradientTX = 0;
					this.gradientTY = 0;
					this.cornerRadius = 0;
					this.spreadMethod = SpreadMethod.PAD;
				}
				StyleManager.setStyleDeclaration("GradientCanvas", styles, true);
			}
			return true;
		}
		
		override public function styleChanged(styleProp:String):void{
			super.styleChanged(styleProp);
			if(styleProp == "gradientColors" || styleProp == "gradientAlphas" || styleProp == "gradientRotation" || styleProp == "gradientTX" || styleProp == "gradientTY" || styleProp == "cornerRadius" || styleProp == "spreadMethod"){
				_isStyleChanged = true;
				invalidateDisplayList();
				return;
			}
		}
		
		override public function validateDisplayList():void{
			_isStyleChanged = true;
			super.validateDisplayList();
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			if(_isStyleChanged){
				_gradientColors = getStyle("gradientColors");
				_gradientAlphas = getStyle("gradientAlphas");
				_gradientRotation = getStyle("gradientRotation");
				_gradientTX = getStyle("gradientTX");
				_gradientTY = getStyle("gradientTY");
				_cornerRadius = getStyle("cornerRadius");
				_spreadMethod = getStyle("spreadMethod");
				
				var matrix:Matrix = new Matrix();
				matrix.createGradientBox(unscaledWidth, unscaledHeight, _gradientRotation, _gradientTX, _gradientTY);
				
				this.graphics.clear();
				this.graphics.beginGradientFill(GradientType.LINEAR, _gradientColors, _gradientAlphas, _ratios, matrix, _spreadMethod);
				this.graphics.drawRoundRect(0,0, unscaledWidth, unscaledHeight, _cornerRadius);
				this.graphics.endFill();
				
				_isStyleChanged = false;
			}
		}
		
	}
}
