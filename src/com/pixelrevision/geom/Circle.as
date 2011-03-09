package com.pixelrevision.geom{
	
	import flash.geom.Point;
	
	public class Circle extends Point{
		
		private var _radius:Number;
		private static const TOUCH_DISTANCE:Number = 0.00000000000001;
		
		public function Circle(x:Number=0, y:Number=0, rad:Number = 10){
			super(x, y);
			_radius = rad;
		}
		
		public function intersectsCircle(circle:Circle):Boolean{
			var distanceX:Number = circle.x - this.x;
			var distanceY:Number = circle.y - this.y;
			var distance:Number = Math.sqrt( (distanceX * distanceX) + (distanceY * distanceY));
			if (distance > circle.radius + this.radius) {
				return false;
			}else{
				return true;
			}
			return false;
		}
		
		public function containsPoint(point:Point):Boolean{
			var dist:Number = Math.sqrt((this.x - point.x) * 2 + (this.y - point.y) * 2);
			return dist <= radius;
		}
		
		public function set radius(value:Number):void{
			_radius = value;
		}
		public function get radius():Number{
			return _radius;
		}
		
	}
}