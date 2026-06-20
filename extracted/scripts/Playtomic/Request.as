package Playtomic
{
   import flash.events.Event;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.net.URLVariables;
   import flash.utils.ByteArray;
   import flash.utils.Timer;
   
   public final class Request extends URLLoader
   {
      
      private static var Pool:Vector.<Request>;
      
      private static var Queue:Vector.<Request>;
      
      private static var URLStub:String;
      
      private static var URLTail:String;
      
      private static var URL:String;
      
      private var urlRequest:URLRequest = new URLRequest();
      
      private var complete:Function;
      
      private var callback:Function;
      
      private var handled:Boolean;
      
      private var logging:Boolean;
      
      private var postdata:Object;
      
      private var time:int;
      
      public function Request()
      {
         super();
         addEventListener("ioError",Fail);
         addEventListener("networkError",Fail);
         addEventListener("verifyError",Fail);
         addEventListener("diskError",Fail);
         addEventListener("securityError",Fail);
         addEventListener("httpStatus",HTTPStatusIgnore);
         addEventListener("complete",Complete);
      }
      
      internal static function Initialise() : void
      {
         Pool = new Vector.<Request>();
         Queue = new Vector.<Request>();
         URLStub = "http://g" + Log.GUID + ".api.playtomic.com";
         URLTail = "swfid=" + Log.SWFID;
         URL = URLStub + "/v3/api.aspx?" + URLTail;
         var _loc1_:Timer = new Timer(500);
         _loc1_.addEventListener("timer",TimeoutHandler);
         _loc1_.start();
         var _loc2_:int = 0;
         while(_loc2_ < 20)
         {
            Pool.push(new Request());
            _loc2_++;
         }
      }
      
      internal static function SendStatistics(param1:Function, param2:String) : void
      {
         var _loc3_:Request = Pool.length > 0 ? Pool.pop() : new Request();
         _loc3_.time = 0;
         _loc3_.handled = false;
         _loc3_.complete = param1;
         _loc3_.callback = null;
         _loc3_.logging = true;
         _loc3_.urlRequest.url = URLStub + param2 + (param2.indexOf("?") > -1 ? "&" : "?") + URLTail + "&" + Math.random() + "Z";
         _loc3_.urlRequest.method = "GET";
         _loc3_.urlRequest.data = null;
         _loc3_.postdata = null;
         _loc3_.load(_loc3_.urlRequest);
         Queue.push(_loc3_);
      }
      
      internal static function Load(param1:String, param2:String, param3:Function, param4:Function, param5:Object = null) : void
      {
         var url:String;
         var timestamp:String;
         var nonce:String;
         var pd:Array;
         var request:Request = null;
         var key:String = null;
         var pda:ByteArray = null;
         var postvars:URLVariables = null;
         var section:String = param1;
         var action:String = param2;
         var complete:Function = param3;
         var callback:Function = param4;
         var postdata:Object = param5;
         request = Pool.length > 0 ? Pool.pop() : new Request();
         request.time = 0;
         request.handled = false;
         request.complete = complete;
         request.callback = callback;
         request.logging = false;
         url = URL + "&r=" + Math.random() + "Z";
         timestamp = String(new Date().time).substring(0,10);
         nonce = Encode.MD5(new Date().time * Math.random() + Log.GUID);
         pd = new Array();
         pd.push("nonce=" + nonce);
         pd.push("timestamp=" + timestamp);
         for(key in postdata)
         {
            pd.push(key + "=" + Escape(postdata[key]));
         }
         GenerateKey("section",section,pd);
         GenerateKey("action",action,pd);
         GenerateKey("signature",nonce + timestamp + section + action + url + Log.GUID,pd);
         pda = new ByteArray();
         pda.writeUTFBytes(pd.join("&"));
         pda.position = 0;
         postvars = new URLVariables();
         postvars["data"] = Escape(Encode.Base64(pda));
         request.urlRequest.url = url;
         request.urlRequest.method = "POST";
         request.urlRequest.data = postvars;
         request.postdata = postdata;
         try
         {
            request.load(request.urlRequest);
         }
         catch(s:Error)
         {
            request.complete(request.callback,request.postdata,null,new Response(0,1));
         }
         Queue.push(request);
      }
      
      private static function Escape(param1:String) : String
      {
         if(param1 == null)
         {
            return "";
         }
         param1 = param1.split("%").join("%25");
         param1 = param1.split(";").join("%3B");
         param1 = param1.split("?").join("%3F");
         param1 = param1.split("/").join("%2F");
         param1 = param1.split(":").join("%3A");
         param1 = param1.split("#").join("%23");
         param1 = param1.split("&").join("%26");
         param1 = param1.split("=").join("%3D");
         param1 = param1.split("+").join("%2B");
         param1 = param1.split("$").join("%24");
         param1 = param1.split(",").join("%2C");
         param1 = param1.split(" ").join("%20");
         param1 = param1.split("<").join("%3C");
         param1 = param1.split(">").join("%3E");
         return param1.split("~").join("%7E");
      }
      
      private static function GenerateKey(param1:String, param2:String, param3:Array) : void
      {
         param3.sort();
         param3.push(param1 + "=" + Encode.MD5(param3.join("&") + param2));
      }
      
      private static function TimeoutHandler(param1:Event) : void
      {
         var _loc2_:Request = null;
         var _loc3_:* = int(Queue.length - 1);
         for(; _loc3_ > -1; _loc3_--)
         {
            _loc2_ = Queue[_loc3_];
            if(!_loc2_.handled)
            {
               ++_loc2_.time;
               if(_loc2_.time < 20)
               {
                  continue;
               }
               if(_loc2_.logging)
               {
                  _loc2_.complete(false);
               }
               else
               {
                  _loc2_.complete(_loc2_.callback,_loc2_.postdata,null,new Response(0,3));
               }
            }
            Queue.splice(_loc3_,1);
            Dispose(_loc2_);
         }
      }
      
      private static function Complete(param1:Event) : void
      {
         var _loc2_:Request = param1.target as Request;
         if(_loc2_.handled)
         {
            return;
         }
         _loc2_.handled = true;
         if(_loc2_.logging)
         {
            _loc2_.complete(true);
            return;
         }
         var _loc3_:XML = XML(_loc2_.data);
         var _loc4_:int = parseInt(_loc3_["status"]);
         var _loc5_:int = parseInt(_loc3_["errorcode"]);
         _loc2_.complete(_loc2_.callback,_loc2_.postdata,_loc3_,new Response(_loc4_,_loc5_));
      }
      
      private static function Fail(param1:Event) : void
      {
         var _loc2_:Request = param1.target as Request;
         if(_loc2_.handled)
         {
            return;
         }
         _loc2_.handled = true;
         if(_loc2_.logging)
         {
            _loc2_.complete(false);
         }
         else
         {
            _loc2_.complete(_loc2_.callback,_loc2_.postdata,null,new Response(0,1));
         }
      }
      
      private static function HTTPStatusIgnore(param1:Event) : void
      {
      }
      
      private static function Dispose(param1:Request) : void
      {
         if(!param1.handled)
         {
            param1.handled = true;
            param1.close();
         }
         Pool.push(param1);
      }
   }
}

