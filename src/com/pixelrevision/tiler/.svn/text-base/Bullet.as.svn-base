package com.pixelrevision.tiler {
	
	import com.pixelrevision.tiler.*;
	
	public class Bullet extends TilerSprite{
		
		protected var _sprite:Sprite;
		
		/**
		 *	@constructor
		 */
		public function Bullet(){
			super();
			
			_sprite = new Sprite();
			_sprite.graphics.beginFill(0xCCCCCC, .75);
			_sprite.graphics.lineStyle(1, 0x999999);
			_sprite.graphics.drawRect(0, 0, 2, 2);
			_sprite.graphics.endFill();
		}
		
		public function checkCollisionWithCharacter(character:Character):Boolean{
			if(x>character.x && x>character.x + character.tileWidth){
				if(y>character.y && y>character.y + character.tileHeight){
					return true;
				}
			}
			return false;
		}
		
				
		override public function draw(tiler:Tiler):void{
			// create an offset
			var offsetMatrix:Matrix = new Matrix();
			offsetMatrix.tx = x  -tiler.camera.x + (tiler.width/2);
			offsetMatrix.ty = y - tiler.camera.y + (tiler.height/2);
			// redraw the bitmap
			tiler.drawBoard.draw(_sprite, offsetMatrix);
		}
		
	}
	
}
