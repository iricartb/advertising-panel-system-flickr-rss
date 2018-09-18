package {
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	public class Transition extends Sprite {
		public static const TRANSITION_SIMPLE: String = "TRANSITION_SIMPLE";
		public static const TRANSITION_FADE: String = "TRANSITION_FADE";
		public static const TRANSITION_CIRCLE: String = "TRANSITION_CIRCLE";
		
		protected var _width: Number;
		protected var _height: Number;
		protected var oContainer: Sprite;
		protected var nEffectFadeInDelay: uint;
		protected var nEffectFadeOutDelay: uint;
		
		public function Transition(nWidth: Number, nHeight: Number, nEffectFadeInDelay: uint, nEffectFadeOutDelay: uint) {
			this._width = nWidth;
			this._height = nHeight;
			
			if (nEffectFadeInDelay == 0) this.nEffectFadeInDelay = 1;
			else this.nEffectFadeInDelay = nEffectFadeInDelay;
			
			if (nEffectFadeOutDelay == 0) this.nEffectFadeOutDelay = 1;
			else this.nEffectFadeOutDelay = nEffectFadeOutDelay;
			
			oContainer = new Sprite();
	
			addChild(oContainer);
		}
		
		// --> Override this functions on subclass
		public function play(obitmap: Bitmap): void { }
		public function disappear(): void { }
		public function setRadio(nRadio: Number): void { }
		
		public function getContainerComponent(): Sprite { return oContainer; }
	}
}