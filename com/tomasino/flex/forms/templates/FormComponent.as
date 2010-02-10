package com.tomasino.flex.forms.templates
{
	import mx.containers.Canvas;
	import mx.core.UIComponent;

	public dynamic class FormComponent extends Canvas
	{
		private var _label:String;
		prototype.type = "FormComponent";
			
		override public function get label():String{ return _label; }
		override public function set label(value:String):void{ _label = value; }
		
		function FormComponent(){}
		
	}
}
