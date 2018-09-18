package {
	import RssPubDate;
	import RssEnclosure;
	
	public class RssItem {
		private var sTitle: String;
		private var sLink: String;
		private var sDescription: String;
		private var sAuthor: String;
		private var sCategory: String;
		private var sCategoryDomainAttr: String;
		private var sComments: String;
		private var sSource: String;
		private var sSourceUrlAttr: String;
		private var sGuid: String;
		private var bGuidPermaLinkAttr: Boolean;
		private var oEnclosureAudioItems: Array;
		private var oEnclosureImageItems: Array;
		private var oEnclosureVideoItems: Array;
		private var oEnclosureOtherItems: Array;
		private var oEnclosureMediaItems: Array;
		private var nCurrentPointer: uint;
		private var bFirst: Boolean;
		private var bIsDiary: Boolean;
		private var oPubDate: RssPubDate;
		
		public function RssItem(bIsDiary: Boolean = false) { 
			oEnclosureAudioItems = new Array();
			oEnclosureImageItems = new Array();
			oEnclosureVideoItems = new Array();
			oEnclosureOtherItems = new Array();
			oEnclosureMediaItems = new Array();
			
			this.bIsDiary = bIsDiary;
			this.bFirst = true;
			this.nCurrentPointer = 0;
		}
		
		// --> Setters
		public function setTitle(sTitle: String) { this.sTitle = sTitle; }
		public function setLink(sLink: String) { this.sLink = sLink; }
		public function setDescription(sDescription: String) { this.sDescription = sDescription; }
		public function setAuthor(sAuthor: String) { this.sAuthor = sAuthor; }
		public function setCategory(sCategory: String, sCategoryDomainAttr: String = null) { this.sCategory = sCategory; this.sCategoryDomainAttr = sCategoryDomainAttr; }
		public function setSource(sSource: String, sSourceUrlAttr: String) { this.sSource = sSource; this.sSourceUrlAttr = sSourceUrlAttr; }
		public function setGuid(sGuid: String, bGuidPermaLinkAttr = false) { this.sGuid = sGuid; this.bGuidPermaLinkAttr = bGuidPermaLinkAttr; }
		public function setComments(sComments: String) { this.sComments = sComments; }
		public function setPubDate(oPubDate: RssPubDate) { this.oPubDate = oPubDate; }
		
		public function addEnclosureItem(sEnclosureUrlAttr: String, sEnclosureLengthAttr: String, sEnclosureTypeAttr: String) { 
			var i: uint;
			var oRssEnclosure: RssEnclosure = new RssEnclosure(sEnclosureUrlAttr, sEnclosureLengthAttr, sEnclosureTypeAttr); 
			
			if (oRssEnclosure.isAudio()) oEnclosureAudioItems.push(oRssEnclosure);
			else if (oRssEnclosure.isImage()) oEnclosureImageItems.push(oRssEnclosure);
			else if (oRssEnclosure.isVideo()) oEnclosureVideoItems.push(oRssEnclosure);
			else oEnclosureOtherItems.push(oRssEnclosure);
			
			// --> Remove all elements
			var nEnclosureItems = oEnclosureMediaItems.length;
			for (i = 0; i < nEnclosureItems; i++) oEnclosureMediaItems.pop();
			
			// --> Order media items
			for (i = 0; i < oEnclosureAudioItems.length; i++) oEnclosureMediaItems.push(oEnclosureAudioItems[i]);
			for (i = 0; i < oEnclosureImageItems.length; i++) oEnclosureMediaItems.push(oEnclosureImageItems[i]);
			for (i = 0; i < oEnclosureVideoItems.length; i++) oEnclosureMediaItems.push(oEnclosureVideoItems[i]);
		}
		
		// --> Getters
		public function getTitle(): String { return sTitle; }
		public function getLink(): String { return sLink; }
		public function getDescription(): String { return sDescription; }
		public function getAuthor(): String { return sAuthor; }
		public function getCategory(): String { return sCategory; }
		public function getCategoryDomainAttr(): String { return sCategoryDomainAttr; }
		public function getSource(): String { return sSource; }
		public function getSourceUrlAttr(): String { return sSourceUrlAttr; }
		public function getGuid(): String { return sGuid; }
		public function getGuidPermaLinkAttr(): Boolean { return bGuidPermaLinkAttr; }
		public function getComments(): String { return sComments; }
		public function getPubDate(): RssPubDate { return oPubDate; }
		public function getEnclosureMediaItems(): Array { return oEnclosureMediaItems; }
		public function haveEnclosureAudio(): Boolean { return (oEnclosureAudioItems.length > 0); }
		public function haveEnclosureImage(): Boolean { return (oEnclosureImageItems.length > 0); }
		public function haveEnclosureVideo(): Boolean { return (oEnclosureVideoItems.length > 0); }
		
		public function getNextMediaItem(): RssEnclosure {
			if (oEnclosureMediaItems.length > 0) {
				var oEnclosureItem: RssEnclosure = oEnclosureMediaItems[nCurrentPointer];
				
				nCurrentPointer = (nCurrentPointer + 1) % oEnclosureMediaItems.length;
				
				if ((nCurrentPointer != 0) || (bFirst)) { 
					if (bFirst) bFirst = false;
					return oEnclosureItem;
				}
				else {
					bFirst = true;
					return null;
				}
			}
			return null;
		}

		public function getNextImageItem(): RssEnclosure {
			if (oEnclosureImageItems.length > 0) {
				var oEnclosureItem: RssEnclosure = oEnclosureImageItems[nCurrentPointer];
				
				nCurrentPointer = (nCurrentPointer + 1) % oEnclosureImageItems.length;
				
				if ((nCurrentPointer != 0) || (bFirst)) { 
					if (bFirst) bFirst = false;
					return oEnclosureItem;
				}
				else {
					bFirst = true;
					return null;
				}
			}
			return null;
		}
		
		public function getIsDiary(): Boolean { return this.bIsDiary; }
	}
}