package {
	import flash.display.Sprite;

	public class GadgetRssTitle extends Sprite {
		private var oRssTitle: DisplayRssTitle;
		
		public function GadgetRssTitle(x: uint, y: uint) {
			oRssTitle = new DisplayRssTitle();

			oRssTitle.x = x;
			oRssTitle.y = y;
		}
		
		public function getComponent(): DisplayRssTitle { return oRssTitle; }
	}
}