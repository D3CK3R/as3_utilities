package com.pixelrevision.geom{
	import flash.display.Sprite;
	import flash.geom.Point;
	
	
	public class Vector{
		
		private var _pointA:Point;
		private var _pointB:Point;
		
		private var _angle:Number;
		private var _distance:Number;
		
		public function Vector(position:Point = null, angle:Number = 0, distance:Number = 1){
			_pointA = position == null ? new Point(0, 0) : position; 
			_angle = angle;
			_distance = distance;
			updateFromAngleAndDistance();
		}
		/**
		 * The angle of the vector.
		 */ 
		public function set angle(value:Number):void{
			_angle = value;
			updateFromAngleAndDistance();
		}
		public function get angle():Number{
			return _angle;
		}
		
		/**
		 * The angle of the vector in degrees.
		 */
		public function set angleDegrees(value:Number):void{
			angle = value * Math.PI/180;
		}
		public function get angleDegrees():Number{
			return angle * 180/Math.PI;
		}
		
		/**
		 * The distance of the vector.
		 */
		public function set distance(value:Number):void{
			_distance = value;
			updateFromAngleAndDistance();
		}
		public function get distance():Number{
			return _distance;
		}
		
		/**
		 * The base point of the vector.
		 */
		public function set pointA(value:Point):void{
			_pointA = value;
			updateFromAngleAndDistance();
		}
		public function get pointA():Point{
			return _pointA;
		}
		
		/**
		 * The projected point of the vector.
		 */
		public function set pointB(value:Point):void{
			_distance = Math.sqrt(Math.pow( (_pointA.x-value.x), 2) + Math.pow( (_pointA.y-value.y), 2));
			_angle = Math.atan2(value.y - _pointA.y, value.x - _pointA.x);
			updateFromAngleAndDistance();
		}
		public function get pointB():Point{
			return _pointB;
		}
		
		/**
		 * The origin point x of the vector.  Use this to move.
		 */
		public function set origX(value:Number):void{
			_pointA.x = value;
			updateFromAngleAndDistance();
		}
		public function get origX():Number{
			return _pointA.x;
		}
		
		/**
		 * The amount of projection the vector is making.
		 */
		public function get projectionX():Number{
			return _pointB.x - _pointA.x;
		}
		/**
		 * The amount of projection the vector is making.
		 */
		public function get projectionY():Number{
			return _pointB.y - _pointA.y;
		}
		
		
		/**
		 * Checks if this vector intersects with another.
		 */	
		public function intersects(vector:Vector):Boolean{
			if (lineIntersectLine(this.pointA, this.pointB, vector.pointA, vector.pointB) != null ){
				return true;
			}
			return false;
		}
		
		/**
		 * Gets the intersection point between this vector segment with another.
		 */
		public function getIntersection(vector:Vector):Point{
			if(!intersects(vector)){
				throw new Error(vector + "and " + vector + " cannot intersect");
			}
			return lineIntersectLine(this.pointA, this.pointB, vector.pointA, vector.pointB);
		}
		
		
		
		/**
		 * The final point of the vector.
		 */
		public function get projection():Point{
			return _pointB;
		}
		
		/**
		 * Normalizes the vector
		 */
		public function normalize():void{
			distance = 1;
		}
		
		
		protected function updateFromAngleAndDistance():void{
			_pointB = new Point();
			_pointB.x = (Math.cos(_angle) * _distance) + _pointA.x;
			_pointB.y = (Math.sin(_angle) * _distance) + _pointA.y;
		}
		
		/**
		 * Draws the vector.
		 */
		public function draw(drawArea:Sprite, lineStyle:Object = null):void{
			if(lineStyle == null) lineStyle = new Object();
			var thickness:Number = lineStyle.thickness==null?1:lineStyle.thickness; 
			var color:uint = lineStyle.color==null?0XFFFF00:lineStyle.color;  
			var alpha:Number = lineStyle.alpha==null?1:lineStyle.alpha; 
			var pixelHinting:Boolean = lineStyle.pixelHinting==null?false:lineStyle.pixelHinting;
			var scaleMode:String = lineStyle.scaleMode==null?"normal":lineStyle.scaleMode;
			var caps:String = lineStyle.caps==null?null:lineStyle.caps;
			var joints:String = lineStyle.joints==null?null:lineStyle.joints;
			var miterLimit:Number = lineStyle.miterLimit==null?3:lineStyle.miterLimit;
			
			drawArea.graphics.lineStyle(thickness, color, alpha, pixelHinting, scaleMode);
			drawArea.graphics.moveTo(_pointA.x, _pointA.y);
			drawArea.graphics.lineTo(_pointB.x, _pointB.y);
		}
		
		private function lineIntersectLine(A:Point, B:Point, E:Point, F:Point, as_seg:Boolean=true):Point{
			// found at: http://keith-hair.net/blog/2008/08/04/find-intersection-point-of-two-lines-in-as3/
			var ip:Point;
			var a1:Number = B.y-A.y;
			var a2:Number = F.y-E.y;
			var b1:Number = A.x-B.x;
			var b2:Number = E.x-F.x;
			var c1:Number = B.x*A.y - A.x*B.y;
			var c2:Number = F.x*E.y - E.x*F.y;
			
			var denom:Number=a1*b2 - a2*b1;
			if(denom == 0){
				// if the line segments are paralell return false.
				return null;
			}
			ip = new Point();
			ip.x = (b1*c2 - b2*c1)/denom;
			ip.y = (a2*c1 - a1*c2)/denom;

			// Do checks to see if intersection to endpoints
			// distance is longer than actual Segments.
			// Return null if it is with any.
			if(as_seg){
				if(Point.distance(ip,B) > Point.distance(A,B)){
					return null;
				}
				if(Point.distance(ip,A) > Point.distance(A,B)){
					return null;
				}	

				if(Point.distance(ip,F) > Point.distance(E,F)){
					return null;
				}
				if(Point.distance(ip,E) > Point.distance(E,F)){
					return null;
				}
			}
			return ip;
		}

	}
}