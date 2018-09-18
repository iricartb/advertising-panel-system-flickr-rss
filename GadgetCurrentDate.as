package {
   import flash.display.Sprite;
   import flash.utils.Timer;
   import flash.events.TimerEvent;
   
   public class GadgetCurrentDate extends Sprite {
      private var oCurrentDate: DisplayCurrentDate;
      private var oDateNow: Date;
      private var oDays: Array;
      private var oMonths: Array;
      
      public function GadgetCurrentDate(x: uint, y: uint) {
         oCurrentDate = new DisplayCurrentDate();
          oDays = new Array("dilluns", "dimarts", "dimecres", "dijous", "divendres", "dissabte", "diumenge");
         oMonths = new Array("de gener", "de febrer", "de març", "d'abril", "de maig", "de juny", "de juliol", "d'agost", "de setembre", "d'octubre", "de novembre", "de desembre");
         
         oCurrentDate.x = x;
         oCurrentDate.y = y;
      }
      
      public function actualizeCurrentDate(sSentence: String = null): void { // public function actualizeCurrentDate(event: TimerEvent = null): void {
         if (sSentence == null) {
            oDateNow = new Date();
            var nDateDay: uint = oDateNow.getDay();
            
            if (nDateDay == 0) nDateDay = 6
            else nDateDay = nDateDay - 1
            
            var sCurrentDay: String = oDays[nDateDay].charAt(0).toUpperCase() + oDays[nDateDay].substring(1, oDays[nDateDay].length);
            
            oCurrentDate.itemData.LabelCurrentDate.text =  sCurrentDay + " " + oDateNow.date + " " + oMonths[oDateNow.getMonth()];
         }
         else if (sSentence == "+1") {
            oDateNow = new Date();
            oDateNow.date += 1;
            
            var nDateDay2: uint = oDateNow.getDay();
            
            if (nDateDay2 == 0) nDateDay2 = 6
            else nDateDay2 = nDateDay2 - 1
            
            oCurrentDate.itemData.LabelCurrentDate.text = "Demà " +  oDays[nDateDay2] + " " + oDateNow.date + " " + oMonths[oDateNow.getMonth()];            
         }
         else oCurrentDate.itemData.LabelCurrentDate.text = sSentence;
      }
      
      public function getComponent(): DisplayCurrentDate { return oCurrentDate; }
   }
}