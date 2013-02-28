package org.atomsoft.as3.base
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import org.atomsoft.as3.base.event.*;
	
   
	
	public class WorkflowNode extends Sprite
	{
		private var _poisition:Point;
		protected var offsetX:Number; 
		protected var offsetY:Number;				
		private var _focused:Boolean = false;
		private var traceOn:Boolean = false;
		public function WorkflowNode()
		{
			super();		
			
			addEventListener(MouseEvent.MOUSE_DOWN, startDragging); 
			addEventListener(MouseEvent.MOUSE_UP, stopDragging);		
			addEventListener(EffectiveEvent.FOCUS, onFocus);		
			addEventListener(EffectiveEvent.UNFOCUS, onUnFocus); 
			addEventListener(MouseEvent.DOUBLE_CLICK,dblclick);
			
		}
		
		protected function dblclick(event:MouseEvent):void
		{
			//override this function to implement bizness logic			
		}
		
		// This function is called when the mouse button is pressed. 
		protected function startDragging(event:MouseEvent):void 
		{ 
						
			
			offsetX = event.stageX - this.x; 
			offsetY = event.stageY - this.y; 
			
			// tell Flash Player to start listening for the mouseMove event 
			stage.addEventListener(MouseEvent.MOUSE_MOVE, dragthis); 
		} 
		
		// This function is called when the mouse button is released. 
		protected function stopDragging(event:MouseEvent):void 
		{ 
			// Tell Flash Player to stop listening for the mouseMove event. 
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, dragthis); 
		} 
		
		
		protected function dragthis(event:MouseEvent):void 
		{ 
			
			this.x = event.stageX - offsetX; 
			this.y = event.stageY - offsetY; 
		
			event.updateAfterEvent(); 
		} 
		
		protected function onFocus(evt:EffectiveEvent):void
		{
			if(!_focused){
			    var dp:DisplayObject = evt.currentTarget as DisplayObject;
			    dp.filters = evt.Filter;
				_focused = true;	
			}
		}
		
		protected function onUnFocus(evt:EffectiveEvent):void
		{
			if(_focused){
				var dp:DisplayObject = evt.target as DisplayObject;
				dp.filters = null;
				_focused=false;
			}
	    
			stopDragging(null);
		}
		
		public function set TraceOn(t:Boolean):void{
			this.traceOn = t;
		}
		
		public function get TraceOn():Boolean{
			return this.traceOn;
		}
		
		
		public override function  toString():String{
			return super.toString()+"@"+new Date().toString();
		}

		/**指示元素是否聚焦*/
		public function get Focused():Boolean
		{
			return _focused;
		}
		
		public function get Poisition():Point{
			return this._poisition;
		}
		
		public function set Poisition(v:Point):void{
			this._poisition = v;
		}

	}
}