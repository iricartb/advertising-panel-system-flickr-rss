package {
   import Transition;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import caurina.transitions.Tweener;

   public class CircularTransition extends Transition {
      private var oMask: Sprite;
      private var nRadio: Number;
      
      public function CircularTransition(nWidth: Number, nHeight: Number, nEffectFadeInDelay: uint, nEffectFadeOutDelay: uint) {
         super(nWidth, nHeight, nEffectFadeInDelay, nEffectFadeOutDelay);
         this.oMask = new Sprite();
         this.nRadio = 10;
         
         addChild(oMask);
         oContainer.mask = oMask;
      }
      
      override public function play(oBitmap: Bitmap): void {
         Tweener.updateTime();
         
         oBitmap.width = this._width;
         oBitmap.height = this._height;
   
         Tweener.addTween(oContainer, {alpha: 0, time: this.nEffectFadeOutDelay, transition: "easeOutQuad", onComplete: initMask, onCompleteParams: [oBitmap, nRadio]});
      }
      
      override public function setRadio(nRadio: Number): void { this.nRadio = nRadio; }
      
      private function initMask(oBitmap: Bitmap, nRadio: Number): void {
         var nTi: Number = 0.1;
         var nTj: Number = 0.15;
         
         while (oContainer.numChildren > 0) oContainer.removeChildAt(0);
         while (oMask.numChildren > 0) oMask.removeChildAt(0);
         
         oContainer.alpha = 1.0;
         oContainer.addChild(oBitmap);
         
         oMask.x = 0.5 * nRadio;
         oMask.y = 0.5 * nRadio;
         
         var k: Number = 0.5;
         var nX: uint = Math.ceil(oBitmap.width/nRadio) + 1;
         var nY: uint = Math.ceil(oBitmap.height/nRadio) + 1;
         var oCirculo: Circulo;
         
         for (var i: uint = 0; i < nX; i++) {
            for (var j: uint = 0; j < nY; j++) {
               oCirculo = new Circulo();
               oCirculo.x = nRadio * i;
               oCirculo.y = nRadio * j;
               oCirculo.r = 0;
               oMask.addChild(oCirculo);
               Tweener.addTween(oCirculo, {r: Math.ceil(nRadio/Math.sqrt(2)), delay:k*(nTi*i+nTj*j), time: nEffectFadeInDelay, transition: "easeOutQuad"});
            }
         }
      }
   }
}

import flash.display.Shape;

class Circulo extends Shape {
   private var _r: Number;
   
   public function set r(val: Number): void {
      _r = val;
      graphics.clear();
      graphics.beginFill(0xffffff, 1.0);
      graphics.drawCircle(0,0, _r);
   }
   
   public function get r(): Number { return _r; }
}