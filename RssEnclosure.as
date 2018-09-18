package {
	
	public class RssEnclosure {
		private var sEnclosureUrlAttr: String;
		private var sEnclosureLengthAttr: String;
		private var sEnclosureTypeAttr: String;
		
		public function RssEnclosure(sEnclosureUrlAttr: String, sEnclosureLengthAttr: String, sEnclosureTypeAttr: String) {
			this.sEnclosureUrlAttr = sEnclosureUrlAttr;
			this.sEnclosureLengthAttr = sEnclosureLengthAttr;
			this.sEnclosureTypeAttr = sEnclosureTypeAttr;
		}

		public function setEnclosure(sEnclosureUrlAttr: String, sEnclosureLengthAttr: String, sEnclosureTypeAttr: String) { this.sEnclosureUrlAttr = sEnclosureUrlAttr; this.sEnclosureLengthAttr = sEnclosureLengthAttr; this.sEnclosureTypeAttr = sEnclosureTypeAttr; }

		public function isImage(): Boolean { return (sEnclosureTypeAttr.search("image") != -1) }
		public function isVideo(): Boolean { return (sEnclosureTypeAttr.search("video") != -1) }
		public function isAudio(): Boolean { return (sEnclosureTypeAttr.search("audio") != -1) }
		
		public function getUrlAttr(): String { return sEnclosureUrlAttr; }
		public function getLengthAttr(): String { return sEnclosureLengthAttr; }
		public function getTypeAttr(): String { return sEnclosureTypeAttr; }
	}
}