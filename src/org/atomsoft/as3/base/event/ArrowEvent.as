package org.atomsoft.as3.base.event
{
	import flash.events.Event;
	import flash.geom.Point;
	
	public final class ArrowEvent extends Event
	{
		public static const RORATE:String="rorate";
		private var _fromType:Point;
		private var _toType:Point;
		public function ArrowEvent(from:Point,to:Point)
		{
			super(RORATE);
			_fromType = from;
			_toType = to;
			
		}		

		public function get FromType():Point
		{
			return _fromType;
		}

		public function set FromType(value:Point):void
		{
			_fromType = value;
		}

		public function get ToType():Point
		{
			return _toType;
		}

		public function set ToType(value:Point):void
		{
			_toType = value;
		}


	}
}