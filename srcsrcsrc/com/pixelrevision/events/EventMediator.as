package com.pixelrevision.events{
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.*;

	public class EventMediator{
		
		protected static var _listeners:Array = [];
		protected static var _dispatchers:Array = [];
		protected static var _cancelCurrentDispatch:Boolean;
		
		/**
		 * This adds a dispatcher to the mediator for a specific event on a specific object.
		 * @param	type	The type of event dispatched by the object.  Will be broadcast to all objects listening for it.
		 * @param	dispatcher	The object that will dispatch the event.
		 */ 
		public static function registerEventSender(type:String, dispatcher:EventDispatcher):void{
			var dis:Object = {type: type, dispatcher: dispatcher};
			_dispatchers.push(dis);
			dispatcher.addEventListener(type, notify);
		}
		
		/**
		 * Stops the EventMediator from watching a specific object for a specific event to fire.
		 * @param	type	The type of event we want to stop watching.
		 * @param	dispatcher	The object that is associated with the event.  If left blank will remove all event dispatchers associated with the event type.
		 */
		public static function unregisterEventSender(type:String, dispatcher:EventDispatcher = null):void{
			var i:uint;
			for(i=0; i<_dispatchers.length; i++){
				if(_dispatchers[i].type == type){
					if(_dispatchers[i].dispatcher == dispatcher){
						_dispatchers.splice(i, 1);
						dispatcher.removeEventListener(type, notify);
						break;
					}else if(dispatcher == null){
						_dispatchers[i].dispatcher.removeEventListener(_dispatchers[i].type, notify);
						_dispatchers.splice(i, 1);
						if(_dispatchers.length == 0){
							break;
						}
						i--;
					}
				}
			}
		}
		
		/**
		 * This will register a listener for a specific event.
		 * @param	type	The type of event to listen for
		 * @param	listener	The listener function to call when the event has been dispatched.
		 * @param	target	The object listening for the event.  Used only for checking objects registered to recieve events.
		 */ 
		public static function registerEventListener(type:String, listener:Function, target:Object):void{
			var ls:Object = {type: type, listener: listener, target: target};
			_listeners.push(ls);
		}
		
		/**
		 * Will unregister an event listener from the EventMediator.
		 * @param	type	The event to stop listening for.
		 * @param	listener	The listener function.  If left blank then all listeners of the event will be removed.
		 * @param	target	The target object listening for the event to be sent. If left blank then all listeners of the event will be removed.
		 */ 
		public static function unregisterEventListener(type:String, listener:Function = null, target:Object = null):void{
			var i:uint;
			for(i=0; i<_listeners.length; i++){
				if(_listeners[i].type == type){
					if(listener == null || target == null){
						_listeners.splice(i, 1);
						if(_listeners.length == 0){
							break;
						}
						i--;
					}else if( _listeners[i].listener == listener && _listeners[i].target == target){
						_listeners.splice(i, 1);
						break;
					}
				}
			}
		}
		
		/**
		 * This passes off the event to all registered listeners.
		 */ 
		protected static function notify(e:Event):void{
			var i:uint;
			for(i=0; i<_listeners.length; i++){
				trace("next");
				if(_cancelCurrentDispatch == true){
					_cancelCurrentDispatch = false;
					return;
				}
				if(e.type == _listeners[i].type){
					// check if the object exists and delete the listener if not
					if(_listeners[i].listener == null){
						_listeners.splice(i, 1);
						if(_listeners.length == 0){
							break;
						}
						i--;
					}else{
						_listeners[i].listener.apply(null, [e]);
					}
				}
			}
		}
		
		/**
		 * A list of all the listeners associated with the EventMediator
		 */ 
		public static function get listeners():Array{
			return _listeners;
		}
		
		/**
		 * A list of all the event senders associated with the EventMediator
		 */ 
		public static function get dispatchers():Array{
			return _dispatchers;
		}
		
		/**
		 * A list of objects registered with the EventMediator to be notified of a specific event.
		 * @param	type	The type of event to check for.
		 */ 
		public static function getRegisteredListenerList(type:String):Array{
			var i:uint;
			var ls:Array;
			for(i=0; i<_listeners.length; i++){
				if(_listeners[i].type == type){
					ls.push(_listeners[i].target);
				}
			}
			return ls;
		}
		
		/**
		 * A list of objects that the mediator is watching for a specific event to fire from.
		 * @param	type	The type of event to check for.
		 */ 
		public static function getRegisteredSendersList(type:String):Array{
			var i:uint;
			var dis:Array;
			for(i=0; i<_dispatchers.length; i++){
				if(_dispatchers[i].type == type){
					dis.push(_dispatchers[i].dispatcher);
				}
			}
			return dis;
		}
		
		/**
		 * Cancels whatever event may be sending notifications to listener objects.
		 */ 
		public static function cancelCurrentDispatch():void{
			_cancelCurrentDispatch = true;
		}
		
		
	}
}