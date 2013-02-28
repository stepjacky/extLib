package org.jackysoft.util
{
	public class RandomUtil
	{
		public static function randRange(min:Number, max:Number):Number {
			var randomNum:Number = Math.floor(Math.random() * (max - min + 1)) + min;
			return randomNum;
		}
	}
}