

package com.pixelrevision.utilities{
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	public class PerformanceMeter extends Sprite {
	
		private var _textField:TextField;
		private var _format:TextFormat;
		private var _timer:Timer;
		private var _frames:int;
		
		/**
		 * quickly display info about frames per second and memory usage.
		 */ 
		public function PerformanceMeter() {
			_format = new TextFormat("_sans", 11, 0xCCCCCC);
			_frames = 0;
			_textField = new TextField();
			_textField.width = 0;
			_textField.height = 0;
			_textField.autoSize = TextFieldAutoSize.LEFT;
			_textField.selectable = false;
			_textField.defaultTextFormat = _format;
			addChild(_textField);
			_timer = new Timer(1000);
			_timer.addEventListener(TimerEvent.TIMER, displayInfo, false, 0, true);
			this.addEventListener(Event.ENTER_FRAME, increaseFrame, false, 0, true);
			_timer.start();
		}
		
		protected function displayInfo(e:TimerEvent):void {
			var text:String = "fps: " + _frames + " mem: " + Math.round(System.totalMemory/(1024*1024)) + " MB";
			_textField.text = text;
			_frames = 0;
		}
		
		private function increaseFrame(e:Event):void {
			++_frames;
		}
		
	}
}