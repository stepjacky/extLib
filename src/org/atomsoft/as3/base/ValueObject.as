package org.atomsoft.as3.base
{
	public dynamic class ValueObject extends Object
	{
		private var _state:int = 0;
		public function ValueObject()
		{
			super();
			state = 0;
		}

		
		/**
		 *@return  0 if not presient visa 1
		 * */
		public function get state():int
		{
			return _state;
		}

		public function set state(value:int):void
		{
			_state = value;
		}

	}
}