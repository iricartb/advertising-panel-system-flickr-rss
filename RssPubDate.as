package {

	public class RssPubDate {
		private var nYear: uint;
		private var nMonth: uint;
		private var nDay: uint;
		private var nHour: uint;
		private var nMin: uint;
		private var nSec: uint;
		
		public function RssPubDate(sRssPubDate: String) {
			nDay = 0; nMonth = 0; nYear = 0;
			nHour = 0; nMin = 0; nSec = 0;
			
			// --> Example Sun, 19 May 2002 15:21:36 GMT
			var oRssPubDateArray: Array = sRssPubDate.split("\x20");
			if (oRssPubDateArray.length == 6) {
				nDay = oRssPubDateArray[1];
				nMonth = getMonthIndex(oRssPubDateArray[2]); 
				nYear = oRssPubDateArray[3];
				
				var oHourArray: Array = oRssPubDateArray[4].split(":");
				if (oHourArray.length == 3) {
					nHour = oHourArray[0];
					nMin = oHourArray[1];
					nSec = oHourArray[2];
				}
			}
		}
		
		public function getMonthIndex(sMonthName: String): uint {
			if (sMonthName == "Jan") return 1;
			if (sMonthName == "Feb") return 2;
			if (sMonthName == "Mar") return 3;
			if (sMonthName == "Apr") return 4;
			if (sMonthName == "May") return 5;
			if (sMonthName == "Jun") return 6;
			if (sMonthName == "Jul") return 7;
			if (sMonthName == "Aug") return 8;
			if (sMonthName == "Sep") return 9;
			if (sMonthName == "Oct") return 10;
			if (sMonthName == "Nov") return 11;
			if (sMonthName == "Dec") return 12;
			return 0;
		}
		
		public function getYear(): uint { return nYear; }
		public function getMonth(): uint { return nMonth; }
		public function getDay(): uint { return nDay; }
		public function getHour(): uint { return nHour; }
		public function getMin(): uint { return nMin; }
		public function getSec(): uint { return nSec; }
	}
}