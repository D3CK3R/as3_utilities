package com.pixelrevision.filters.util{
	
	import flash.display.Shader;
	import flash.display.ShaderParameter;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;

	/**
	 * Creates a class for a .pbj file 
	 */
	public class ShaderFilterMaker extends Sprite{

		private var shader:Shader;
		private var browseButton:Sprite;
		private var saveButton:Sprite;
		private var output:TextField;
		private var className:String;
		private static const format:TextFormat = new TextFormat("Monaco", 11);
		
		private var fr:FileReference;
		private static const FILE_TYPES:Array = [new FileFilter("Pixel Bender Filter", "*.pbj")];
		
		
		public function ShaderFilterMaker(){
			createView();
		}
		
		// ------------------------------------------------------------------------------------------- FILE HANDLNG
		// browse for the file
		private function loadFile(e:MouseEvent):void{
			fr = new FileReference();
			fr.addEventListener(Event.SELECT, fileSelected);
			fr.addEventListener(Event.CANCEL, fileSelectCancelled);
			fr.browse(FILE_TYPES);
			if( contains(saveButton) ){
				removeChild(saveButton);
			}
		}
		
		// when the file has been selected load it
		private function fileSelected(e:Event):void{
			fr.removeEventListener(Event.SELECT, fileSelected);
			fr.removeEventListener(Event.CANCEL, fileSelectCancelled);
			fr.addEventListener(Event.COMPLETE, onLoadComplete);
			fr.addEventListener(IOErrorEvent.IO_ERROR, onLoadError);
			fr.load();
		}
		
		// when the file has been loaded generate the actionscript
		private function onLoadComplete(e:Event):void{
			fr.removeEventListener(Event.COMPLETE, onLoadComplete);
			fr.removeEventListener(IOErrorEvent.IO_ERROR, onLoadError);
			var pbd:ByteArray = fr.data as ByteArray;
			shader = new Shader(pbd);
			output.text = generateActionscript();
			fr = null;
			if( !contains(saveButton) ){
				addChild(saveButton);
			}
		}
		
		// fule cancelled do nothing
		private function fileSelectCancelled(e:Event):void{
			fr.removeEventListener(Event.SELECT, fileSelected);
			fr.removeEventListener(Event.CANCEL, fileSelectCancelled);
			fr = null;
		}
		
		// there was an error loading
		private function onLoadError(e:IOErrorEvent):void{
			fr.removeEventListener(Event.COMPLETE, onLoadComplete);
			fr.removeEventListener(IOErrorEvent.IO_ERROR, onLoadError);
			output.text = "Error loading file";
		}
		
		private function saveFile(e:MouseEvent):void{
			var saveFile:FileReference = new FileReference();
			saveFile.save(output.text, className + ".as");
		}

		// ------------------------------------------------------------------------------------------- VIEW
		
		private function createView():void{
			browseButton = drawButton("browse");
			addChild(browseButton);
			browseButton.addEventListener(MouseEvent.MOUSE_DOWN, loadFile);
			
			output = new TextField();
			output.multiline = true;
			
			output.y = browseButton.height;
			output.defaultTextFormat = format;

			addChild(output);
			output.text = "browse for a valid .pbj to generate actionscript";
			addEventListener(Event.ADDED, addedToStage);
			
			saveButton = drawButton("save");
			saveButton.x = browseButton.x + browseButton.width + 5;
			saveButton.addEventListener(MouseEvent.MOUSE_DOWN, saveFile);
		}
		
		private function addedToStage(e:Event):void{
			removeEventListener(Event.ADDED, addedToStage);
			output.width = stage.stageWidth;
			output.height = stage.stageHeight - browseButton.height;
		}
		
		private function drawButton(label:String):Sprite{
			var button:Sprite = new Sprite();
			var buttonText:TextField = new TextField();
			buttonText.defaultTextFormat = format;
			buttonText.selectable = false;
			buttonText.text = label;
			buttonText.x = 5;
			buttonText.y = 5;
			buttonText.autoSize = "left";
			button.addChild(buttonText);
			
			button.graphics.beginFill(0XCCCCCC);
			button.graphics.drawRoundRect(0, 0, buttonText.width + 10, buttonText.height + 10, 5, 5);
			
			return button;
		}
		
		// ------------------------------------------------------------------------------------------- GENERATE AS
		public function generateActionscript():String{
			var getterSetter:String;
			
			var items:Array = new Array();
			var p:Array = new Array();
			var v:Array = new Array();
			var params:String = "";
			var getterSetters:String = "";
			var author:String = "";
			var description:String = "";
			var version:String = "";
			
			for(var i:String in shader.data){
				if(i == "name"){
					className = shader.data[i] + "Filter";
				}else if(shader.data[i] is ShaderParameter){
					p.push(i);
					v.push(shader.data[i].value);
					trace(i + " : " + typeof(shader.data[i].value) );
				}else if(i == "author"){
					author = shader.data[i];
				}else if(i == "description"){
					description = shader.data[i];
				}else if(i == "version"){
					version = shader.data[i];
				}
			}
			trace("--------");
			
			for (var j:uint = 0; j<p.length; j++){
				// define parameters
				params += "_" + p[j] + ":Number = " + v[j];
				if(j != p.length - 1) params += ", ";
				getterSetters += makeGetterSetter(p[j]);
			}
			
			var val:String = "package{\n\n";
			val += "\timport flash.display.Shader;\n";
			val += "\timport flash.display.ShaderParameter\n";
			val += "\timport flash.utils.ByteArray;\n";
			val += "\timport flash.filters.ShaderFilter;\n\n";
			val +="\t/**\n";
			val +="\t * @name " + className + "\n";
			val +="\t * @author " + author + "\n";
			val +="\t * @description " + description + "\n";
			val +="\t * @version " + version + "\n";
			val +="\t */";
			val += "\n\tpublic class " + className + " extends ShaderFilter{\n";
			val += "\t\t[Embed(source=\"" + fr.name + "\", mimeType=\"application/octet-stream\")]\n";
			val += "\t\tprivate var PixelBenderData:Class;\n\n";
			val += "\t\tpublic function " + className + "(" + params + "){\n";
			val += "\t\t\tvar pbd:ByteArray = new PixelBenderData() as ByteArray;\n";
			val += "\t\t\tshader = new Shader(pbd);\n";
			for(j=0; j<p.length; j++){
				val += "\t\t\t" + p[j] + " = _" + p[j] + ";\n";
			}
			val += "\t\t}\n\n";
			val += getterSetters;
			val += "\t}\n";
			val += "}";
			return val;
		}
		
		private function makeGetterSetter(name:String):String{
			var val:String = "\t\tpublic function set " + name + "(value:Number):void{\n";
			val += "\t\t\tshader.data." + name + ".value[0] = value;\n";
			val += "\t\t}\n";
			val += "\t\tpublic function get " + name + "():Number{\n";
			val += "\t\t\treturn shader.data." + name+ ".value[0];\n";
			val += "\t\t}\n\n";
			return val;
		}
		
	}
}
