package com.tomasino.flex.forms
{
	import com.tomasino.flex.forms.templates.FormComponent;
	
	import mx.collections.ArrayCollection;
	import mx.core.UIComponent;
	
	public class FormFactory
	{
		private static var _componentList:ArrayCollection;
		private static var _componentNames:ArrayCollection;
		
		public function FormFactory(){}
		
		public static function registerTemplate(name:String, component:Class):void{
			if(!_componentList){
				_componentList = new ArrayCollection(); 
				_componentNames = new ArrayCollection();
			}
			//if(component is UIComponent){
				if(!_componentList.contains(component)){
					_componentList.addItem(component);
					_componentNames.addItem(name);
				} 
			//}else{
			//	throw new Error("Components registered to FormFactory must be children of the UIComponent class.");	
			//}
		}
		
		public static function clearTemplates():void{
			_componentList = new ArrayCollection();
			_componentNames = new ArrayCollection();
		}
		
		public static function getComponent(name:String, params:Object = null):*{
			var componentClass:Class = _componentList.getItemAt(_componentNames.getItemIndex(name)) as Class;
			var component:UIComponent = new componentClass() as UIComponent;
			if(params) parseParams(component, params);
			return component;
		}
		
		private static function parseParams(component:UIComponent, params:Object):void{
			for(var k:String in params){
				component[k] = params[k];
			}
		}

	}
}
