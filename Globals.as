package {
   import Transition;
   import flash.system.Security;
      
   public class Globals {
      public static const SCENE_WIDTH: uint = 672;
      public static const SCENE_HEIGHT: uint = 384;
      
   /*   public static const IMAGES_TRANSITION_EFFECT: String = Transition.TRANSITION_CIRCLE;
      public static const IMAGES_TRANSITION_DELAY: Number = 60;            // --> Seconds delay
      public static const EFFECT_FADE_IN_DELAY: uint = 1;                  // --> Nº frames   
      public static const EFFECT_FADE_OUT_DELAY: uint = 1;                 // --> Nº frames
      public static const EFFECT_CIRCULAR_RADIO: uint = 25;                // --> Circular radio */
      
       public static const IMAGES_TRANSITION_EFFECT: String = Transition.TRANSITION_FADE;
      public static const IMAGES_TRANSITION_DELAY: Number = 30;            // --> Seconds delay
      public static const EFFECT_FADE_IN_DELAY: uint = 15;                 // --> Nº frames   
      public static const EFFECT_FADE_OUT_DELAY: uint = 1;                 // --> Nº frames 
      public static const EFFECT_CIRCULAR_RADIO: uint = 25;                // --> Circular radio 
      
      public static const RSS_TRANSITION_MEDIA_DELAY: Number = 10;         // --> Seconds delay
      public static const RSS_EFFECT_MEDIA_FADE_IN_DELAY: uint = 20;       // --> Nº frames
      public static const RSS_EFFECT_MEDIA_FADE_OUT_DELAY: uint = 1;       // --> Nº frames  
      public static const RSS_TRANSITION_DELAY: Number = 12;               // --> Seconds delay 
      public static const RSS_CONTENT_APPEAR_DELAY: Number = 1.75;         // --> Seconds delay
      public static const RSS_DISPLAY_POSITION_X_PERCENT: Number = 50;
      public static const RSS_DISPLAY_POSITION_Y_PERCENT: Number = 60;
      
      public static const FLICKR_API_USERNAME: String = "*************";
      public static const FLICKR_API_PHOTOSET_NAME: String = "*************";
      public static const FLICKR_API_KEY: String = "*********************************";
      public static const FLICKR_API_SECRET: String = "****************";
      
      public static const RSS_URL_1 = "URL 1"; 
      public static const RSS_URL_1_TITLE = "Title 1";
      public static const RSS_URL_1_ORDERBY_PUBDATE = true;                              // --> Order by publish date (date + hour)
      public static const RSS_URL_1_FILTER_CURRENTDATEHOUR_STARTVAR_1 = "";              // --> Filter current date variable name
      public static const RSS_URL_1_FILTER_CURRENTDATEHOUR_ENDVAR_1 = "";                // --> Filter current date variable name
      public static const RSS_URL_1_FILTER_NUMITEMS_1 = 0;                               // --> Value 0 => SHOW_ALL_ITEMS
      public static const RSS_URL_1_IS_DIARY = false;
      
      public static const RSS_URL_2 = "URL 2"; 
      public static const RSS_URL_2_TITLE = "Title 2";
      public static const RSS_URL_2_ORDERBY_PUBDATE = true;                              // --> Order by publish date (date + hour)
      public static const RSS_URL_2_FILTER_CURRENTDATEHOUR_STARTVAR_1 = "";              // --> Filter current date variable name
      public static const RSS_URL_2_FILTER_CURRENTDATEHOUR_ENDVAR_1 = "";                // --> Filter current date variable name
      public static const RSS_URL_2_FILTER_NUMITEMS_1 = 0;                               // --> Value 0 => SHOW_ALL_ITEMS
      public static const RSS_URL_2_IS_DIARY = false;
      
      public static const RSS_URL_3 = "URL 3"; 
      public static const RSS_URL_3_TITLE = "Title 3";
      public static const RSS_URL_3_ORDERBY_PUBDATE = true;                              // --> Order by publish date (date + hour)
      public static const RSS_URL_3_FILTER_CURRENTDATEHOUR_STARTVAR_1 = "";              // --> Filter current date variable name
      public static const RSS_URL_3_FILTER_CURRENTDATEHOUR_ENDVAR_1 = "";                // --> Filter current date variable name
      public static const RSS_URL_3_FILTER_NUMITEMS_1 = 0;                               // --> Value 0 => SHOW_ALL_ITEMS
      public static const RSS_URL_3_IS_DIARY = false;
      
      public static const RSS_NUMLAYOUTS_TOCHANGE_RSS = 3;
      
      public static const COMPONENTS_BAR_SHOW: Boolean = false;
      
      public static const LOGO_AJUNTAMENT_SHOW: Boolean = true;
      public static const LOGO_AJUNTAMENT_POSITION_X_PERCENT: Number = 20;  
      public static const LOGO_AJUNTAMENT_POSITION_Y_PERCENT: Number = 92;

      public static const GADGET_CURRENTDATE_SHOW: Boolean = true;
      public static const GADGET_CURRENTDATE_POSITION_X_PERCENT: Number = 44;  
      public static const GADGET_CURRENTDATE_POSITION_Y_PERCENT: Number = 30;
      
      public static const GADGET_RSS_TITLE_SHOW: Boolean = true;
      public static const GADGET_RSS_TITLE_POSITION_X_PERCENT: Number = 44;
      public static const GADGET_RSS_TITLE_POSITION_Y_PERCENT: Number = 23;

      public static const GADGET_RSS_LOGO_SHOW: Boolean = true;
      public static const GADGET_RSS_LOGO_POSITION_X_PERCENT: Number = 85;
      public static const GADGET_RSS_LOGO_POSITION_Y_PERCENT: Number = 10;
      
      public static const GADGET_RSS_SHOW: Boolean = false;
      public static const GADGET_RSS_POSITION_X_PERCENT: Number = 28.5;  
      public static const GADGET_RSS_POSITION_Y_PERCENT: Number = 4.5;
      
      public static const GADGET_CLOCK_SHOW: Boolean = false;
      public static const GADGET_CLOCK_ANIMATION_DOTS: Boolean = false;
      public static const GADGET_CLOCK_ANIMATION_DOTS_DELAY: Number = 5;           // --> Seconds delay
      public static const GADGET_CLOCK_POSITION_X_PERCENT: Number = 92;  
      public static const GADGET_CLOCK_POSITION_Y_PERCENT: Number = 92;
   
      public static const GADGET_CLOCK_CLASSIC_SHOW: Boolean = true;
      public static const GADGET_CLOCK_CLASSIC_ANIMATION_DOTS: Boolean = false;
      public static const GADGET_CLOCK_CLASSIC_ANIMATION_DOTS_DELAY: Number = 5;   // --> Seconds delay
      public static const GADGET_CLOCK_CLASSIC_POSITION_X_PERCENT: Number = 93.5;  
      public static const GADGET_CLOCK_CLASSIC_POSITION_Y_PERCENT: Number = 93;
      
      public static const DEBUG_APPLICATION: Boolean = false;
      
      public static function securityAllowSandboxDomains() {
         Security.allowDomain("*");
         
         Security.loadPolicyFile("http://static.flickr.com/crossdomain.xml");
         Security.loadPolicyFile("http://farm1.static.flickr.com/crossdomain.xml");
         Security.loadPolicyFile("http://farm2.static.flickr.com/crossdomain.xml");
         Security.loadPolicyFile("http://farm3.static.flickr.com/crossdomain.xml");
         Security.loadPolicyFile("http://farm4.static.flickr.com/crossdomain.xml");
         Security.loadPolicyFile("http://farm5.static.flickr.com/crossdomain.xml");
         Security.loadPolicyFile("http://farm6.static.flickr.com/crossdomain.xml");
         Security.loadPolicyFile("http://farm7.static.flickr.com/crossdomain.xml");
         Security.loadPolicyFile("http://farm8.static.flickr.com/crossdomain.xml");
         Security.loadPolicyFile("http://farm9.static.flickr.com/crossdomain.xml");
      }
      
      // --> No change this values !! -------------------
      public static const SCENE_WIDTH_REF: uint = 672;  
      public static const SCENE_HEIGHT_REF: uint = 384;
      // ------------------------------------------------
   }
}