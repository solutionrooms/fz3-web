package LicPackage
{
   import flash.display.Loader;
   import flash.display.MovieClip;
   
   public class AdItem
   {
      
      public var name:String;
      
      public var type:String;
      
      public var url:String;
      
      public var original_url:String;
      
      public var swfurl:String;
      
      public var active:Boolean;
      
      public var customAd:MovieClip;
      
      public var urlLoaded:Boolean;
      
      public var loader:Loader;
      
      public function AdItem(param1:String, param2:String, param3:String, param4:String)
      {
         super();
         this.name = param1;
         this.type = param2;
         this.url = param3;
         this.original_url = this.url;
         this.swfurl = param4;
         this.active = true;
         this.customAd = null;
         this.urlLoaded = false;
         this.loader = null;
      }
      
      internal function CompareSwfUrlWith(param1:AdItem) : Boolean
      {
         if(this.swfurl != param1.swfurl)
         {
            return false;
         }
         return true;
      }
   }
}

