package {
   import Transition;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import caurina.transitions.Tweener;   

   public class FadeTransition extends Transition {
      public function FadeTransition(nWidth: Number, nHeight: Number, nEffectFadeInDelay: uint, nEffectFadeOutDelay: uint) {
         super(nWidth, nHeight, nEffectFadeInDelay, nEffectFadeOutDelay);
      }
      
      override public function play(oBitmap: Bitmap): void {
         Tweener.updateTime();
         
         while (oContainer.numChildren > 1) oContainer.removeChildAt(0);
         
         oBitmap.width = this._width;
         oBitmap.height = this._height;
         
         oContainer.addChild(oBitmap);
         oContainer.getChildAt(oContainer.numChildren - 1).alpha = 0.0;
         Tweener.addTween(oContainer.getChildAt(oContainer.numChildren - 1), {alpha: 100, time: this.nEffectFadeInDelay, transition: "easeInQuad"});
      }
      
      override public function disappear(): void {
         if (oContainer.numChildren > 0) {
            if (oContainer.numChildren > 1) oContainer.removeChildAt(0);
            Tweener.addTween(oContainer.getChildAt(oContainer.numChildren - 1), {alpha: 0, time: this.nEffectFadeOutDelay, transition: "easeOutQuad"});
         }
      }
   }
}