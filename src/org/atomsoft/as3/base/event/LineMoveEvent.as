package org.atomsoft.as3.base.event
{
	import flash.geom.Point;

	/**
	 * 连线移动的事件
	 * */
	public class LineMoveEvent extends DrawEvent
	{
		public var header:Point;
		public var tailer:Point;		
		public static const DRAW:String ="draw";
		/**
		 * 构造连线移动事件
		 * */
		public function LineMoveEvent(mt:String=DRAW)
		{
			
			super(mt);
		}		

	}
}