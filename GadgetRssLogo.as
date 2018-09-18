package {
   import flash.display.Sprite;
   
   public class GadgetRssLogo extends Sprite {
      private var oRssLogo: DisplayRssLogo;
      
      public function GadgetRssLogo(x: uint, y: uint) {
         oRssLogo = new DisplayRssLogo();

         oRssLogo.x = x;
         oRssLogo.y = y;
         
         oRssLogo.gotoAndStop(1);
      }
      
      public function changeLogo(sRssTitle: String): void {
         if (sRssTitle == Globals.RSS_URL_1_TITLE) oRssLogo.gotoAndStop(2);
         else if (sRssTitle == Globals.RSS_URL_2_TITLE) oRssLogo.gotoAndStop(3);
         else if (sRssTitle == Globals.RSS_URL_3_TITLE) oRssLogo.gotoAndStop(4);
         else oRssLogo.gotoAndStop(1);
      }
      
      public function getComponent(): DisplayRssLogo { return oRssLogo; }
   }
}