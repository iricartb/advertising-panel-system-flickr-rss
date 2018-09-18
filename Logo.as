package {
   public class Logo {
      private var oLogo: DisplayLogo;
      
      public function Logo(x: uint, y: uint) {
         oLogo = new DisplayLogo();
         
         oLogo.x = x;
         oLogo.y = y;
      }
      
      public function getComponent(): DisplayLogo { return oLogo; }
   }
}