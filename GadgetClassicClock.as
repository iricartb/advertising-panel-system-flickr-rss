package {
   import flash.display.MovieClip;
   import flash.utils.Timer;
   import flash.events.TimerEvent;
   import flash.display.Sprite;
	
	public class GadgetClassicClock extends Sprite {
		private var oClassicClock: DisplayClassicClock;
		private var nAnimClockDotsDelay: Number;
		
		public function GadgetClassicClock(x: uint, y: uint, bAnimClockDots: Boolean = false, nAnimClockDotsDelay: Number = 1) {
			oClassicClock = new DisplayClassicClock();
    		
			oClassicClock.x = x;
			oClassicClock.y = y;

			if (nAnimClockDotsDelay <= 0) nAnimClockDotsDelay = 1;
			this.nAnimClockDotsDelay = nAnimClockDotsDelay;
			
			var oTimer: Timer = new Timer(1000);
			oTimer.addEventListener(TimerEvent.TIMER, updateClock);
    		oTimer.start();
			
			updateClock();
			if (bAnimClockDots) updateClockDots();
		}

		private function updateClock(event: TimerEvent = null): void {
			var sHours: String;
			var sMinutes: String;
			var sSeconds: String;

			var oDate: Date = new Date();
			var nDay: int = oDate.day;
			
			/* If number is just one digit, add a 0 to the left */
			if (String(oDate.hours).length < 2) sHours = "0" + oDate.hours;
			else sHours = String(oDate.hours);
			if (String(oDate.minutes).length < 2) sMinutes = "0" + oDate.minutes;
			else sMinutes = String(oDate.minutes);
			if (String(oDate.seconds).length < 2) sSeconds = "0" + oDate.seconds;
			else sSeconds = String(oDate.seconds);
		 
			/* Set TextFields */
			oClassicClock.itemClock.LabelHours1.text = sHours.charAt(0);
			oClassicClock.itemClock.LabelHours2.text = sHours.charAt(1);
			oClassicClock.itemClock.LabelMinutes1.text = sMinutes.charAt(0);
			oClassicClock.itemClock.LabelMinutes2.text = sMinutes.charAt(1);
			oClassicClock.itemClock.LabelSeconds1.text = sSeconds.charAt(0);
			oClassicClock.itemClock.LabelSeconds2.text = sSeconds.charAt(1);
		}
		
		private function updateClockDots(event: TimerEvent = null): void {
			var oTimer: Timer;
			
			if (oClassicClock.itemClock.LabelDot1.text == ":") {
				oClassicClock.itemClock.LabelDot1.text = "";
				oClassicClock.itemClock.LabelDot2.text = "";

				oTimer = new Timer(200, 1);
				oTimer.addEventListener(TimerEvent.TIMER, updateClockDots);
				oTimer.start();
			}
			else {
				oClassicClock.itemClock.LabelDot1.text = ":";
				oClassicClock.itemClock.LabelDot2.text = ":";

				oTimer = new Timer(nAnimClockDotsDelay * 1000, 1);
				oTimer.addEventListener(TimerEvent.TIMER, updateClockDots);
				oTimer.start();
			}
		}
		
		public function getClockComponent(): DisplayClassicClock { return oClassicClock; }
	}
}