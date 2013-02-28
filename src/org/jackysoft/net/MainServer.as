package  org.jackysoft.net
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.ProgressEvent;
	
	/**
	 * ...
	 * @author zkpursuit
	 */
	[SWF(width=400,height=500)]
	public class MainServer extends Sprite
	{
		private var registPanel:RegistPanel;
		
		private var client:NetClient;
		private var tf:TextField=new TextField();
		public function MainServer() 
		{
			stage.scaleMode = "noScale";
			
			client = new NetClient();
			client.buildConnection();
			client.addEventListener(NetEvent.READED_DATA, onReadedDataHandler);
			client.addEventListener(Event.CONNECT, onConnectServerHandler);
			
			registPanel = new RegistPanel();
			addChild(registPanel);
			registPanel.addEventListener(NetEvent.NET_CONNECT, requestConnectServer);
			
			tf.border = true;
			tf.width = 300;
			tf.height = 400;
			tf.x=50;
			tf.y = 50;
			tf.type = TextFieldType.INPUT;
			addChild(tf);
		}
		private function requestConnectServer(e:NetEvent):void {
			var p:Packet = new Packet();
			p.writeShort(1000);
			p.writeInt(e.playerID);
			trace(e.playerID);
			client.sendPacket(p);
		}
		private function onConnectServerHandler(e:Event):void {
			tf.appendText("已建立连接\n");
		}
		private function onReadedDataHandler(e:NetEvent):void {
			var p:Packet=new Packet(e.bytesData);
			var info:String = "---" + p.readInt() + "---" + p.readInt()+"---"+p.readString()+"\n";
			tf.appendText(info);
		}
	}
}