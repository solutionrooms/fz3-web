package UIPackage
{
   import LicPackage.Lic;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.filters.ColorMatrixFilter;
   import flash.ui.Mouse;
   import org.flashdevelop.utils.FlashConnect;
   
   public class UI_LevelSelect extends UIScreenInstance
   {
      
      internal static var usePrePlacedLevels:Boolean = true;
      
      public static var greyFilter:ColorMatrixFilter = new ColorMatrixFilter([0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0,0,0,1,0]);
      
      internal var selectedLevel:int;
      
      public function UI_LevelSelect()
      {
         super();
      }
      
      override public function ExitScreen() : *
      {
         this.RemoveListeners();
         UI.RemoveAllButtons();
         UI.RemoveGeneric();
      }
      
      override public function InitScreen() : *
      {
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         var _loc4_:Level = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:Number = NaN;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:Array = null;
         var _loc16_:Array = null;
         var _loc17_:int = 0;
         var _loc18_:int = 0;
         var _loc1_:int = Levels.GetHighestAvailableLevelIndex();
         UI.StartAddButtons();
         MusicPlayer.StartStream("menus_music");
         Mouse.show();
         this.selectedLevel = -1;
         titleMC = new levelSelect();
         titleMC.gotoAndStop(1);
         Lic.AnimatedMCMoreGamesButton(titleMC.moreGamesBtn,"levelselect");
         UI.AddAnimatedMCButton(titleMC.menuBtn,this.buttonMenuPressed);
         UI.AddGeneric(titleMC);
         titleMC.cacheAsBitmap = true;
         if(usePrePlacedLevels)
         {
            _loc2_ = 1;
            while(_loc2_ <= 40)
            {
               _loc3_ = titleMC.getChildByName("level_" + _loc2_) as MovieClip;
               if(_loc3_ == null)
               {
                  FlashConnect.trace("cant find level " + _loc2_);
               }
               else
               {
                  _loc3_.textExtra.text = "";
                  _loc3_.levelID = _loc2_ - 1;
                  _loc3_.gotoAndStop(1);
                  _loc4_ = Levels.GetLevel(_loc2_ - 1);
                  _loc3_.tick.gotoAndStop(1);
                  _loc3_.tick.visible = false;
                  if(_loc4_.rating != 0)
                  {
                     _loc3_.tick.visible = true;
                  }
                  if(_loc4_.available)
                  {
                     if(_loc4_.complete)
                     {
                     }
                     _loc3_.filters = [];
                     _loc3_.mouseEnabled = true;
                  }
                  else
                  {
                     _loc3_.filters = [greyFilter];
                     _loc3_.mouseEnabled = false;
                  }
                  if(Game.DoesLevelContainHostage(_loc4_))
                  {
                  }
                  _loc3_.textLevelNumber.text = _loc2_.toString();
                  UI.AddMCButton(_loc3_,this.buttonNextPressed);
                  _loc3_.addEventListener(MouseEvent.MOUSE_OVER,this.levelOver,false,0,true);
                  _loc3_.cacheAsBitmap = true;
               }
               _loc2_++;
            }
         }
         else
         {
            _loc2_ = 1;
            while(_loc2_ <= 40)
            {
               _loc3_ = titleMC.getChildByName("level_" + _loc2_) as MovieClip;
               _loc3_.gotoAndStop(1);
               _loc3_.tick.gotoAndStop(1);
               _loc2_++;
            }
            _loc9_ = 15;
            _loc7_ = 67;
            _loc8_ = 85;
            _loc10_ = 0;
            _loc11_ = 0;
            _loc12_ = 0.7;
            _loc7_ *= _loc12_;
            _loc8_ *= _loc12_;
            _loc13_ = 42;
            _loc14_ = 68;
            _loc15_ = new Array(0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,4,4,4,4,4,4,4,4,4,4,4,4,5,5,5,5,5,5,5,5,5,5,5,5);
            _loc16_ = new Array(0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,0,1,2,3,4,5,6,7,8,9);
            _loc2_ = 0;
            while(_loc2_ < Levels.list.length)
            {
               _loc4_ = Levels.GetLevel(_loc2_);
               _loc17_ = _loc2_;
               _loc5_ = _loc13_ + _loc16_[_loc2_] * _loc7_;
               _loc6_ = _loc14_ + _loc15_[_loc2_] * _loc8_;
               if(_loc15_[_loc2_] % 2 == 1)
               {
                  _loc5_ += 33;
               }
               _loc3_ = new levelClip();
               _loc3_.cacheAsBitmap = true;
               _loc3_.levelID = _loc2_;
               _loc3_.name = "level" + _loc2_;
               if(_loc4_.complete == false)
               {
                  _loc3_.tick.visible = false;
                  _loc3_.textLevelCreator.visible = false;
               }
               else
               {
                  _loc3_.tick.visible = true;
                  _loc3_.tick.gotoAndStop(_loc4_.rating + 1);
                  _loc3_.textLevelCreator.visible = true;
                  _loc3_.textLevelCreator.text = _loc4_.bestScore;
               }
               _loc3_.textLevelCreator.visible = true;
               _loc3_.textLevelCreator.text = _loc4_.creator;
               if(_loc4_.available)
               {
                  if(_loc4_.complete)
                  {
                  }
                  _loc3_.filters = [];
                  _loc3_.mouseEnabled = true;
               }
               else
               {
                  _loc3_.filters = [greyFilter];
                  _loc3_.mouseEnabled = false;
               }
               if(_loc4_.hasHitRef)
               {
                  _loc3_.redcard.visible = true;
               }
               else
               {
                  _loc3_.redcard.visible = false;
               }
               _loc18_ = _loc2_;
               _loc3_.textLevelNumber.text = (_loc18_ + 1).toString();
               _loc3_.x = _loc5_;
               _loc3_.y = _loc6_;
               _loc3_.scaleX = _loc12_;
               _loc3_.scaleY = _loc12_;
               _loc3_.addEventListener(MouseEvent.CLICK,this.buttonNextPressed,false,0,true);
               _loc3_.addEventListener(MouseEvent.MOUSE_OVER,this.levelOver,false,0,true);
               _loc3_.addEventListener(MouseEvent.MOUSE_OUT,this.levelOut,false,0,true);
               _loc3_.useHandCursor = true;
               _loc3_.buttonMode = true;
               _loc3_.cacheAsBitmap = true;
               titleMC.addChild(_loc3_);
               _loc2_++;
            }
         }
         this.UpdateChange();
      }
      
      internal function UpdateChange() : *
      {
         var _loc1_:Level = null;
         if(this.selectedLevel != -1)
         {
            _loc1_ = Levels.GetLevel(this.selectedLevel);
            titleMC.levelNameText.text = _loc1_.name;
            titleMC.levelBestScore.text = "" + _loc1_.bestScore;
            titleMC.levelGoldPar.text = "" + _loc1_.gold_score;
            titleMC.levelStar.visible = false;
            if(_loc1_.rating != 0)
            {
               titleMC.levelStar.visible = true;
            }
         }
      }
      
      internal function levelOut(param1:MouseEvent) : *
      {
         this.selectedLevel = -1;
         this.UpdateChange();
      }
      
      internal function levelOver(param1:MouseEvent) : *
      {
         if(param1.currentTarget == null)
         {
            return;
         }
         var _loc2_:int = int(param1.currentTarget.levelID);
         this.selectedLevel = _loc2_;
         Levels.currentIndex = this.selectedLevel;
         this.UpdateChange();
      }
      
      internal function buttonMenuPressed(param1:MouseEvent) : *
      {
         UI.StartTransition("title");
      }
      
      internal function RemoveListeners() : *
      {
         var _loc1_:int = 0;
         var _loc2_:MovieClip = null;
         if(usePrePlacedLevels)
         {
            return;
         }
         _loc1_ = 0;
         while(_loc1_ < Levels.list.length)
         {
            _loc2_ = titleMC.getChildByName("level" + _loc1_) as MovieClip;
            _loc2_.removeEventListener(MouseEvent.CLICK,this.buttonNextPressed);
            _loc2_.removeEventListener(MouseEvent.MOUSE_OVER,this.levelOver);
            _loc2_.removeEventListener(MouseEvent.MOUSE_OUT,this.levelOut);
            _loc1_++;
         }
      }
      
      internal function buttonNextPressed(param1:MouseEvent) : *
      {
         var _loc2_:Boolean = false;
         var _loc3_:int = int(param1.currentTarget.levelID);
         var _loc4_:Level = Levels.GetLevel(_loc3_);
         if(_loc4_.available)
         {
            _loc2_ = true;
         }
         if(Game.usedebug)
         {
            _loc2_ = true;
         }
         if(_loc2_ == false)
         {
            return;
         }
         SaveData.Save();
         Utils.trace(" levelselect start pressed");
         Game.main.screenBD.fillRect(Defs.screenRect,0);
         UI.StartTransition("gamescreen");
      }
   }
}

