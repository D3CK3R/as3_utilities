package com.pixelrevision.utilities{
	
	public class UniqueRandom{
		
		private var _pool:Array;
		private var _start:int;
		private var _end:int;
		
		public function UniqueRandom(start:int, end:int){
			_start = start;
			_end = end;
			reset();
		}
		
		public function reset():void{
			_pool = [];
			for(var i:int=_start; i<=_end; i++){
				_pool.push(i);
			}
		}
		
		public function get():int{
			if(_pool.length < 1){
				reset();
			}
			var ind:int = Math.floor(Math.random() * _pool.length);
			var val:int = _pool[ind];
			_pool.splice(ind, 1);
			return val;
		}
		
	}
}