package com.pixelrevision.animation {
	
	/**
	 * @class	Trails
	 * @description	Simple utility to ease coordinates to a new position.
	 * @author	pixelrevision
	 * @version	0.1
	 */
	
	public class EaseTrails{
		
		private var trails:Array;
		
		/**
		 *	@constructor
		 */
		public function EaseTrails(){
			trails = new Array();
		}
		
		
		/**
		 * Adds a property to the cue to start easing
		 * 
		 * @param	object	The object to target.
		 * @param	prop	The property to move.
		 * @param	newPosition	The position to spring to.
		 * @param	rate	The amount of steps towards the new position.
		 * @param	sensitivity	The smallest amount of an individual step to move befor locking into position and removing from the cue.
		 * Helps avoid conflicts with other motion classes. Default value is true.
		 */
		public function moveTo(object:Object, prop:String, newPosition:Number, rate:Number, sensitivity:Number = .05):void{
			var createArray:Boolean = true;
			var index:Number = 0;
			var i:uint;
			// check to see if the property is already being eased if it is overwrite it.
			for(i=0; i<trails.length; i++){
				if(trails[i]["prop"] == prop && trails[i]["object"] == object){
					index = i;
					createArray = false;
				} 
			}
			// if there are no props create some
			if(trails.length < 1 || createArray == true){
				index = trails.length;
				trails[index] = new Array();
			}
			// add in a new ease
			trails[index]["object"] = object;
			trails[index]["prop"] = prop;
			trails[index]["position"] = newPosition;
			trails[index]["rate"] = rate;
			trails[index]["sensitivity"] = sensitivity;
		}
		
		/**
		 * Stops a trail from easing
		 * 
		 * @param	object	The object to stop.
		 * @param	prop	The prop to stop.
		 */
		public function stopTrail(object:Object, prop:String = "nothing"):void{
			var i:String;
			for(i in trails){
				if(object == trails[i]["object"]){
					if(prop == "nothing" || prop == trails[i]["prop"]){
						trails.splice(i, 1);
					}
				}
			}
		}
		
		/**
		 * Stops all the trails	
		 */
		public function stopAllTrails():void{
			trails = new Array();
		}
		
		/**
		 * Update the trails.	
		 */
		public function render():void{
			var i:String;
			for(i in trails){
				var currentProp:String = trails[i]["prop"];
				var nextStep:Number =  (trails[i]["position"] - trails[i]["object"][currentProp])/trails[i]["rate"];
				if( Math.abs(nextStep) < trails[i]["sensitivity"]){
					trails[i]["object"][currentProp] = trails[i]["position"];
					trails.splice(i, 1);
				}else{
					trails[i]["object"][currentProp] += nextStep;
				}
			}
		}
		
		
		
	
		
	}
	
}
