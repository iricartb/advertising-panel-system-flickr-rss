package  {
   import Rss;
   import GadgetRssLogo;
   import flash.display.Sprite;
   import flash.utils.Timer;
   import flash.events.TimerEvent;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   
   public class RssGallery extends Sprite {
      private var oRss: Rss;
      private var oRssItems: Array;
      private var nLayoutsToChangeRss: Number;
      private var nCurrentLayoutToChangeRss: Number;
      private var nTransitionDelay: Number;
      private var nTransitionMediaDelay: Number;
      private var nContentAppearDelay: Number;
      private var nEffectMediaFadeInDelay: uint;
      private var nEffectMediaFadeOutDelay: uint;
      private var nCurrentRssItemPoint: uint;
      private var sCurrentRssUrl: String;
      private var sCurrentRssTitle: String;
      private var sBeforeRssTitle: String;
      private var oDisplayRssContent: DisplayRssContent;
      private var oDisplayRssTitle: DisplayRssTitle;
      private var oGadgetRssLogo: GadgetRssLogo;
      private var oGadgetCurrentDate: GadgetCurrentDate;
      private var oFadeTransition: FadeTransition;
      private var oDisplayRss: DisplayRss;
      private var bIsFirst: Boolean;
      
      public function RssGallery(x: uint, y: uint, nLayoutsToChangeRss: Number, nTransitionDelay: Number, nTransitionMediaDelay: Number, nContentAppearDelay: Number, nEffectMediaFadeInDelay: uint, nEffectMediaFadeOutDelay: uint, oDisplayRss: DisplayRss = null, oDisplayRssTitle: DisplayRssTitle = null,  oGadgetRssLogo: GadgetRssLogo = null, oGadgetCurrentDate: GadgetCurrentDate = null) {
         this.nTransitionDelay = nTransitionDelay;
         if (this.nTransitionDelay <= 0) { this.nTransitionDelay = 1 }

         this.nContentAppearDelay = nContentAppearDelay;
         if (this.nContentAppearDelay <= 0) { this.nContentAppearDelay = 1 }

         this.nTransitionMediaDelay = nTransitionMediaDelay;
         if (this.nTransitionMediaDelay <= 0) { this.nTransitionMediaDelay = 1 }
         
         this.nEffectMediaFadeInDelay = nEffectMediaFadeInDelay;
         if (this.nEffectMediaFadeInDelay <= 0) { this.nEffectMediaFadeInDelay = 1 }
         
         this.nEffectMediaFadeOutDelay = nEffectMediaFadeOutDelay;
         if (this.nEffectMediaFadeOutDelay <= 0) { this.nEffectMediaFadeOutDelay = 1 }
         
         this.nLayoutsToChangeRss = nLayoutsToChangeRss;
         if (this.nLayoutsToChangeRss <= 0) { this.nLayoutsToChangeRss = 1 }
         this.nCurrentLayoutToChangeRss = 1;
         
         this.nCurrentRssItemPoint = 0;
         this.oRssItems = new Array();
         this.sCurrentRssUrl = "";
         this.sCurrentRssTitle = "";
         this.bIsFirst = true;
         
         this.oDisplayRssContent = new DisplayRssContent();
         this.oDisplayRssContent.x = x;
         this.oDisplayRssContent.y = y;
         
         this.oDisplayRssTitle = oDisplayRssTitle;
         this.oGadgetRssLogo = oGadgetRssLogo;
         this.oGadgetCurrentDate = oGadgetCurrentDate;
         this.oDisplayRss = oDisplayRss;
         
         onChangeRssContent(null);
      }

      public function isVisibleElement(nElement: uint) {
         if (nElement == 1) return ((oDisplayRssContent.itemRssContent1.itemRssTitle.currentFrame != 1) && (oDisplayRssContent.itemRssContent1.itemRssTitle.currentFrame != 20));
         else if (nElement == 2) return ((oDisplayRssContent.itemRssContent2.itemRssTitle.currentFrame != 1) && (oDisplayRssContent.itemRssContent2.itemRssTitle.currentFrame != 20));
         else return ((oDisplayRssContent.itemRssContent3.itemRssTitle.currentFrame != 1) && (oDisplayRssContent.itemRssContent3.itemRssTitle.currentFrame != 20));
      }
      
      public function addRss(sRssUrl, sRssTitle = null, bOrderByPublishDate = false, nFilterNumItems = 0, sFilterCurrentDateHourStartVar = null, sFilterCurrentDateHourEndVar = null, bIsDiary = false) {
         oRssItems.push(new Rss(sRssUrl, sRssTitle, bOrderByPublishDate, nFilterNumItems, sFilterCurrentDateHourStartVar, sFilterCurrentDateHourEndVar, bIsDiary));
      }
      
      private function onChangeRssContent(event: TimerEvent): void {
         var oRssNextThreeItem: Array;
         var oTimerChangeContent: Timer;
         var oTimerHideRssItem: Timer;
         var oTimerAppearRssItem: Timer;
         var oTimerTextAppear: Timer;
         var i: uint;
         
         oRssNextThreeItem = getNextThreeRssItem();
         if (oRssNextThreeItem != null) {
         
            // --> Hide all graphic elements of content
            if (!bIsFirst) {
               if (isVisibleElement(1)) oDisplayRssContent.itemRssContent1.itemRssTitle.gotoAndPlay(11);
               if (isVisibleElement(2)) {
                  oTimerHideRssItem = new Timer(200, 1);
                  oTimerHideRssItem.addEventListener(TimerEvent.TIMER, onHideRssItem2);
                  oTimerHideRssItem.start();
               }
               if (isVisibleElement(3)) {
                  oTimerHideRssItem = new Timer(400, 1);
                  oTimerHideRssItem.addEventListener(TimerEvent.TIMER, onHideRssItem3);
                  oTimerHideRssItem.start();
               }
               if ((oDisplayRssTitle != null) && (sBeforeRssTitle != sCurrentRssTitle)) {
                  oDisplayRssTitle.gotoAndPlay(16);
               }
               if (oGadgetCurrentDate != null) {
                  oGadgetCurrentDate.getComponent().gotoAndPlay(16);
               }
               
               if (oDisplayRss != null) oDisplayRss.gotoAndPlay(31);
            }
            else bIsFirst = false;
            
            oTimerTextAppear = new Timer(this.nContentAppearDelay * 1000, 1);
            oTimerTextAppear.addEventListener(TimerEvent.TIMER, onAppearRssContent);
            oTimerTextAppear.start();
         
            oTimerChangeContent = new Timer(this.nTransitionDelay * 1000, 1);
            oTimerChangeContent.addEventListener(TimerEvent.TIMER, onChangeRssContent);
            oTimerChangeContent.start();
         }
         else {
            oTimerChangeContent = new Timer(500, 1);
            oTimerChangeContent.addEventListener(TimerEvent.TIMER, onChangeRssContent);
            oTimerChangeContent.start();
         }
         
         function onHideRssItem2(event: TimerEvent): void { oDisplayRssContent.itemRssContent2.itemRssTitle.gotoAndPlay(11); }
         function onAppearRssItem2(event: TimerEvent): void { oDisplayRssContent.itemRssContent2.itemRssTitle.gotoAndPlay(2); }
         function onHideRssItem3(event: TimerEvent): void { oDisplayRssContent.itemRssContent3.itemRssTitle.gotoAndPlay(11); }
         function onAppearRssItem3(event: TimerEvent): void { oDisplayRssContent.itemRssContent3.itemRssTitle.gotoAndPlay(2); }

         function onAppearRssContent(event: TimerEvent): void {
            var oRssItem1: RssItem;
            var oRssItem2: RssItem;
            var oRssItem3: RssItem;
            var sTitle: String;
            
            if (oRssNextThreeItem.length > 0) oRssItem1 = oRssNextThreeItem[0];
            if (oRssNextThreeItem.length > 1) oRssItem2 = oRssNextThreeItem[1];
            if (oRssNextThreeItem.length > 2) oRssItem3 = oRssNextThreeItem[2];
            
            if (oRssItem1 != null) {
               if (!oRssItem1.getIsDiary()) { 
                  if (oRssItem1.getTitle() != null) sTitle = Strings.htmlDecode(Strings.htmlDecode(oRssItem1.getTitle()));
                  else sTitle = "";
                  
                  if ((sTitle.length > 1) && (sTitle.charAt(0) == '"')) sTitle = sTitle.substr(1, sTitle.length - 1);
                  if ((sTitle.length > 1) && (sTitle.charAt(sTitle.length - 1) == '"')) sTitle = sTitle.substr(0, sTitle.length - 1);
                  
                  oDisplayRssContent.itemRssContent1.itemRssTitle.itemTitle.LabelTitle.text = sTitle;
               }
               else {
                  if (oRssItem1.getTitle() != null) sTitle = Strings.htmlDecode(Strings.htmlDecode(oRssItem1.getTitle()));
                  else sTitle = "";
                  
                  if ((sTitle.length > 1) && (sTitle.charAt(0) == '"')) sTitle = sTitle.substr(1, sTitle.length - 1);
                  if ((sTitle.length > 1) && (sTitle.charAt(sTitle.length - 1) == '"')) sTitle = sTitle.substr(0, sTitle.length - 1);
                  
                  oDisplayRssContent.itemRssContent1.itemRssTitle.itemTitle.LabelTitle.text = sTitle;
                  Strings.truncateTextField(oDisplayRssContent.itemRssContent1.itemRssTitle.itemTitle.LabelTitle, 1);
               
                  if (oRssItem1.getCategory() != null) {
                     var nPosition: int = oRssItem1.getCategory().lastIndexOf(" ");
                     
                     var comments: String = "";
                     if (oRssItem1.getComments() != null) {
                        var listComments: Array = oRssItem1.getComments().split(",");
                        if (listComments.length >= 1) comments = " - " + listComments[0];
                        if (listComments.length >= 2) comments = comments + ", " + listComments[1];
                        if (listComments.length >= 3) comments = comments + ", " + listComments[2];
                     }
                     oDisplayRssContent.itemRssContent1.itemRssTitle.itemTitle.LabelTitle.text = oDisplayRssContent.itemRssContent1.itemRssTitle.itemTitle.LabelTitle.text + "\n" + oRssItem1.getCategory().substr(nPosition + 1, 6) + comments;
                  }
               }
            }

            if (oRssItem2 != null) {
               if (!oRssItem2.getIsDiary()) { 
                  if (oRssItem2.getTitle() != null) sTitle = Strings.htmlDecode(Strings.htmlDecode(oRssItem2.getTitle()));
                  else sTitle = "";
                  
                  if ((sTitle.length > 1) && (sTitle.charAt(0) == '"')) sTitle = sTitle.substr(1, sTitle.length - 1);
                  if ((sTitle.length > 1) && (sTitle.charAt(sTitle.length - 1) == '"')) sTitle = sTitle.substr(0, sTitle.length - 1);
                  
                  oDisplayRssContent.itemRssContent2.itemRssTitle.itemTitle.LabelTitle.text = sTitle;
               }
               else {
                  if (oRssItem2.getTitle() != null) sTitle = Strings.htmlDecode(Strings.htmlDecode(oRssItem2.getTitle()));
                  else sTitle = "";
                  
                  if ((sTitle.length > 1) && (sTitle.charAt(0) == '"')) sTitle = sTitle.substr(1, sTitle.length - 1);
                  if ((sTitle.length > 1) && (sTitle.charAt(sTitle.length - 1) == '"')) sTitle = sTitle.substr(0, sTitle.length - 1);
                  
                  oDisplayRssContent.itemRssContent2.itemRssTitle.itemTitle.LabelTitle.text = sTitle;
                  Strings.truncateTextField(oDisplayRssContent.itemRssContent2.itemRssTitle.itemTitle.LabelTitle, 1);
               
                  if (oRssItem2.getCategory() != null) {
                     var nPosition2: int = oRssItem2.getCategory().lastIndexOf(" ");
                     
                     var comments2: String = "";
                     if (oRssItem2.getComments() != null) {
                        var listComments2: Array = oRssItem2.getComments().split(",");
                        if (listComments2.length >= 1) comments2 = " - " + listComments2[0];
                        if (listComments2.length >= 2) comments2 = comments2 + ", " + listComments2[1];
                        if (listComments2.length >= 3) comments2 = comments2 + ", " + listComments2[2];
                     }
                     oDisplayRssContent.itemRssContent2.itemRssTitle.itemTitle.LabelTitle.text = oDisplayRssContent.itemRssContent2.itemRssTitle.itemTitle.LabelTitle.text + "\n" + oRssItem2.getCategory().substr(nPosition2 + 1, 6) + comments2;
                  }
               }
            }

            if (oRssItem3 != null) {
               if (!oRssItem3.getIsDiary()) {
                  if (oRssItem3.getTitle() != null) sTitle = Strings.htmlDecode(Strings.htmlDecode(oRssItem3.getTitle()));
                  else sTitle = "";
                  
                  if ((sTitle.length > 1) && (sTitle.charAt(0) == '"')) sTitle = sTitle.substr(1, sTitle.length - 1);
                  if ((sTitle.length > 1) && (sTitle.charAt(sTitle.length - 1) == '"')) sTitle = sTitle.substr(0, sTitle.length - 1);
                  
                  oDisplayRssContent.itemRssContent3.itemRssTitle.itemTitle.LabelTitle.text = sTitle;
               }
               else {
                  if (oRssItem3.getTitle() != null) sTitle = Strings.htmlDecode(Strings.htmlDecode(oRssItem3.getTitle()));
                  else sTitle = "";
                  
                  if ((sTitle.length > 1) && (sTitle.charAt(0) == '"')) sTitle = sTitle.substr(1, sTitle.length - 1);
                  if ((sTitle.length > 1) && (sTitle.charAt(sTitle.length - 1) == '"')) sTitle = sTitle.substr(0, sTitle.length - 1);
                  
                  oDisplayRssContent.itemRssContent3.itemRssTitle.itemTitle.LabelTitle.text = sTitle;
                  Strings.truncateTextField(oDisplayRssContent.itemRssContent3.itemRssTitle.itemTitle.LabelTitle, 1);
               
                  if (oRssItem3.getCategory() != null) {
                     var nPosition3: int = oRssItem3.getCategory().lastIndexOf(" ");
                     
                     var comments3: String = "";
                     if (oRssItem3.getComments() != null) {
                        var listComments3: Array = oRssItem3.getComments().split(",");
                        if (listComments3.length >= 1) comments3 = " - " + listComments3[0];
                        if (listComments3.length >= 2) comments3 = comments3 + ", " + listComments3[1];
                        if (listComments3.length >= 3) comments3 = comments3 + ", " + listComments3[2];
                     }
                     oDisplayRssContent.itemRssContent3.itemRssTitle.itemTitle.LabelTitle.text = oDisplayRssContent.itemRssContent3.itemRssTitle.itemTitle.LabelTitle.text + "\n" + oRssItem3.getCategory().substr(nPosition3 + 1, 6) + comments3;
                  }
               }
            }

            if (oDisplayRss != null) oDisplayRss.itemRss.LabelUrl.text = sCurrentRssUrl;
            if ((oDisplayRssTitle != null) && (sBeforeRssTitle != sCurrentRssTitle)) {
               oDisplayRssTitle.itemTitle.LabelTitle.text = sCurrentRssTitle;
               if (oGadgetRssLogo != null) oGadgetRssLogo.changeLogo(sCurrentRssTitle);
            }
         
            if (oRssItem1 != null) oDisplayRssContent.itemRssContent1.itemRssTitle.gotoAndPlay(2);
            if (oRssItem2 != null) {
               oTimerHideRssItem = new Timer(200, 1);
               oTimerHideRssItem.addEventListener(TimerEvent.TIMER, onAppearRssItem2);
               oTimerHideRssItem.start();
            }
            if (oRssItem3 != null) {
               oTimerHideRssItem = new Timer(400, 1);
               oTimerHideRssItem.addEventListener(TimerEvent.TIMER, onAppearRssItem3);
               oTimerHideRssItem.start();
            }
            
            if ((oDisplayRssTitle != null) && (sBeforeRssTitle != sCurrentRssTitle)) oDisplayRssTitle.gotoAndPlay(2);
            if (oDisplayRss != null) oDisplayRss.gotoAndPlay(2);
            
            if (oRssNextThreeItem[0].getIsDiary()) {
               var nPosition4: int = oRssNextThreeItem[0].getCategory().lastIndexOf(" ");
               if (nPosition4 != -1) {
                  var sDay: String = oRssNextThreeItem[0].getCategory().substr(nPosition4 - 10, 2);
                  var sTitle2: String = "";
                  var oDateNow: Date = new Date();
                  
                  if (oDateNow.getDate() == parseInt(sDay)) sTitle2 = "Avui";
                  else sTitle2 = "+1";
                  oGadgetCurrentDate.actualizeCurrentDate(sTitle2);
               }
            }
            else oGadgetCurrentDate.actualizeCurrentDate();
            
            if (oGadgetCurrentDate != null) oGadgetCurrentDate.getComponent().gotoAndPlay(2);
            
            sBeforeRssTitle = sCurrentRssTitle;
         }
      }
      
      private function getNextThreeRssItem(): Array {
         if (oRssItems.length > 0) {
            if (oRssItems[nCurrentRssItemPoint].isDataLoaded()) {
               var oRssNextThreeItems: Array = oRssItems[nCurrentRssItemPoint].getNextThreeItems();
               
               if ((oRssNextThreeItems != null) && (oRssNextThreeItems.length > 0)) {
                  sCurrentRssUrl = oRssItems[nCurrentRssItemPoint].getRssUrl();
                  sCurrentRssTitle = oRssItems[nCurrentRssItemPoint].getRssTitle();
                  
                  if ((nCurrentLayoutToChangeRss == nLayoutsToChangeRss) || (oRssItems[nCurrentRssItemPoint].getLastDataLoaded())) {
                     nCurrentRssItemPoint = ((nCurrentRssItemPoint + 1) % oRssItems.length);
                     nCurrentLayoutToChangeRss = 1;
                  }
                  else nCurrentLayoutToChangeRss = nCurrentLayoutToChangeRss + 1;

                  return oRssNextThreeItems;
               }
               else {
                  nCurrentRssItemPoint = ((nCurrentRssItemPoint + 1) % oRssItems.length);
                  nCurrentLayoutToChangeRss = 1;
               }
            }
            else {
               nCurrentRssItemPoint = ((nCurrentRssItemPoint + 1) % oRssItems.length);
               nCurrentLayoutToChangeRss = 1;
            }
         }
         return null;
      }
      
      public function getDisplayComponent(): DisplayRssContent { return oDisplayRssContent; }
   }
}