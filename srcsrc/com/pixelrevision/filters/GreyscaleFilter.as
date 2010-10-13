﻿package com.pixelrevision.filters{		import flash.filters.ColorMatrixFilter;	import flash.geom.Matrix;			public class GreyscaleFilter{				private var matrix:Array = new Array();		private static var IDENTITY:Array =[1,0,0,0,0,											  0,1,0,0,0,											  0,0,1,0,0,											  0,0,0,1,0];						// RGB to Luminance conversion constants as found on		// Charles A. Poynton's colorspace-faq:		// http://www.faqs.org/faqs/graphics/colorspace-faq/				private static var r_lum:Number = 0.212671;		private static var g_lum:Number = 0.715160;		private static var b_lum:Number = 0.072169;				private var _filter:ColorMatrixFilter;						public function GreyscaleFilter(){			matrix = IDENTITY.concat();			desaturate();			_filter= new ColorMatrixFilter(matrix);		}				// removes all color		private function desaturate():void{			var mat:Array =  [ r_lum, g_lum, b_lum, 0, 0,							 r_lum, g_lum, b_lum, 0, 0,							 r_lum, g_lum, b_lum, 0, 0,							 0    , 0    , 0    , 1, 0 ];									concat(mat);		}				private function concat(mat:Array):void{						var temp:Array = new Array();			var i:Number = 0;						for (var y:Number = 0; y < 4; y++ ){				for (var x:Number = 0; x < 5; x++ ){					temp[i + x] = mat[i    ] * matrix[x     ] + 								   mat[i+1] * matrix[x +  5] + 								   mat[i+2] * matrix[x + 10] + 								   mat[i+3] * matrix[x + 15] +								   (x == 4 ? mat[i+4] : 0);				}				i+=5;			}			matrix = temp;		}				public function get filter():ColorMatrixFilter{			return _filter;		}	}}