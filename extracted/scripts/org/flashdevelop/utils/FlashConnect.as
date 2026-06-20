package org.flashdevelop.utils
{
   import flash.events.*;
   import flash.net.*;
   import flash.utils.*;
   import flash.xml.*;
   
   public class FlashConnect
   {
      
      private static var socket:XMLSocket;
      
      private static var messages:Array;
      
      private static var interval:Number;
      
      private static var counter:Number;
      
      public static var onConnection:Function;
      
      public static var onReturnData:Function;
      
      public static var status:Number = 0;
      
      public static var limit:Number = 1000;
      
      public static var host:String = "127.0.0.1";
      
      public static var port:Number = 1978;
      
      public function FlashConnect()
      {
         super();
      }
      
      public static function send(param1:XMLNode) : void
      {
         if(messages == null)
         {
            initialize();
         }
         messages.push(param1);
      }
      
      public static function trace(param1:Object, param2:Number = 1) : void
      {
         var _loc3_:XMLNode = createMsgNode(param1.toString(),param2);
         FlashConnect.send(_loc3_);
      }
      
      public static function atrace(... rest) : void
      {
         var _loc2_:String = rest.join(",");
         var _loc3_:XMLNode = createMsgNode(_loc2_,TraceLevel.DEBUG);
         FlashConnect.send(_loc3_);
      }
      
      public static function mtrace(param1:Object, param2:String, param3:String, param4:Number) : void
      {
         var _loc5_:String = param3.split("/").join("\\");
         var _loc6_:String = _loc5_ + ":" + param4 + ":" + param1;
         FlashConnect.trace(_loc6_,TraceLevel.DEBUG);
      }
      
      public static function flush() : Boolean
      {
         if(status)
         {
            sendStack();
            return true;
         }
         return false;
      }
      
      public static function initialize() : int
      {
         if(socket)
         {
            return status;
         }
         counter = 0;
         messages = new Array();
         socket = new XMLSocket();
         socket.addEventListener(Event.CLOSE,onClose);
         socket.addEventListener(DataEvent.DATA,onData);
         socket.addEventListener(Event.CONNECT,onConnect);
         socket.addEventListener(IOErrorEvent.IO_ERROR,onIOError);
         socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR,onSecurityError);
         interval = setInterval(sendStack,50);
         socket.connect(host,port);
         return status;
      }
      
      private static function onData(param1:DataEvent) : void
      {
         FlashConnect.status = 1;
         if(FlashConnect.onReturnData != null)
         {
            FlashConnect.onReturnData(param1.data);
         }
      }
      
      private static function onClose(param1:Event) : void
      {
         socket = null;
         FlashConnect.status = -1;
         if(FlashConnect.onConnection != null)
         {
            FlashConnect.onConnection();
         }
      }
      
      private static function onConnect(param1:Event) : void
      {
         FlashConnect.status = 1;
         if(FlashConnect.onConnection != null)
         {
            FlashConnect.onConnection();
         }
      }
      
      private static function onIOError(param1:IOErrorEvent) : void
      {
         FlashConnect.status = -1;
         if(FlashConnect.onConnection != null)
         {
            FlashConnect.onConnection();
         }
      }
      
      private static function onSecurityError(param1:SecurityErrorEvent) : void
      {
         FlashConnect.status = -1;
         if(FlashConnect.onConnection != null)
         {
            FlashConnect.onConnection();
         }
      }
      
      private static function createMsgNode(param1:String, param2:Number) : XMLNode
      {
         if(isNaN(param2))
         {
            param2 = TraceLevel.DEBUG;
         }
         var _loc3_:XMLNode = new XMLNode(1,null);
         var _loc4_:XMLNode = new XMLNode(3,encodeURI(param1));
         _loc3_.attributes.state = param2.toString();
         _loc3_.attributes.cmd = "trace";
         _loc3_.nodeName = "message";
         _loc3_.appendChild(_loc4_);
         return _loc3_;
      }
      
      private static function sendStack() : void
      {
         var _loc1_:XMLDocument = null;
         var _loc2_:XMLNode = null;
         var _loc3_:String = null;
         var _loc4_:XMLNode = null;
         var _loc5_:XMLNode = null;
         if(messages.length > 0 && status == 1)
         {
            _loc1_ = new XMLDocument();
            _loc2_ = _loc1_.createElement("flashconnect");
            while(messages.length != 0)
            {
               ++counter;
               if(counter > limit)
               {
                  clearInterval(interval);
                  _loc3_ = new String("FlashConnect aborted. You have reached the limit of maximum messages.");
                  _loc4_ = createMsgNode(_loc3_,TraceLevel.ERROR);
                  _loc2_.appendChild(_loc4_);
                  messages = new Array();
                  break;
               }
               _loc5_ = XMLNode(messages.shift());
               _loc2_.appendChild(_loc5_);
            }
            _loc1_.appendChild(_loc2_);
            if(Boolean(socket) && socket.connected)
            {
               socket.send(_loc1_);
            }
            counter = 0;
         }
      }
   }
}

