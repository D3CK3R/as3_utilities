﻿package com.pixelrevision.tiler {		import flash.display.Bitmap;	import flash.display.BitmapData;	import flash.events.Event;		import com.pixelrevision.tiler.*;		public class Tiler extends Bitmap{				protected var _camera:Camera;				protected var _width:Number;		protected var _height:Number;				protected var _children:Array;		protected var _renderItems:Array;		protected var _updateItems:Array;				protected var _oldQuadrantX:Number;		protected var _oldQuadrantY:Number;				protected var _drawBoard:BitmapData;								/**		 *	@constructor		 *	@param	width	The width of the game.		 *	@param	height	The height of the game.		 */		public function Tiler(width:Number = 400, height:Number = 225){			super();			trace("!!!CAUTION: Tiler is not finished.");			_camera = new Camera();						_width = width;			_height = height;						_children = new Array();						_oldQuadrantX = 0;			_oldQuadrantY = 0;						smoothing = true;						refreshBoard();		}				/**		 * Sets the size of the bitmap.			 */			public function refreshBoard():void{			_drawBoard = new BitmapData(_width, _height, true, 0xFFFFFF);			bitmapData = _drawBoard;		}				/**		 * Width will control how much of the map and rendering of characters gets handled.			 * For use of proportionate height add this as a child of a parent sprite and scale that.		 */			override public function set width(value:Number):void{			_width = value;			dispatchEvent( new Event("Resized") );		}		override public function get width():Number{			return _width;		}				/**		 * Height will control how much of the map and rendering of characters gets handled.		 * For use of proportionate height add this as a child of a parent sprite and scale that.		 */		override public function set height(value:Number):void{			_height = value;			dispatchEvent( new Event("Resized") );		}		override public function get height():Number{			return _height;		}				/**		 * Add a tiler sprite to the cue.		 */		public function addChild(child:TilerSprite):TilerSprite{			// make sure we shove in the info for tiler if needed.			_children.push(child);			child.addToTiler(this);			return child;		}				/**		 * Add a tiler sprite to the cue at a specific location.		 */		public function addChildAt(child:TilerSprite, index:int):TilerSprite{			// make sure we shove in the info for tiler if needed.			_children.splice(index, 0, child);			child.addToTiler(this);			return child;		}				/**		 * Remove a tiler sprite from the cue.		 */		public function removeChild(child:TilerSprite):TilerSprite{			for(var i in _children){				if(_children[i] == child){					_children.splice(i, 1);					child.removeFromTiler(this);					return child;				}			}			return child;		}				/**		 * Remove a tiler sprite from the cue at a specified location.		 */		public function removeChildAt(index:int):TilerSprite{			var child:TilerSprite = _children[index];			_children.splice(index, 1);			child.removeFromTiler(this);			return child;		}				/**		 * Access to the camera that focuses all the elements.		 */			public function get camera():Camera{			return _camera;		}				// determines if the quadrant has been changed and if so broadcasts an event		protected function checkQuadrantChange():Boolean{			var quadrantX:Number = Math.floor(_camera.x/width);			var quadrantY:Number = Math.floor(_camera.y/height);			if(quadrantX != _oldQuadrantX || quadrantY != _oldQuadrantY){				_oldQuadrantX = quadrantX;				_oldQuadrantY = quadrantY;				// dispatch an event				var event:TilerEvent = new TilerEvent("QuadrantChanged");				// send out quadrant info				event.info.tiler = this;				dispatchEvent( event );				return true;			}			return false;		}				/**		 * The bounds of each quadrant.			 */		public function get quadrantBounds():Object{			var bounds:Object = new Object();			var xMin:Number = camera.x - width;			var xMax:Number = camera.x + (width * 2);			var yMin:Number = camera.y - height;			var yMax:Number = camera.y + (height * 2);			bounds.xMin = xMin;			bounds.xMax = xMax;			bounds.yMin = yMin;			bounds.yMax = yMax;			return bounds;		}				/**		 * Updates all children eligible for updating.		 */			public function update():void{			var i:uint;			// check the quadrant			checkQuadrantChange();			for(i=0; i<_children.length; i++){				if(_children[i].flaggedForUpdates){					_children[i].update();				}			}		}				/**		 * Updates all children eligible for rendering.		 */		public function render():void{			var i:uint;						refreshBoard();			_drawBoard.lock();			for(i=0; i<_children.length; i++){				if(_children[i].flaggedForDrawing){					_children[i].draw(this);				}			}			_drawBoard.unlock();		}				/**		 * The board that is drawn to.		 */		public function get drawBoard():BitmapData{			return _drawBoard;		}								}	}