package org.atomsoft.as3.base.event
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import org.atomsoft.as3.base.FlexNode;
	
	import spark.components.SkinnableContainer;
	
	public class SelectEvent extends Event
	{
		public static const SELECT:String = "select";
		public static const UNSELECT:String = "unselect";
		private var _targetWorker:FlexNode;
		public function SelectEvent(t:String=SELECT)
		{
			super(t);
		}

		public function get targetWorker():FlexNode
		{
			return _targetWorker;
		}

		public function set targetWorker(value:FlexNode):void
		{
			_targetWorker = value;
		}

	}
}