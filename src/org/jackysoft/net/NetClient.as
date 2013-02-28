package org.jackysoft.net{
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;

	/**
	 * socket客户端，此类适用于  dataLen + data  的数据协议
	 * @author zkpursuit
	 */
	public class NetClient extends EventDispatcher{

		private var socket:Socket;
		private var byteBuffer:ByteArray;	//数据缓存
		private var dataLength:int;			//接收到的数据长度
		private var headLen:int;			//数据包首部长度
		
		public function NetClient(){
			byteBuffer = new ByteArray();
			//数据长度，一般由服务器定义的数据协议中规定的数据包长度的数据类型的字节大小，int占有4个字节
			headLen = 4;
		}
		
		/**
		 * 建立socket连接
		 * @param	host 服务器IP地址
		 * @param	port 服务器开放供客户连接的端口
		 */
		public function buildConnection(host:String = "127.0.0.1", port:int = 8088):void {
			socket = new Socket(host, port);
			socket.addEventListener(Event.CLOSE, closeHandler);
			socket.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			socket.addEventListener(Event.CONNECT, connectHandler);
			socket.addEventListener(ProgressEvent.SOCKET_DATA, receivedHandler);
		}
		
		private function closeHandler(e:Event):void {
			socket.removeEventListener(Event.CLOSE, closeHandler);
			socket.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			socket.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			socket.removeEventListener(Event.CONNECT, connectHandler);
			socket.removeEventListener(ProgressEvent.SOCKET_DATA, receivedHandler);
			dispatchEvent(e);
			trace("服务器已关闭此连接");
		}
		private function ioErrorHandler(e:IOErrorEvent):void {
			dispatchEvent(e);
		}
		private function securityErrorHandler(e:SecurityErrorEvent):void {
			dispatchEvent(e);
		}
		private function connectHandler(e:Event):void {
			dispatchEvent(e);
			trace("已建立连接");
		}
		private function receivedHandler(e:ProgressEvent):void {
			dispatchEvent(e);
			parse();
		}
		
		/**
		 * 为避免一次接收到多条数据包，必须进行数据包的分离解码
		 * 网络数据解码
		 */
		private function parse():void{
			//开始读取数据的标记
			var readFlag:Boolean = false;
			//每读取一条数据bytesAvailable值将随之减少
			//while (socket.bytesAvailable>=headLen) {
			while (socket.bytesAvailable) {
				if (!readFlag && socket.bytesAvailable >= headLen) {
					//读取数据长度
					dataLength = socket.readInt();
					readFlag = true;
				}
				//如果为0,表示收到异常消息，避免无限循环地等待
				if(dataLength==0){
					dispatchEvent(new NetEvent(NetEvent.NULL_STREAM));
					return;
				}
				//数据流里的数据满足条件，开始读数据
				if (readFlag && socket.bytesAvailable >= dataLength){
					//指针回归
					byteBuffer.position = 0;
					//取出指定长度的字节
					socket.readBytes(byteBuffer, 0, dataLength);

					//读取完一条消息后发送消息内容
					var event:NetEvent=new NetEvent(NetEvent.READED_DATA);
					event.bytesData=byteBuffer;
					dispatchEvent(event);
					
					dataLength = 0;
					readFlag = false;
				}
			}
		}
		/**
		 * 发送数据
		 * @param	bytes
		 */
		public function send(bytes:ByteArray):void{
			var bytes_len:int = bytes.length;
			//数据的长度
			socket.writeInt(bytes_len);
			//发送的数据内容
			socket.writeBytes(bytes);
			socket.flush();
		}
		/**
		 * 发送自定义数据包
		 * @param	packet
		 */
		public function sendPacket(packet:Packet):void {
			send(packet.array());
		}
	}
}
