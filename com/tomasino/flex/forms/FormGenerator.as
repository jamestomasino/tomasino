package com.tomasino.flex.forms
{
	import com.tomasino.flex.forms.templates.FormComponent;
	import com.tomasino.flex.forms.templates.SimpleCombo;
	import com.tomasino.flex.forms.templates.SimpleInput;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import mx.core.UIComponent;
	
	public class FormGenerator extends EventDispatcher
	{
		private var _form:UIComponent;
		private var _xml:XML;
		
		public static const FORM_COMPLETE:String = "form_complete";
		
		public function FormGenerator()
		{
			super();
			_form = new UIComponent();
		}
		
		public function registerTemplate(templateName:String, templateClass:Class):void{
			FormFactory.registerTemplate(templateName, templateClass);
		}
		
		public function loadXML(xml:*):void{
			if(xml is String){
				var loader:URLLoader = new URLLoader(new URLRequest(xml));
				loader.addEventListener(Event.COMPLETE, onXMLLoaded, false, 0, true);
			}else if(xml is XML){
				_xml = xml;
				onXMLLoaded();
			}else{
				throw new Error("loadXML requires either XML or a String");
			}
		}
		
		//Warning, this effectively destroys all component elements! Exterrminaateee!
		public function setContainer(container:UIComponent):void{
			_form = container;
		}
		
		public function get form():UIComponent{ return _form; }
		
		private function onXMLLoaded(e:Event = null):void{
			var configXML:XML;
			if(e){
				configXML = new XML(e.target.data);
			}else{
				configXML = _xml;
			}
			var elements:XMLList = configXML.descendants('element');
			for(var k:int = 0; k < elements.length(); k ++){
				var component:UIComponent;
				component = FormFactory.getComponent(elements[k].@type, {label:elements[k].@label});
				component.id = elements[k].@id;
				addProps(component, elements[k].prop);
				_form.addChild(component);
			}
			this.dispatchEvent(new Event(FormGenerator.FORM_COMPLETE));
		}
		
		private function addProps(component:UIComponent, props:XMLList):void{
			for(var k:int = 0; k < props.length(); k ++){
				if(String(props[k].@value).search("@array=") > -1){
					var array:Array = String(props[k].@value).split(",");
					array[0] = String(array[0]).replace('@array=','');
					component[props[k].@name]= array;
				}else{
					component[props[k].@name] = props[k].@value;
				}
			}
		}
	}
}
