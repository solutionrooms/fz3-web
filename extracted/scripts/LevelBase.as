package
{
   public class LevelBase
   {
      
      public var id:String;
      
      public var name:String;
      
      public var description:String;
      
      public var category:int;
      
      public var bgFrame:int;
      
      public var music:int;
      
      public var instances:Array;
      
      public var joints:Array;
      
      public var helpscreenFrames:Array;
      
      public var lines:Array;
      
      public var fillFrame:int;
      
      public var surfaceFrame:uint;
      
      public var surfaceThickness:int;
      
      public var played:Boolean;
      
      public var available:Boolean;
      
      public var complete:Boolean;
      
      public var numRockets:int;
      
      public var exclusiveChar:int;
      
      public var eventType:String;
      
      public var eventOpponentsString:String;
      
      public var eventWinParam:Number;
      
      public var bestScore:int;
      
      public var levelScore:int;
      
      public var percentage:Number;
      
      public var bestPercentage:Number;
      
      public var rating:int;
      
      public var lastTime:int;
      
      public var lastTimeTotal:int;
      
      public var bestTime:int;
      
      public var bestTimeTotal:int;
      
      public var goldTime:int;
      
      public var silverTime:int;
      
      public var aiCarMaxSpeed:Number;
      
      public var aiCarMinSpeed:Number;
      
      public var raceType:String;
      
      public var aiCarTypeString:String;
      
      public var levelFunctionName:String;
      
      public var map:Array;
      
      public var mapCellW:int;
      
      public var mapCellH:int;
      
      public var mapMinX:int;
      
      public var mapMinY:int;
      
      public var mapMaxX:int;
      
      public var mapMaxY:int;
      
      public var fullyLoaded:Boolean;
      
      public var creator:String;
      
      public var hasHitRef:Boolean;
      
      public function LevelBase()
      {
         var _loc1_:int = 0;
         super();
         this.name = "";
         this.description = "";
         this.instances = new Array();
         this.joints = new Array();
         this.helpscreenFrames = new Array();
         this.lines = new Array();
         this.music = 0;
         this.category = 0;
         this.fillFrame = 1;
         this.surfaceFrame = 5;
         this.surfaceThickness = 10;
         this.available = false;
         this.complete = false;
         this.eventType = "none";
         this.eventOpponentsString = "";
         this.eventWinParam = 1;
         this.exclusiveChar = 1;
         this.lastTime = 9999999;
         this.lastTimeTotal = 9999999;
         this.bestTime = 9999999;
         this.bestTimeTotal = 9999999;
         this.goldTime = 10 * Defs.fps;
         this.silverTime = 20 * Defs.fps;
         this.played = false;
         this.numRockets = 0;
         this.bestScore = 0;
         this.percentage = 0;
         this.bestPercentage = 0;
         this.creator = "";
         this.hasHitRef = false;
         this.map = new Array();
         this.mapCellW = 16;
         this.mapCellH = 16;
         this.mapMinX = 0;
         this.mapMaxX = 0;
         this.mapMinY = 0;
         this.mapMaxY = 0;
         this.levelFunctionName = "";
         this.rating = 0;
         this.fullyLoaded = false;
      }
      
      public function Calculate() : *
      {
      }
      
      public function GetLineByName(param1:String) : PhysLine
      {
         var _loc2_:PhysLine = null;
         for each(_loc2_ in this.lines)
         {
            if(_loc2_.id == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function GetLineByIndex(param1:int) : PhysLine
      {
         if(param1 < 0)
         {
            return null;
         }
         if(param1 >= this.lines.length)
         {
            return null;
         }
         return this.lines[param1];
      }
   }
}

