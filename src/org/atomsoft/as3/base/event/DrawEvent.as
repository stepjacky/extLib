package org.atomsoft.as3.base.event
{
	import flash.events.Event;
	
	public class DrawEvent extends Event
	{
		public static const DRAW:String ="draw";
		public static const UNDECORATE:String="undecorate";
		public static const DECORATE:String="decorate";
		public var dx:uint=0;
		public var dy:uint=0;
		public function DrawEvent(mt:String=DRAW)
		{
			super(DRAW, false, false);
		}
		
		public override function clone():Event
		{
		    return new DrawEvent();	
		}
	}
}