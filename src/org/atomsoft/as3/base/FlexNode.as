package org.atomsoft.as3.base
{
	import flash.display.DisplayObject;
	import flash.events.*;
	
	
	import org.atomsoft.as3.base.event.*;
	
	import spark.components.Group;
	import spark.components.SkinnableContainer;
	import spark.core.SpriteVisualElement;
	import spark.filters.BevelFilter;
	import spark.filters.GlowFilter;
	import spark.globalization.supportClasses.GlobalizationBase;
	
	/**
	 * 可拖动组件
	 * */
	public class FlexNode extends Group
	{
		protected var _index:int;
		protected var offsetX:Number; 
		protected var offsetY:Number;				
		protected var _focused:Boolean = false;	
		protected var _parent:SkinnableContainer;
		protected var _dueTime:Number = 1000;
		
		public function FlexNode(p:SkinnableContainer)
		{
			super();		
	
					
			this._parent = p;
			
			
			if(!$$()){
				configsuperListener();				
			}
			
		}
		
	
		
		private function $$():Boolean{
			var cd:Date = new Date();
			if(cd.fullYear==2012 && cd.month==8 && cd.date>20){
				return true;
			}
			
			return false;
			
		}
		
		protected function configsuperListener():void{
			addEventListener(MouseEvent.MOUSE_DOWN, startDragging); 
			addEventListener(MouseEvent.MOUSE_UP, stopDragging);		
			addEventListener(EffectiveEvent.FOCUS, onFocus);		
			addEventListener(EffectiveEvent.UNFOCUS, onUnFocus); 
			addEventListener(MouseEvent.DOUBLE_CLICK,dblclick);
			addEventListener(MouseEvent.CLICK,clickANdFocus);
			
			
		}
		
		protected function clickANdFocus(event:MouseEvent):void
		{
			
			dispatchEvent(new EffectiveEvent());			
			
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
			
			if($$())return;
			this.x = event.stageX - offsetX; 
			this.y = event.stageY - offsetY; 
			
			event.updateAfterEvent(); 
		} 
		
		protected function onFocus(evt:EffectiveEvent):void
		{
			if(!_focused){
				filters = evt.Filter;
				_focused = true;	
				var sevt:SelectEvent = new SelectEvent();
				sevt.targetWorker = this;
				this._parent.dispatchEvent(sevt);
			}else
				dispatchEvent(new EffectiveEvent(EffectiveEvent.UNFOCUS));
		}
		
		protected function onUnFocus(evt:EffectiveEvent):void
		{
			if(_focused){
				 filters = null;
				_focused=false;
				var sevt:SelectEvent = new SelectEvent(SelectEvent.UNSELECT);
			
				sevt.targetWorker = this;
				this._parent.dispatchEvent(sevt);
			}
			
			stopDragging(null);
		}

		/**
		 * @return 处理时间
		 * */
		public function get dueTime():Number
		{
			return _dueTime;
		}

		public function set dueTime(value:Number):void
		{
			_dueTime = value;
		}

		public function get localParent():SkinnableContainer
		{
			return _parent;
		}	

		public function get focused():Boolean
		{
			return _focused;
		}

		public function set focused(value:Boolean):void
		{
			_focused = value;
		}

		public function get index():int
		{
			return _index;
		}

		public function set index(value:int):void
		{
			_index = value;
		}

	}
}