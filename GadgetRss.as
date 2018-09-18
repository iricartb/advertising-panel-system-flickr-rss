package {
	import flash.display.Sprite;
	
	public class GadgetRss extends Sprite {
		private var oRss: DisplayRss;
		
		public function GadgetRss(x: uint, y: uint) {
			oRss = new DisplayRss();
    	
			oRss.x = x;
			oRss.y = y;
		}
		
		public function getRssComponent(): DisplayRss { return oRss; }
	}
}