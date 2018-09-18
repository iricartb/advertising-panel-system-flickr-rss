package {
   import Transition;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import caurina.transitions.Tweener;   

   public class SimpleTransition extends Transition {
      public function SimpleTransition(nWidth: Number, nHeight: Number, nEffectFadeInDelay: uint, nEffectFadeOutDelay: uint) {
         super(nWidth, nHeight, nEffectFadeInDelay, nEffectFadeOutDelay);
      }
      
      override public function play(oBitmap: Bitmap): void {
         Tweener.updateTime();
         
         oBitmap.width = this._width;
         oBitmap.height = this._height;
         
         oContainer.alpha = 1.0;
         oContainer.addChild(oBitmap);
         
         if (oContainer.numChildren > 1) oContainer.removeChildAt(0);
      }
   }
}