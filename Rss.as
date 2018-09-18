package {
   import Strings;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.display.MovieClip;
      
   public class Rss {
      private var sRssTitle: String;
      private var sRssUrl: String;
      private var oItems: Array; 
      private var oTmpItems: Array;
      private var oRssItems: Array;
      private var bOrderByPublishDate: Boolean;
      private var sFilterCurrentDateHourStartVar: String;
      private var sFilterCurrentDateHourEndVar: String;
      private var nFilterNumItems: uint;
      private var oCurrentDate: Date;
      private var bDataLoaded: Boolean;
      private var nCurrentPointer: uint;
      private var bLastDataLoaded: Boolean;
      private var bIsDiary: Boolean;
      private var cDate:String;
      private var rItems: uint;
      
      public function Rss(sRssUrl, sRssTitle = null, bOrderByPublishDate = false, nFilterNumItems = 0, sFilterCurrentDateHourStartVar = null, sFilterCurrentDateHourEndVar = null, bIsDiary = false) {
         this.sRssUrl = sRssUrl;
         this.oItems = new Array();
         this.oTmpItems = new Array();
         this.oRssItems = new Array();
         this.bOrderByPublishDate = bOrderByPublishDate;
         this.bIsDiary = bIsDiary;
         
         if ((sFilterCurrentDateHourStartVar != null) && (sFilterCurrentDateHourStartVar.length > 0)) this.sFilterCurrentDateHourStartVar = sFilterCurrentDateHourStartVar;
         if ((sFilterCurrentDateHourEndVar != null) && (sFilterCurrentDateHourEndVar.length > 0)) this.sFilterCurrentDateHourEndVar = sFilterCurrentDateHourEndVar;
         
         this.sRssTitle = sRssTitle;
         
         this.nFilterNumItems = nFilterNumItems;
         this.nCurrentPointer = 0;
         
         oCurrentDate = new Date();
         bLastDataLoaded = false;
         
         refreshXmlData();
      }
      
      private function onLoadXml(event: Event): void {
         try {
            processXml(new XML(event.target.data));
         } catch (oError: TypeError) { trace("[ Rss -> Document -> Error ] >>> Document XML: " + sRssUrl + " mal format."); }
      }
      
      private function refreshXmlData() {
         bDataLoaded = false;
         var sFilterDateHour = "";
         var oDate: Date = new Date();
         var sCurrentDateIni = oDate.fullYear + "-" + Strings.getPaddingZeroNumber(oDate.month + 1) + "-" + Strings.getPaddingZeroNumber(oDate.date) + " " + Strings.getPaddingZeroNumber(oDate.hours) + ":" + Strings.getPaddingZeroNumber(oDate.minutes) + ":" + Strings.getPaddingZeroNumber(oDate.seconds);
         
         oDate.date += 1;
         var sCurrentDateFi = oDate.fullYear + "-" + Strings.getPaddingZeroNumber(oDate.month + 1) + "-" + Strings.getPaddingZeroNumber(oDate.date) + " 23:59:59";
         
         this.cDate = "";
         this.rItems = 1;
         this.nCurrentPointer = 0;
         
         if (this.sFilterCurrentDateHourStartVar != null) {
            sFilterDateHour = "?" + this.sFilterCurrentDateHourStartVar + "=" + sCurrentDateIni;
         }
         if (this.sFilterCurrentDateHourEndVar != null) {
            if (sFilterDateHour.length > 0) sFilterDateHour = sFilterDateHour + "&" + this.sFilterCurrentDateHourEndVar + "=" + sCurrentDateFi;
            else sFilterDateHour = "?" + this.sFilterCurrentDateHourEndVar + "=" + sCurrentDateFi;
         }
         
         var xmlLoader: URLLoader = new URLLoader();
         xmlLoader.addEventListener(Event.COMPLETE, onLoadXml);
         xmlLoader.addEventListener(IOErrorEvent.IO_ERROR, onHttpRequestError);
         xmlLoader.load(new URLRequest(sRssUrl + sFilterDateHour));
         
         function onHttpRequestError(event: IOErrorEvent): void { 
            if (Globals.DEBUG_APPLICATION) trace("[ Rss -> Connexió -> Error ] >>> Error al connectar-se al contingut de noticies " + sRssUrl);
         }
      }
      
      private function processXml(oXml: XML): Boolean {
         var i: uint = 0;
         var bFindFirstElement: Boolean = false;
         
         // --> Remove all items
         var nNumItems: uint = oItems.length;
         for (i = 0; i < nNumItems; i++) oItems.pop();
         
         // --> Remove all items
         nNumItems = oTmpItems.length;
         for (i = 0; i < nNumItems; i++) oTmpItems.pop();
         
         if (Globals.DEBUG_APPLICATION) trace("[ Rss -> XML ] >>> Processant document XML ...");

         if (oXml.elements().length() > 0) {
            var oXmlChannel: XML = oXml.elements()[0];
            
            i = 0;
            for each(var oItem: XML in oXmlChannel.elements()) {
               if (!bFindFirstElement) {
                  // --> Put pointer to first xml item
                  if (oItem.name() == "item") bFindFirstElement = true;
               }
               
               if (bFindFirstElement) {
                  if (Globals.DEBUG_APPLICATION) trace("[ Rss -> Element ] >>> Carregant un nou element [ Total: " +  String(i + 1) + " ] ...");
      
                  var oRssItem: RssItem = new RssItem(this.bIsDiary);

                  if (oItem.title.toString().length > 0) oRssItem.setTitle(oItem.title.toString());
                  if (oItem.link.toString().length > 0) oRssItem.setLink(oItem.link.toString());
                  if (oItem.description.toString().length > 0) oRssItem.setDescription(oItem.description.toString());
                  if (oItem.author.toString().length > 0) oRssItem.setAuthor(oItem.author.toString());
                  if (oItem.category.toString().length > 0) oRssItem.setCategory(oItem.category.toString(), oItem.category.@domain.toString());
                  if (oItem.comments.toString().length > 0) oRssItem.setComments(oItem.comments.toString());
                  if (oItem.source.toString().length > 0) oRssItem.setSource(oItem.source.toString(), oItem.source.@url.toString());
                  if (oItem.guid.toString().length > 0) oRssItem.setGuid(oItem.guid.toString(), oItem.guid.@isPermaLink.toString() == "true");
                  
                  // --> Add attach media content
                  var oEnclosureItems: Array = oItem.toString().split("<enclosure");
                  for(var j: uint = 1; j < oEnclosureItems.length; j++) {
                     var oEnclosureItemsClean: Array = oEnclosureItems[j].split(">");
                     
                     if ((oEnclosureItemsClean.length > 0) && (oEnclosureItemsClean[0].toString().length > 0) && (oEnclosureItemsClean[0].toString().charAt(oEnclosureItemsClean[0].toString().length - 1) == "/")) {
                        oEnclosureItemsClean[0] = "<enclosure" + oEnclosureItemsClean[0] + ">";
                        
                        var oXmlEnclosure = new XML(oEnclosureItemsClean[0]);
                        oRssItem.addEnclosureItem(oXmlEnclosure.@url.toString(), oXmlEnclosure.@length.toString(), oXmlEnclosure.@type.toString());
                     }
                  }
                  
                  if (oItem.pubDate.toString().length > 0) {
                     var oPubDate: RssPubDate = new RssPubDate(oItem.pubDate.toString());
                     oRssItem.setPubDate(oPubDate);
                  }
                  
                  oTmpItems.push(oRssItem);
                  i++;
                  
                  if (Globals.DEBUG_APPLICATION) trace("[ Rss -> Element -> OK ] >>> Element carregat correctament.");
               }
            }
            
            for (i = 0; i < oTmpItems.length; i++) oItems.push(oTmpItems[i]);
            
            // --> Order array items
            if (bOrderByPublishDate) {
               if (Globals.DEBUG_APPLICATION) trace("[ Rss -> Ordre ] >>> Ordenant elements ...");
               oItems.sort(sortByPublishDate);
               if (Globals.DEBUG_APPLICATION) trace("[ Rss -> Ordre -> OK ] >>> Ordenant elements ...");
            }
            
            // --> Filter num items (0 => no filter)
            if (nFilterNumItems > 0) {
               if (Globals.DEBUG_APPLICATION) trace("[ Rss -> Filtre -> Num Elements ] >>> Filtrant elements [ Total: " +  oItems.length + " ] ...");
               var nItemsToRemove: int = (oItems.length - nFilterNumItems);
               if (nItemsToRemove < 0) nItemsToRemove = 0;
               
               for (i = 0; i < nItemsToRemove; i++) oItems.pop();
               if (Globals.DEBUG_APPLICATION) trace("[ Rss -> Filtre -> Num Elements -> OK ] >>> El filtrat s'ha efectuat correctament [ Total: " +  oItems.length + " ].");
            }
            
            if (Globals.DEBUG_APPLICATION) trace("[ Rss -> XML -> OK ] >>> Document XML processat correctament.");
            bDataLoaded = true;
            return true;
         }
         else {
            if (Globals.DEBUG_APPLICATION) trace("[ Rss -> XML -> Error ] >>> Error processant document XML.");
            bDataLoaded = false;
            return false;
         }
      }
      
      private function sortByPublishDate(oItem1: RssItem, oItem2: RssItem): int {
         if ((oItem1.getPubDate() == null) || (oItem2.getPubDate() == null)) return 0;
         
         if (oItem1.getPubDate().getYear() > oItem2.getPubDate().getYear()) return -1;
         else {
            if (oItem1.getPubDate().getYear() < oItem2.getPubDate().getYear()) return 1;
            else {
               if (oItem1.getPubDate().getMonth() > oItem2.getPubDate().getMonth()) return -1;
               else {
                  if (oItem1.getPubDate().getMonth() < oItem2.getPubDate().getMonth()) return 1;
                  else {
                     if (oItem1.getPubDate().getDay() > oItem2.getPubDate().getDay()) return -1;
                     else {
                        if (oItem1.getPubDate().getDay() < oItem2.getPubDate().getDay()) return 1;
                        else {
                           if (oItem1.getPubDate().getHour() > oItem2.getPubDate().getHour()) return -1;
                           else {
                              if (oItem1.getPubDate().getHour() < oItem2.getPubDate().getHour()) return 1;
                              else {
                                 if (oItem1.getPubDate().getMin() > oItem2.getPubDate().getMin()) return -1;
                                 else {
                                    if (oItem1.getPubDate().getMin() < oItem2.getPubDate().getMin()) return 1;
                                    else {
                                       if (oItem1.getPubDate().getSec() > oItem2.getPubDate().getSec()) return -1;
                                       else return 1;
                                    }
                                 }
                              }
                           }
                        }
                     }
                  }
               }
            }
         }
      }
      
      public function isDataLoaded(): Boolean { return bDataLoaded; }
      
      public function getNextThreeItems(): Array {
         var i: int;
         
         bLastDataLoaded = false;
         if (this.isDataLoaded()) {
            if (oItems.length > 0) {
               var nRssItems:int = oRssItems.length;
               for (i = 0; i < nRssItems; i++) oRssItems.pop();
               
               for (i = 0; i < 3; i++) {
                  var oRssItem: RssItem = oItems[nCurrentPointer];
                  
                  // Tecnique Diary
                  if (!bIsDiary) {
                     nCurrentPointer = (nCurrentPointer + 1) % oItems.length;
                     if (nCurrentPointer == 0) {
                        refreshXmlData();
                        bLastDataLoaded = true;
                        i = 2;
                     }
                     oRssItems.push(oRssItem);
                  }
                  else {
                     var nPosition: int = oRssItem.getCategory().lastIndexOf(" ");
                     if (nPosition != -1) {
                        var sDate: String = oRssItem.getCategory().substr(nPosition - 10, 10);
                        if (this.cDate == "") this.cDate = sDate;
                        
                        if (this.cDate == sDate) {
                           nCurrentPointer = (nCurrentPointer + 1) % oItems.length;
                           if ((nCurrentPointer == 0) || (rItems == (Globals.RSS_NUMLAYOUTS_TOCHANGE_RSS * 3))) {
                              refreshXmlData();
                              rItems = 0;
                              bLastDataLoaded = true;
                              i = 2;
                           }
                           oRssItems.push(oRssItem);
                           rItems = rItems + 1;
                        }
                        else {
                           this.cDate = sDate;
                           
                           // Change Date
                           if (i == 0) {
                              i--;
                           }
                           else {
                              rItems = rItems + (3 - i);
                              
                              if (rItems >= (Globals.RSS_NUMLAYOUTS_TOCHANGE_RSS * 3)) {
                                 refreshXmlData();
                                 rItems = 1;
                                 bLastDataLoaded = true;
                              }
                              i = 2;               
                           }
                        }
                     }
                  }
               }
               return oRssItems;
            }
         }
         return null;
      }
      
      public function getRssUrl(): String { return sRssUrl; }
      public function getLastDataLoaded(): Boolean { return bLastDataLoaded; }
      public function getRssTitle(): String { return sRssTitle; }
      public function getIsDiary(): Boolean { return this.bIsDiary; }
   }
}