package {
   import com.adobe.webapis.flickr.*;
   import com.adobe.webapis.flickr.methodgroups.*;
   import com.adobe.webapis.flickr.events.*;
	import Transition;
	import flash.display.Sprite;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.display.Bitmap;
	import flash.net.URLRequest;
	import flash.display.Loader;
	import flash.system.LoaderContext;
	import flash.system.ApplicationDomain;
	import flash.events.Event;
	
	public class FlickrGallery extends Sprite {
		private static const FLICKR_STATE_CONNECTION_OK: String = "FLICKR_CONNECTION_OK";
		private static const FLICKR_STATE_CONNECTION_NO_START: String = "FLICKR_CONNECTION_NO_START";
		private static const FLICKR_STATE_CONNECTION_SLEEP: String = "FLICKR_CONNECTION_SLEEP";
		private static const FLICKR_STATE_CONNECTION_ERROR: String = "FLICKR_CONNECTION_ERROR";
		
		private var oTransitionEffect: Transition;
		private var nTransitionDelay: Number;
		
		private var nSizeWidth: uint;
		private var nSizeHeight: uint;
		private var nCurrentLoadingItem: int;
		
		private var sFlickrStateConnection: String = FlickrGallery.FLICKR_STATE_CONNECTION_NO_START;
		private var oFlickrService: FlickrService;
		private var oPhotos: Photos;
		private var oFlickrBitmap: Bitmap;
		private var sFlickrBeforeImageId: String;
		private var sFlickrId: String;
		private var sFlickrSecret: String;
		private var sFlickrPhotosetName: String;
		private var sFlickrPhotosetId: String;
		private var nCircularRadio: uint;
		
		public function FlickrGallery(sFlickrUsername: String, sFlickrPhotosetName: String, sFlickrApiKey: String, sFlickrApiSecret: String, nSizeWidth: uint, nSizeHeight: uint, sTransitionEffect: String, nTransitionDelay: Number, nEffectFadeInDelay: uint, nEffectFadeOutDelay: uint, nCircularRadio: uint = 10) {	
			this.nSizeWidth = nSizeWidth;
			this.nSizeHeight = nSizeHeight;
			this.nTransitionDelay = nTransitionDelay;
			
			if (this.nTransitionDelay <= 0) { this.nTransitionDelay = 1 }
			this.nCurrentLoadingItem = -1;
			
			if (nEffectFadeInDelay == 0) nEffectFadeInDelay = 1;
			if (nEffectFadeOutDelay == 0) nEffectFadeOutDelay = 1;
			
			this.nCircularRadio = nCircularRadio;
			
			if (sTransitionEffect == Transition.TRANSITION_CIRCLE) oTransitionEffect = new CircularTransition(nSizeWidth, nSizeHeight, nEffectFadeInDelay, nEffectFadeOutDelay);
			else if (sTransitionEffect == Transition.TRANSITION_FADE) oTransitionEffect = new FadeTransition(nSizeWidth, nSizeHeight, nEffectFadeInDelay, nEffectFadeOutDelay);
			else oTransitionEffect = new SimpleTransition(nSizeWidth, nSizeHeight, nEffectFadeInDelay, nEffectFadeOutDelay);
			addChild(oTransitionEffect);
			
			oFlickrService = new FlickrService(sFlickrApiKey);
			this.sFlickrSecret = sFlickrApiSecret;
			this.sFlickrPhotosetName = sFlickrPhotosetName;
			oPhotos = new Photos(oFlickrService);
			
			// --> Initialize events
			oFlickrService.addEventListener(FlickrResultEvent.PEOPLE_FIND_BY_USERNAME, onPeopleFindByUsername);
			oFlickrService.addEventListener(FlickrResultEvent.PHOTOSETS_GET_LIST, onPhotosetsGetList);
			oFlickrService.addEventListener(FlickrResultEvent.PHOTOSETS_GET_PHOTOS, onPhotosetsGetPhotos);
			oFlickrService.addEventListener(FlickrResultEvent.PHOTOS_GET_SIZES, onPhotosGetSize);
			
			sFlickrStateConnection = FlickrGallery.FLICKR_STATE_CONNECTION_SLEEP;
			oFlickrService.people.findByUsername(sFlickrUsername);
			
			onChangeFlickrImage(null);
		}
		
		private function onChangeFlickrImage(event: TimerEvent): void {
			var oTimer: Timer;
			
			if (oFlickrBitmap != null) {
				oTransitionEffect.setRadio(this.nCircularRadio);
				oTransitionEffect.play(oFlickrBitmap);
				oFlickrBitmap = null;
				
				oTimer = new Timer(this.nTransitionDelay * 1000, 1);
				oTimer.addEventListener(TimerEvent.TIMER, onChangeFlickrImage);
				oTimer.start();
				
				this.loadNextPhoto();
			}
			else {
				oTimer = new Timer(500, 1);
				oTimer.addEventListener(TimerEvent.TIMER, onChangeFlickrImage);
				oTimer.start();
			}
		}
		
		private function onPeopleFindByUsername(event: FlickrResultEvent): void {
			if (event.success) {
				var oUser: User = event.data.user;
				
				if (oUser != null) {
					sFlickrId = oUser.nsid;
					sFlickrStateConnection = FlickrGallery.FLICKR_STATE_CONNECTION_OK;
					
					// --> Search photoset id
					oFlickrService.photosets.getList(sFlickrId);
				}
				else sFlickrStateConnection = FlickrGallery.FLICKR_STATE_CONNECTION_ERROR;
			}
			else sFlickrStateConnection = FlickrGallery.FLICKR_STATE_CONNECTION_ERROR;
		}
		
		private function onPhotosetsGetList(event: FlickrResultEvent): void {
			if (event.success) {
				var oPhotoSetList: Array = event.data.photoSets;
				var bFlickrFindPhotosetId = false;
				
				if (oPhotoSetList != null) {
					for(var i:uint = 0; ((i < oPhotoSetList.length) && (!bFlickrFindPhotosetId)); i++) {
						var oPhotoSet: PhotoSet = oPhotoSetList[i];
						
						if (oPhotoSet.title == sFlickrPhotosetName) {
							sFlickrPhotosetId = oPhotoSet.id;
							bFlickrFindPhotosetId = true;
							
							this.loadNextPhoto();
						}
					}
				}
			}
		}
		
		private function loadNextPhoto(): void { if (Globals.DEBUG_APPLICATION) trace("[ FlickrGallery -> Imatge ] >>> Carregant nova imatge ..."); oFlickrService.photosets.getPhotos(sFlickrPhotosetId);	}
		
		private function onPhotosetsGetPhotos(event: FlickrResultEvent): void {
			if (event.success) {
				var oPhotoSet: PhotoSet = PhotoSet(event.data.photoSet);
				
				if (oPhotoSet.photos.length > 0) {
					nCurrentLoadingItem = ((nCurrentLoadingItem + 1) % oPhotoSet.photos.length);
					
					// --> If user add an image to flickr account and the next image to show is the same, this implies increment the counter. 
					if ((sFlickrBeforeImageId != null) && (sFlickrBeforeImageId == (oPhotoSet.photos[nCurrentLoadingItem]).id)) {
						nCurrentLoadingItem = ((nCurrentLoadingItem + 1) % oPhotoSet.photos.length);
					}
														  
					var oPhoto: Photo = oPhotoSet.photos[nCurrentLoadingItem];
					oPhotos.getSizes(oPhoto.id);
					sFlickrBeforeImageId = oPhoto.id;
				}
			}
		}
		
		private function onPhotosGetSize(event: FlickrResultEvent): void {
			if (event.success) {
				if (Globals.DEBUG_APPLICATION) trace("[ FlickrGallery -> Imatge ] >>> Agafant url de la imatge ...");
				
				var oPhotoSize: PhotoSize;
				oPhotoSize = event.data.photoSizes[event.data.photoSizes.length - 1];
		
				var loader:Loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.INIT, onHttpRequestFlickrImage);
				loader.load(new URLRequest(oPhotoSize.source), new LoaderContext(true, ApplicationDomain.currentDomain));
				
				function onHttpRequestFlickrImage(event: Event): void {
					oFlickrBitmap = Bitmap(loader.content);
					
					if (Globals.DEBUG_APPLICATION) {
						trace("[ FlickrGallery -> Imatge -> OK ] >>> Imatge " + oPhotoSize.source + " carregada de forma satisfactoria.");
					}
				}
			}
		}
		
		public function isConnected(): Boolean { return (sFlickrStateConnection == FlickrGallery.FLICKR_STATE_CONNECTION_OK); }
	}
}