package Playtomic
{
   import flash.events.TimerEvent;
   import flash.external.ExternalInterface;
   import flash.net.SharedObject;
   import flash.system.Security;
   import flash.utils.Timer;
   
   public final class Log
   {
      
      internal static var SourceUrl:String;
      
      internal static var BaseUrl:String;
      
      private static var Cookie:SharedObject;
      
      internal static var LogQueue:LogRequest;
      
      private static var Enabled:Boolean = false;
      
      private static var Queue:Boolean = true;
      
      internal static var SWFID:int = 0;
      
      internal static var GUID:String = "";
      
      private static const PingF:Timer = new Timer(60000);
      
      private static const PingR:Timer = new Timer(30000);
      
      private static var FirstPing:Boolean = true;
      
      private static var Pings:int = 0;
      
      private static var Plays:int = 0;
      
      private static var Frozen:Boolean = false;
      
      private static var FrozenQueue:Array = new Array();
      
      private static var Customs:Array = new Array();
      
      private static var LevelCounters:Array = new Array();
      
      private static var LevelAverages:Array = new Array();
      
      private static var LevelRangeds:Array = new Array();
      
      public function Log()
      {
         super();
      }
      
      public static function View(param1:int = 0, param2:String = "", param3:String = "", param4:String = "") : void
      {
         if(SWFID > 0)
         {
            return;
         }
         SWFID = param1;
         GUID = param2;
         Enabled = true;
         if(SWFID == 0 || GUID == "")
         {
            Enabled = false;
            return;
         }
         if(param4.indexOf("http://") != 0 && Security.sandboxType != "localWithNetwork" && Security.sandboxType != "localTrusted")
         {
            Enabled = false;
            return;
         }
         SourceUrl = GetUrl(param4);
         if(SourceUrl == null || SourceUrl == "")
         {
            Enabled = false;
            return;
         }
         BaseUrl = SourceUrl.split("://")[1];
         BaseUrl = BaseUrl.substring(0,BaseUrl.indexOf("/"));
         Parse.Initialise(param3);
         GeoIP.Initialise(param3);
         Data.Initialise(param3);
         Leaderboards.Initialise(param3);
         Playtomic.GameVars.Initialise(param3);
         PlayerLevels.Initialise(param3);
         Request.Initialise();
         LogQueue = LogRequest.Create();
         Cookie = SharedObject.getLocal("playtomic");
         Security.loadPolicyFile("http://g" + param2 + ".api.playtomic.com/crossdomain.xml");
         var _loc5_:int = GetCookie("views");
         Send("v/" + (_loc5_ + 1),true);
         PingF.addEventListener(TimerEvent.TIMER,PingServer);
         PingF.start();
      }
      
      internal static function IncreaseViews() : void
      {
         var _loc1_:int = GetCookie("views");
         _loc1_++;
         SaveCookie("views",_loc1_);
      }
      
      internal static function IncreasePlays() : void
      {
         ++Plays;
      }
      
      public static function Play() : void
      {
         if(!Enabled)
         {
            return;
         }
         LevelCounters = new Array();
         LevelAverages = new Array();
         LevelRangeds = new Array();
         Send("p/" + (Plays + 1),true);
      }
      
      private static function PingServer(param1:TimerEvent) : void
      {
         if(!Enabled)
         {
            return;
         }
         ++Pings;
         Send("t/" + (FirstPing ? "y" : "n") + "/" + Pings,true);
         if(FirstPing)
         {
            PingF.stop();
            PingR.addEventListener(TimerEvent.TIMER,PingServer);
            PingR.start();
            FirstPing = false;
         }
      }
      
      public static function CustomMetric(param1:String, param2:String = null, param3:Boolean = false) : void
      {
         if(!Enabled)
         {
            return;
         }
         if(param2 == null)
         {
            param2 = "";
         }
         if(param3)
         {
            if(Customs.indexOf(param1) > -1)
            {
               return;
            }
            Customs.push(param1);
         }
         Send("c/" + Clean(param1) + "/" + Clean(param2));
      }
      
      public static function LevelCounterMetric(param1:String, param2:*, param3:Boolean = false) : void
      {
         var _loc4_:String = null;
         if(!Enabled)
         {
            return;
         }
         if(param3)
         {
            _loc4_ = param1 + "." + (param2 as String);
            if(LevelCounters.indexOf(_loc4_) > -1)
            {
               return;
            }
            LevelCounters.push(_loc4_);
         }
         Send("lc/" + Clean(param1) + "/" + Clean(param2));
      }
      
      public static function LevelRangedMetric(param1:String, param2:*, param3:int, param4:Boolean = false) : void
      {
         var _loc5_:String = null;
         if(!Enabled)
         {
            return;
         }
         if(param4)
         {
            _loc5_ = param1 + "." + (param2 as String);
            if(LevelRangeds.indexOf(_loc5_) > -1)
            {
               return;
            }
            LevelRangeds.push(_loc5_);
         }
         Send("lr/" + Clean(param1) + "/" + Clean(param2) + "/" + param3);
      }
      
      public static function LevelAverageMetric(param1:String, param2:*, param3:int, param4:Boolean = false) : void
      {
         var _loc5_:String = null;
         if(!Enabled)
         {
            return;
         }
         if(param4)
         {
            _loc5_ = param1 + "." + (param2 as String);
            if(LevelAverages.indexOf(_loc5_) > -1)
            {
               return;
            }
            LevelAverages.push(_loc5_);
         }
         Send("la/" + Clean(param1) + "/" + Clean(param2) + "/" + param3);
      }
      
      internal static function Link(param1:String, param2:String, param3:String, param4:int, param5:int, param6:int) : void
      {
         if(!Enabled)
         {
            return;
         }
         Send("l/" + Clean(param2) + "/" + Clean(param3) + "/" + Clean(param1) + "/" + param4 + "/" + param5 + "/" + param6);
      }
      
      public static function Heatmap(param1:String, param2:String, param3:int, param4:int) : void
      {
         if(!Enabled)
         {
            return;
         }
         Send("h/" + Clean(param1) + "/" + Clean(param2) + "/" + param3 + "/" + param4);
      }
      
      internal static function Funnel(param1:String, param2:String, param3:int) : void
      {
         if(!Enabled)
         {
            return;
         }
         Send("f/" + Clean(param1) + "/" + Clean(param2) + "/" + param3);
      }
      
      internal static function PlayerLevelStart(param1:String) : void
      {
         if(!Enabled)
         {
            return;
         }
         Send("pls/" + param1);
      }
      
      internal static function PlayerLevelWin(param1:String) : void
      {
         if(!Enabled)
         {
            return;
         }
         Send("plw/" + param1);
      }
      
      internal static function PlayerLevelQuit(param1:String) : void
      {
         if(!Enabled)
         {
            return;
         }
         Send("plq/" + param1);
      }
      
      internal static function PlayerLevelFlag(param1:String) : void
      {
         if(!Enabled)
         {
            return;
         }
         Send("plf/" + param1);
      }
      
      internal static function PlayerLevelRetry(param1:String) : void
      {
         if(!Enabled)
         {
            return;
         }
         Send("plr/" + param1);
      }
      
      public static function Freeze() : void
      {
         Frozen = true;
      }
      
      public static function UnFreeze() : void
      {
         Frozen = false;
         LogQueue.MassQueue(FrozenQueue);
      }
      
      public static function ForceSend() : void
      {
         if(!Enabled)
         {
            return;
         }
         if(LogQueue == null)
         {
            LogQueue = LogRequest.Create();
         }
         LogQueue.Send();
         LogQueue = LogRequest.Create();
         if(FrozenQueue.length > 0)
         {
            LogQueue.MassQueue(FrozenQueue);
         }
      }
      
      private static function Send(param1:String, param2:Boolean = false) : void
      {
         if(Frozen)
         {
            FrozenQueue.push(param1);
            return;
         }
         LogQueue.Queue(param1);
         if(LogQueue.ready || param2 || !Queue)
         {
            LogQueue.Send();
            LogQueue = LogRequest.Create();
         }
      }
      
      private static function Clean(param1:String) : String
      {
         while(param1.indexOf("/") > -1)
         {
            param1 = param1.replace("/","\\");
         }
         while(param1.indexOf("~") > -1)
         {
            param1 = param1.replace("~","-");
         }
         return escape(param1);
      }
      
      private static function GetCookie(param1:String) : int
      {
         if(Cookie.data[param1] == undefined)
         {
            return 0;
         }
         return int(Cookie.data[param1]);
      }
      
      private static function SaveCookie(param1:String, param2:int) : void
      {
         Cookie.data[param1] = param2.toString();
         try
         {
            Cookie.flush();
         }
         catch(s:Error)
         {
         }
      }
      
      private static function GetUrl(param1:String) : String
      {
         var url:String = null;
         var defaulturl:String = param1;
         if(ExternalInterface.available)
         {
            try
            {
               url = String(ExternalInterface.call("window.location.href.toString"));
            }
            catch(s:Error)
            {
               url = defaulturl;
            }
         }
         else if(defaulturl.indexOf("http://") == 0 || defaulturl.indexOf("https://") == 0)
         {
            url = defaulturl;
         }
         if(url == null || url == "" || url == "null")
         {
            if(Security.sandboxType == "localWithNetwork" || Security.sandboxType == "localTrusted")
            {
               url = "http://localhost/";
            }
            else
            {
               url = null;
            }
         }
         if(url.indexOf("http://") != 0)
         {
            url = "http://localhost/";
         }
         return url;
      }
   }
}

