﻿package com.pixelrevision.tiler {		import flash.events.EventDispatcher;	import flash.events.Event;		public class Camera extends EventDispatcher{				protected var _x:Number;		protected var _y:Number;				protected var _tiler:Tiler;				/**		 * @constructor		 */		public function Camera(x:Number = 0, y:Number = 0){			_x = x;			_y = y;		}						/**		 * x position of the camera		 */			public function set x(value:Number):void{			_x = value;			dispatchEvent( new Event("CameraMoved") );		}		public function get x():Number{			return _x;		}							/**		 * y position of the camera		 */		public function set y(value:Number):void{			_y = value;			dispatchEvent( new Event("CameraMoved") );		}		public function get y():Number{			return _y;		}			}	}