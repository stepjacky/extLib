package com.atomsoft.ui
{ import flash.desktop.NativeApplication;  
	import flash.desktop.NotificationType;  
	import flash.desktop.SystemTrayIcon;  
	import flash.display.Bitmap;  
	import flash.display.BitmapData;  
	import flash.events.TimerEvent;  
	import flash.filters.ColorMatrixFilter;  
	import flash.geom.Point;  
	import flash.geom.Rectangle;  
	import flash.utils.Timer;  
	public class IconManager
	{
		/** 
		 *  @private 
		 *  stores the Array of bitmaps tobe used as icons 
		 */  
		private var sysDockIconBitmaps:Array = new Array();  
		/** 
		 *  @private 
		 *  stores the Array of altered bitmaps tobe used as icons 
		 */  
		private var alteredSysDockIconBitmaps:Array = new Array();  
		/** 
		 *  @private 
		 *  stores the alertType, defaults to NotificationType.CRITICAL 
		 */  
		private var alertType:String = NotificationType.CRITICAL;  
		/** 
		 *  @private 
		 *  used as an indicator to determine which state of icon to display 
		 */  
		private var _count:int;  
		/** 
		 *  @private 
		 *  timer used to alternate between sysDockIcon and alteredSysDockIcon 
		 */  
		private static var ALERT_TIMER:Timer;  
		/** 
		 *  Constructor. 
		 */  
		public function IconManagertest(sysDockIconBitmaps:Array,  
										alteredSysDockIconBitmaps:Array=null,  
										alertType:String="critical"):void {  
			this.sysDockIconBitmaps = sysDockIconBitmaps;  
			this.alteredSysDockIconBitmaps = alteredSysDockIconBitmaps;  
			this.alertType = alertType;  
			handleIcons();  
		}  
		/** 
		 *  @private 
		 *  called by constructor to initialize the icons sets 
		 */  
		private function handleIcons():void{  
			stopAlert();  
			if(NativeApplication.supportsDockIcon || NativeApplication.supportsSystemTrayIcon){  
				if(sysDockIconBitmaps.length > 0){  
					NativeApplication.nativeApplication.icon.bitmaps = sysDockIconBitmaps;  
					if(alteredSysDockIconBitmaps == null){  
						alteredSysDockIconBitmaps = new Array();  
						for (var i:int=0; i<sysDockIconBitmaps.length;i++){  
							alteredSysDockIconBitmaps.push(applyAlertFilter(sysDockIconBitmaps.clone(),i));  
						}  
					}  
				}  
			}  
		}  
		/** 
		 *  @private 
		 *  alters icon to reverse of original using a filter 
		 */  
		private function applyAlertFilter(bitmapData:BitmapData,i:int):BitmapData {  
			var matrix:Array = new Array();  
			matrix = matrix.concat([-1, 0, 0, 0, 255]);  
			matrix = matrix.concat([0, -1, 0, 0, 255]);  
			matrix = matrix.concat([0, 0, -1, 0, 255]);  
			matrix = matrix.concat([0, 0, 0, 1, 0]);  
			var r:Rectangle;  
			if(i == 0)r= new Rectangle(0,0,16,16);  
			if(i == 1)r= new Rectangle(0,0,32,32);  
			if(i == 2)r= new Rectangle(0,0,48,48);  
			if(i == 3)r= new Rectangle(0,0,128,128);  
			bitmapData.applyFilter(bitmapData,r,new Point(),new ColorMatrixFilter(matrix));  
			return new Bitmap(bitmapData).bitmapData;  
		}  
		/** 
		 *  @public 
		 *  starts an alert and shows toolTip message (Windows Only) 
		 */  
		public function startAlert(message:String="Alert"):void{  
			IconManager.ALERT_TIMER = new Timer(500,0);  
			IconManager.ALERT_TIMER.addEventListener(TimerEvent.TIMER,changeIcon)  
			IconManager.ALERT_TIMER.start();  
			if(NativeApplication.supportsSystemTrayIcon){  
				SystemTrayIcon(NativeApplication.nativeApplication.icon).tooltip = message;  
			}  
		}  
		/** 
		 *  @public 
		 *  stops an alert 
		 */  
		public function stopAlert():void{  
			if(NativeApplication.supportsSystemTrayIcon){  
				SystemTrayIcon(NativeApplication.nativeApplication.icon).tooltip = "";  
			}  
			try{  
				IconManager.ALERT_TIMER.stop();  
			} catch (e:Error){  
			}  
		}  
		/** 
		 *  @private 
		 *  timer handler, alters state of icon 
		 */  
		private function changeIcon(event:TimerEvent):void{  
			if(_count == 0){  
				if(sysDockIconBitmaps.length){  
					NativeApplication.nativeApplication.icon.bitmaps = sysDockIconBitmaps;  
				}  
				_count = 1;  
			} else {  
				if(alteredSysDockIconBitmaps.length){  
					NativeApplication.nativeApplication.icon.bitmaps = alteredSysDockIconBitmaps;  
				}  
				_count = 0;  
			}  
		}  
	}
}