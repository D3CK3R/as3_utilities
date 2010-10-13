﻿package com.pixelrevision.geom{		import flash.geom.Point;		import flash.display.Sprite;		/**	 *	A line segment.	 *	 *	@langversion ActionScript 3.0	 *	@playerversion Flash 9.0	 *	 *	@author Malcolm Wilson	 *	@since  2008-10-24	 */	public class LineSegment{		public var p1:Point;		public var p2:Point;				/**		 *	@constructor		 */		public function LineSegment(pointA:Point, pointB:Point){			p1 = pointA;			p2 = pointB;		}				// --------------------------------------------------------------------------------------------------------------- PUBLIC METHODS		/**		 * Checks if this line segment intersects with another.		 */			public function intersects(lineSegment:LineSegment):Boolean{			if (lineIntersectLine(p1, p2, lineSegment.p1, lineSegment.p2) != null ){				return true;			}			return false;		}				/**		 * Gets the intersection point between this line segment with another.		 */		public function getIntersection(lineSegment:LineSegment):Point{			return lineIntersectLine(p1, p2, lineSegment.p1, lineSegment.p2);		}				/**		 * Gets the intersection point between this line with another.		 */		public function getNonSegmentIntersection(lineSegment:LineSegment):Point{			return lineIntersectLine(p1, p2, lineSegment.p1, lineSegment.p2, false);		}				/**		 * Draws the line on a target sprite.  Useful for debug.		 * @param	target	The sprite to draw in.		 * @param	lineStyle	The style of the line to draw.		 */			public function draw(drawArea:Sprite, lineStyle:Object = null):void{			if(lineStyle == null) lineStyle = new Object();			var thickness:Number = lineStyle.thickness==null?1:lineStyle.thickness; 			var color:uint = lineStyle.color==null?0XFFFF00:lineStyle.color;  			var alpha:Number = lineStyle.alpha==null?1:lineStyle.alpha; 			var pixelHinting:Boolean = lineStyle.pixelHinting==null?false:lineStyle.pixelHinting;			var scaleMode:String = lineStyle.scaleMode==null?"normal":lineStyle.scaleMode;			var caps:String = lineStyle.caps==null?null:lineStyle.caps;			var joints:String = lineStyle.joints==null?null:lineStyle.joints;			var miterLimit:Number = lineStyle.miterLimit==null?3:lineStyle.miterLimit;						drawArea.graphics.lineStyle(thickness, color, alpha, pixelHinting, scaleMode);			drawArea.graphics.moveTo(p1.x, p1.y);			drawArea.graphics.lineTo(p2.x, p2.y);		}				// --------------------------------------------------------------------------------------------------------------- UTIL		private function lineIntersectLine(A:Point, B:Point, E:Point, F:Point, as_seg:Boolean=true):Point{			// found at: http://keith-hair.net/blog/2008/08/04/find-intersection-point-of-two-lines-in-as3/			var ip:Point;			var a1:Number = B.y-A.y;			var a2:Number = F.y-E.y;			var b1:Number = A.x-B.x;			var b2:Number = E.x-F.x;			var c1:Number = B.x*A.y - A.x*B.y;			var c2:Number = F.x*E.y - E.x*F.y;						var denom:Number=a1*b2 - a2*b1;			if(denom == 0){				// if the line segments are paralell return false.				return null;			}			ip = new Point();			ip.x = (b1*c2 - b2*c1)/denom;			ip.y = (a2*c1 - a1*c2)/denom;			// Do checks to see if intersection to endpoints			// distance is longer than actual Segments.			// Return null if it is with any.			if(as_seg){				if(Point.distance(ip,B) > Point.distance(A,B)){					return null;				}				if(Point.distance(ip,A) > Point.distance(A,B)){					return null;				}					if(Point.distance(ip,F) > Point.distance(E,F)){					return null;				}				if(Point.distance(ip,E) > Point.distance(E,F)){					return null;				}			}			return ip;		}					}	}