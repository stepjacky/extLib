package com.atomsoft.ui
{
	import flash.display.NativeWindow;
	import flash.display.NativeWindowInitOptions;
	import flash.display.NativeWindowSystemChrome;
	import flash.display.NativeWindowType;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	
	public class AlertWindow extends NativeWindow
	{
		private var _showTimer:Timer;
		private var _delayTimer:Timer;
		private var _hideTimer:Timer;
		
		private var _delayTime:int;
		private var _title:String;
		private var _message:String;
		private var _width:int;
		private var _height:int;
		
		public function AlertWindow(title:String,message:String,delayTime:int=3,width:int=200,height:int=100)
		{
			_delayTime=delayTime;
			_title=title;
			_message=message;
			_width=width;
			_height=height;
			var initOptions:NativeWindowInitOptions = new NativeWindowInitOptions();
			initOptions.resizable = false; 
			initOptions.transparent = false;
			initOptions.maximizable = false;
			initOptions.minimizable = false;
			initOptions.systemChrome = NativeWindowSystemChrome.ALTERNATE;
			initOptions.type = NativeWindowType.UTILITY;
			super(initOptions);
		}
		
		override public function activate():void{
			this.title = _title;     
			this.width = _width;
			this.height = _height;
			this.x = flash.display.Screen.mainScreen.bounds.width - (this.width + 20);
			this.y = flash.display.Screen.mainScreen.bounds.height - 20;
			var tf:TextField = new TextField();
			tf.text=_message;;
			tf.width=_width;
			tf.height=_height;
			tf.wordWrap=true;
			this.stage.addChild(tf);
			this.stage.align = StageAlign.TOP_LEFT;
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			
			super.activate();
			
			_showTimer = new Timer(20,0);
			_showTimer.addEventListener("timer", showTimerHandler);
			_showTimer.start();
		}
		
		public function showTimerHandler(event:TimerEvent):void {
			this.y -= 10;
			if(this.y <= (flash.display.Screen.mainScreen.bounds.height - (this.height + 20))){
				_showTimer.stop();
				_delayTimer = new Timer(1000,_delayTime);
				_delayTimer.addEventListener("timer", delayTimerHandler);
				_delayTimer.start();
			}
		}
		
		
		
		public function delayTimerHandler(event:TimerEvent):void {
			var t:Timer = Timer(event.target);
			if(t.currentCount == _delayTimer.repeatCount){
				_hideTimer = new Timer(20,999);
				_hideTimer.addEventListener("timer", hideTimerHandler);
				_hideTimer.start();
			}
		}
		
		public function hideTimerHandler(event:TimerEvent):void {
			if(this.closed)return;
			this.y += 10;
			if(this.y >= (flash.display.Screen.mainScreen.bounds.height-20)){
				this.close();
				_hideTimer.stop();
			}
		}
		
	}
}