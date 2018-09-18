package {
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class ComponentBar extends Sprite {
      private var oComponentBar: DisplayComponentsBar;
      
      public function ComponentBar(nSceneWidth: uint) {
         oComponentBar = new DisplayComponentsBar();
         
         oComponentBar.x = 0.5 * nSceneWidth;
         oComponentBar.y = oComponentBar.height/2;
      }
      
      public function getComponentBar(): DisplayComponentsBar { return oComponentBar; }
   }
}