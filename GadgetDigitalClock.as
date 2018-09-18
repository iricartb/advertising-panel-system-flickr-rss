package {
   import flash.display.MovieClip;
   import flash.utils.Timer;
   import flash.events.TimerEvent;
   import flash.display.Sprite;
	
	public class GadgetDigitalClock extends Sprite {
		private var oDigitalClock: DisplayDigitalClock;
		private var nAnimClockDotsDelay: Number;
		
		public function GadgetDigitalClock(x: uint, y: uint, bAnimClockDots: Boolean = false, nAnimClockDotsDelay: Number = 1) {
			oDigitalClock = new DisplayDigitalClock();
    		
			oDigitalClock.x = x;
			oDigitalClock.y = y;

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
			oDigitalClock.itemClock.LabelHours1.text = sHours.charAt(0);
			oDigitalClock.itemClock.LabelHours2.text = sHours.charAt(1);
			oDigitalClock.itemClock.LabelMinutes1.text = sMinutes.charAt(0);
			oDigitalClock.itemClock.LabelMinutes2.text = sMinutes.charAt(1);
			oDigitalClock.itemClock.LabelSeconds1.text = sSeconds.charAt(0);
			oDigitalClock.itemClock.LabelSeconds2.text = sSeconds.charAt(1);
		}
		
		private function updateClockDots(event: TimerEvent = null): void {
			var oTimer: Timer;
			
			if (oDigitalClock.itemClock.LabelDot1.text == ":") {
				oDigitalClock.itemClock.LabelDot1.text = "";
				oDigitalClock.itemClock.LabelDot2.text = "";

				oTimer = new Timer(200, 1);
				oTimer.addEventListener(TimerEvent.TIMER, updateClockDots);
				oTimer.start();
			}
			else {
				oDigitalClock.itemClock.LabelDot1.text = ":";
				oDigitalClock.itemClock.LabelDot2.text = ":";

				oTimer = new Timer(nAnimClockDotsDelay * 1000, 1);
				oTimer.addEventListener(TimerEvent.TIMER, updateClockDots);
				oTimer.start();
			}
		}
		
		public function getClockComponent(): DisplayDigitalClock { return oDigitalClock; }
	}
}