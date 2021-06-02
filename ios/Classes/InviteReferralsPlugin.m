#import "InviteReferralsPlugin.h"

BOOL wasDelegateSet = NO;

FlutterResult trackingResult;

@implementation InviteReferralsPlugin


+ (instancetype)sharedInstance {
    static InviteReferralsPlugin *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [InviteReferralsPlugin new];
    });
    return sharedInstance;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    NSLog(@"%@ REGISTER WITH REGISTRAR !!", TAG);
    NSLog(@"FLUTTER INVITEREFERRALS PLUGIN_VERSION : %@ !!", PLUGIN_VERSION);
    InviteReferralsPlugin.sharedInstance.channel  = [FlutterMethodChannel
                                                     methodChannelWithName:@"flutter_invitereferrals"
                                                     binaryMessenger:[registrar messenger]];
    //InviteReferralsPlugin* instance = [[InviteReferralsPlugin alloc] init];
    [registrar addMethodCallDelegate:InviteReferralsPlugin.sharedInstance channel:InviteReferralsPlugin.sharedInstance.channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([INLINE_BUTTON isEqualToString:call.method]) {
        [self inline_btn:call withResult:result];
    } else if([USER_DETAILS isEqualToString:call.method]){
        [self userDetails:call withResult:result];
    } else if([TRACKING isEqualToString:call.method]){
        [self tracking:call withResult:result];
    } else if([INVITE isEqualToString:call.method]){
        [self invite:call withResult: result];
    } else if([WELCOME_MSG isEqualToString:call.method]){
        [self welcomeMessage:call withResult:result];
    } else if([REFERRER_CODE isEqualToString:call.method]){
        [self getReferrerCode:call withResult:result];
    } else if([SET_LANGUAGE isEqualToString:call.method]){
        [self setLocale:call withResult:result];
    } else if([GET_SHARING_DETAILS isEqualToString:call.method]){
        [self getSharingDetails:call withResult:result];
    } else if([HANDEL_DONE_BUTTON isEqualToString:call.method]){
        [self closeButtonListener:call withResult:result];
    } else if([GET_REFERRING_PARAMS isEqualToString:call.method]){
        [self getReferringParams:call withResult:result];
    } else if([GET_LINK_INFO isEqualToString:call.method]){
        [self getLinkInfo:call withResult:result];
    } else if([SHOW_POP_UP isEqualToString:call.method]){
        [self showPopUp:call withResult:result];
    } else if([SET_UP_NAVIGATION isEqualToString:call.method]){
        [self setUpNavigation:call withResult:result];
    } else {
        result(FlutterMethodNotImplemented);
    }
}

/* campaign page */
- (void) inline_btn:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSLog(@"FLUTTER INVITEREFERRALS : INILINE BUTTON !!!");
    NSString* campaignId = @"0";
    
    @try{
        if([NSNull null] != call.arguments[@"campaignId"]) {
            int tmp = [call.arguments[@"campaignId"] intValue];
            campaignId = [NSString stringWithFormat:@"%d", tmp];
        } else{
            NSLog(@"%@ : DEFAULT CAMPAIGN ID 0 IS PASSED !!", TAG);
            campaignId = @"0";
        }
        
    } @catch(NSException *exception){
        NSLog(@"CAMPAIGN ID ERROR : %@", exception.reason);
        NSLog(@"%@ : DEFAULT CAMPAIGN ID 0 IS PASSED !!", TAG);
    }
    
    @try{
        [InviteReferrals launch: campaignId Email: nil mobile: nil name: nil SubscriptionID: nil];
    }
    @catch(NSException *exception){
        NSLog(@"USER DETAILS ERROR : %@", exception.reason);
    }
    
}

/* set details of user */
- (void) userDetails:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSLog(@"%@ : USER DETAILS !!", TAG);
    
    NSString * mCustomValue = nil;
    
    @try{
        self.mName= call.arguments[@"name"];
        if (self.mName == (id)[NSNull null] || self.mName.length == 0 ){
            self.mName  = nil;
        }
    }
    @catch(NSException *exception){
        NSLog(@"NAME ERROR : %@", exception.reason);
    }
    
    @try{
        self.mEmail = call.arguments[@"email"];
        if (self.mEmail == (id)[NSNull null] || self.mEmail.length == 0 ){
            self.mEmail  = nil;
        }
    }
    @catch(NSException *exception){
        NSLog(@"EMAIL ERROR : %@", exception.reason);
    }
    
    @try{
        self.mMobile = call.arguments[@"mobile"];
        if (self.mMobile == (id)[NSNull null] || self.mMobile.length == 0 ){
            self.mMobile  = nil;
        }
    }
    @catch(NSException *exception){
        NSLog(@"MOBILE ERROR : %@", exception.reason);
    }
    
    @try{
        if([NSNull null] != call.arguments[@"campaignId"]) {
            int tmp = [call.arguments[@"campaignId"] intValue];
            self.mCampaign = [NSString stringWithFormat:@"%d", tmp];
        } else{
            self.mCampaign = @"0";
        }
    }
    @catch(NSException *exception){
        NSLog(@"CAMPAIGN ID ERROR : %@", exception.reason);
        NSLog(@"%@ : DEFAULT CAMPAIGN ID 0 IS PASSED !!", TAG);
        self.mCampaign = @"0";
    }
    
    @try{
        self.mSubscriptionId = call.arguments[@"subscriptionId"];
        if (self.mSubscriptionId == (id)[NSNull null] || self.mSubscriptionId.length == 0 ){
            self.mSubscriptionId  = nil;
        }
        
    }
    @catch(NSException *exception){
        NSLog(@"SUBSCRIPTION ID ERROR : %@", exception.reason);
    }
    
    @try{
        mCustomValue = call.arguments[@"customValues"];
        if (mCustomValue == (id)[NSNull null] || mCustomValue.length == 0 ){
            mCustomValue  = nil;
        }
    }
    @catch(NSException *exception){
        NSLog(@"USER DETAILS ERROR : %@", exception.reason);
    }
    
    @try{
        [InviteReferrals GetShareDataWithCampaignID: self.mCampaign Email: self.mEmail mobile: self.mMobile name: self.mName SubscriptionID: self.mSubscriptionId ShowErrorAlerts: YES ShowActivityIndicatorViewWhileLoading: NO SharingDetails:^(NSMutableDictionary *irDetails) {
            result(@"success");
        }];
    }
    @catch(NSException *exception){
        NSLog(@"USER DETAILS ERROR : %@", exception.reason);
    }
}

/* Track your events */
- (void) tracking:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSLog(@"%@ : TRACKING !!", TAG);
    trackingResult = result;
    
    NSString * trackingName;
    NSString * orderIdOrMailId;
    NSString * purchaseValue;
    NSString * referCode;
    NSString * uniqueCode;
    
    @try{
        trackingName = call.arguments[@"trackingName"];
        if (trackingName == (id)[NSNull null] || trackingName.length == 0 ){
            trackingName = nil;
        }
    }
    @catch(NSException *exception){
        NSLog(@"NAME ERROR : %@", exception.reason);
    }
    
    @try{
        orderIdOrMailId = call.arguments[@"orderIdOrMailId"];
        if (orderIdOrMailId == (id)[NSNull null] || orderIdOrMailId.length == 0 ){
            orderIdOrMailId = nil;
        }
    }
    @catch(NSException *exception){
        NSLog(@"ORDER-ID/MAIL-ID ERROR : %@", exception.reason);
    }
    
    @try{
        if([NSNull null] != call.arguments[@"purchaseValue"]) {
            int tmp = [call.arguments[@"purchaseValue"] intValue];
            purchaseValue = [NSString stringWithFormat:@"%d", tmp];
        }
    }
    @catch(NSException *exception){
        NSLog(@"PURCHASE VALUE ERROR : %@", exception.reason);
    }
    
    @try{
        referCode = call.arguments[@"referCode"];
        if (referCode == (id)[NSNull null] || referCode.length == 0 ){
            referCode = nil;
        }
    }
    @catch(NSException *exception){
        NSLog(@"REFER CODE ERROR : %@", exception.reason);
    }
    
    @try{
        uniqueCode = call.arguments[@"uniqueCode"];
        if (uniqueCode == (id)[NSNull null] || uniqueCode.length == 0 ){
            uniqueCode = nil;
        }
    }
    @catch(NSException *exception){
        NSLog(@"UNIQUE CODE ERROR : %@", exception.reason);
    }
    
    @try{
        [self setIRDelegate];
        [InviteReferrals tracking: trackingName orderID: orderIdOrMailId purchaseValue: purchaseValue email: self.mEmail mobile: self.mMobile name: self.mName referCode: referCode uniqueCode: uniqueCode isDebugMode: NO ComplitionHandler:^(NSMutableDictionary *irTrackingResponse) {
            
            NSError * irErr;
            NSData * irResponse = [NSJSONSerialization dataWithJSONObject: irTrackingResponse options: 0 error: &irErr];
            NSString * irResponseStr = [[NSString alloc] initWithData: irResponse encoding: NSUTF8StringEncoding];
            result(irResponseStr);
            
        }];
    }
    @catch(NSException *exception){
        NSLog(@"TRACKING ERROR : %@", exception.reason);
    }
    
}

/* Invite */
- (void) invite:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSLog(@"%@ : INVITE !!", TAG);
    NSString * mRule;
    
    @try{
        mRule = call.arguments[@"rule"];
        if (mRule == (id)[NSNull null] || mRule.length == 0 ){
            mRule = nil;
        }
    }
    @catch(NSException *exception){
        NSLog(@"RULE ERROR : %@", exception.reason);
    }
    
    @try{
        [InviteReferrals showSharePopup: mRule Email: nil mobile: nil name: nil SubscriptionID: nil];
    }
    @catch(NSException *exception){
        NSLog(@"INVITE ERROR : %@", exception.reason);
    }
}

/* Show welcome msg*/
- (void) welcomeMessage:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSLog(@"%@ : WELCOME MESSAGE !!", TAG);
    @try{
        [InviteReferrals welcomeMessage];
    }
    @catch(NSException *exception){
        NSLog(@"WELCOME MESSAGE ERROR : %@", exception.reason);
    }
}

/* Get Referrer Code*/
- (void) getReferrerCode:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSLog(@"%@ : GET REFERRER CODE !!", TAG);
    @try{
        [InviteReferrals getReferrerCode:^(NSString * referrerCode) {
            if([referrerCode length] > 0 ){
                result(referrerCode);
            }else{
                result(@"null");
            }
        }];
    }
    @catch(NSException *exception){
        NSLog(@"GET REFERRER CODE ERROR : %@", exception.reason);
    }
}

/* Set App Language if Awailable*/
- (void) setLocale:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSLog(@"%@ : SET LANGUAGE !!", TAG);
    NSString * languageCode = nil;
    
    @try{
        languageCode = call.arguments[@"locale"];
        if (languageCode == (id)[NSNull null] || languageCode.length == 0 ){
            languageCode = nil;
        }
    }
    @catch(NSException *exception){
        NSLog(@"LANGUAGE CODE ERROR : %@", exception.reason);
    }
    
    @try{
        [InviteReferrals setLocalizationLanguage:languageCode];
    }
    @catch(NSException *exception){
        NSLog(@"SET LANGUAGE ERROR : %@", exception.reason);
    }
}

- (void) getSharingDetails:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSLog(@"%@ : GET SHARING DETAILS !!", TAG);
    @try{
        [InviteReferrals GetShareDataWithCampaignID: self.mCampaign Email: self.mEmail mobile: self.mMobile name: self.mName SubscriptionID: self.mSubscriptionId ShowErrorAlerts: YES ShowActivityIndicatorViewWhileLoading: NO SharingDetails:^(NSMutableDictionary *irDetails) {
            
            NSError * irErr;
            NSData * irResponse = [NSJSONSerialization dataWithJSONObject: irDetails options: 0 error: &irErr];
            NSString * irResponseStr = [[NSString alloc] initWithData: irResponse encoding: NSUTF8StringEncoding];
            result(irResponseStr);
            
        }];
    }
    @catch(NSException *exception){
        NSLog(@"GET SHARING DETAILS ERROR : %@", exception.reason);
    }
}

/* Close Button Callback */
- (void) closeButtonListener:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSLog(@"%@ : CLOSE BUTTON LISTENER !!", TAG);
    @try{
        [self setIRDelegate];
    }
    @catch(NSException *exception){
        NSLog(@"CLOSE BUTTON LISTENER ERROR : %@", exception.reason);
    }
}


/* Get Referring Params */
- (void) getReferringParams:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSLog(@"%@ : GET REFERRING PARAMS !!", TAG);
    @try{
        [InviteReferrals getReferringParams:^(NSDictionary * irRefParams) {
            if([irRefParams count] > 0 ){
                NSError * irErr;
                NSData * irResponse = [NSJSONSerialization dataWithJSONObject: irRefParams options: 0 error: &irErr];
                NSString * irResponseStr = [[NSString alloc] initWithData: irResponse encoding: NSUTF8StringEncoding];
                result(irResponseStr);
            } else{
                result(@"null");
            }
        }];
    }
    @catch(NSException *exception){
        NSLog(@"GET REFERRING PARAMS ERROR : %@", exception.reason);
    }
}

/* get Link Info */
- (void) getLinkInfo:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSLog(@"%@ : GET LINK INFO !!", TAG);
    @try{
        
    }
    @catch(NSException *exception){
        NSLog(@"GET LINK INFO ERROR : %@", exception.reason);
    }
}


/* Not Awailable in ios */
- (void) showPopUp:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSLog(@"%@ : SHOW POP UP !!", TAG);
    @try{
        
    }
    @catch(NSException *exception){
        NSLog(@"SHOW POP UP ERROR : %@", exception.reason);
    }
}


/* Set Up Navigation Controller */
- (void) setUpNavigation:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSLog(@"%@ : SET UP NAVIGATION CONTROLLER !!", TAG);
    
    NSString *irNavBarStyleName;
    BOOL irNavCustomStatusBarStyleLightContent = NO;
    BOOL irNavSetBarTranslucent = YES;
    NSString *irNavBarLoginScreenTitle;
    NSString *irNavBarShareScreenTitle;
    NSString *irNavBarTitleColor;
    NSString *irNavBarBackground;
    NSString *irNavBarButtonPosition;
    NSString *irNavBarButtonTitle;
    NSString *irNavBarTextFontName;
    float irNavBarTitleFontSize;
    float irNavBarButtonFontSize;
    float irNavBarButtonIconWidth;
    float irNavBarButtonIconHeight;
    NSString *irNavBarButtonTintColor;
    NSString *barInActiveCampaignScreenTitle;
    
    UIBarStyle irNavBarStyle =  UIBarStyleDefault;
    
    @try{
        irNavBarStyleName = call.arguments[@"navBarStyle"];
        if (irNavBarStyleName == (id)[NSNull null] || irNavBarStyleName.length == 0 ){
            irNavBarStyleName = nil;
        } else{
            if ([irNavBarStyleName length] > 0 && ![irNavBarStyleName isEqualToString: @""] && ![irNavBarStyleName isEqual: [NSNull null]]) {
                if ([irNavBarStyleName isEqualToString: @"black"]) {
                    irNavBarStyle =  UIBarStyleBlack;
                } else {
                    irNavBarStyle =  UIBarStyleDefault;
                }
            } else {
                irNavBarStyle =  UIBarStyleDefault;
            }
        }
    }
    @catch(NSException *exception){
        NSLog(@"NAV-BAR-STYLE NAME ERROR : %@", exception.reason);
    }
    
    @try{
        irNavCustomStatusBarStyleLightContent = call.arguments[@"statusBarStyleLightContent"];
    }
    @catch(NSException *exception){
        NSLog(@"NAV-CUSTOM-STATUS-BAR-STYLE-LIGHT-CONTENT ERROR : %@", exception.reason);
    }
    
    @try{
        irNavSetBarTranslucent = call.arguments[@"navBarSetTranslucent"];
    }
    @catch(NSException *exception){
        NSLog(@"NAV-SET-BAR-TRANSLUCENT ERROR : %@", exception.reason);
    }
    
    @try{
        irNavBarLoginScreenTitle = call.arguments[@"navBarLoginScreenTitle"];
        if (irNavBarLoginScreenTitle == (id)[NSNull null] || irNavBarLoginScreenTitle.length == 0 ){
            irNavBarLoginScreenTitle = nil;
        }
        
    }
    @catch(NSException *exception){
        NSLog(@"NAV-BAR-LOGIN-SCREEN-TITLE ERROR : %@", exception.reason);
    }
    
    @try{
        irNavBarShareScreenTitle = call.arguments[@"navBarShareScreenTitle"];
        if (irNavBarShareScreenTitle == (id)[NSNull null] || irNavBarShareScreenTitle.length == 0 ){
            irNavBarShareScreenTitle = nil;
        }
    }
    @catch(NSException *exception){
        NSLog(@"NAV-BAR-SHARE-SCREEN-TITLE ERROR : %@", exception.reason);
    }
    
    @try{
        irNavBarTitleColor = call.arguments[@"navBarTitleColor"];
        if (irNavBarTitleColor == (id)[NSNull null] || irNavBarTitleColor.length == 0 ){
            irNavBarTitleColor = nil;
        }
    }
    @catch(NSException *exception){
        NSLog(@"NAV-BAR-TITLE-COLOR ERROR : %@", exception.reason);
    }
    
    @try{
        irNavBarBackground = call.arguments[@"navBarBackground"];
        if (irNavBarBackground == (id)[NSNull null] || irNavBarBackground.length == 0 ){
            irNavBarBackground = nil;
        }
    }
    @catch(NSException *exception){
        NSLog(@"NAV-BAR-BACKGROUND ERROR : %@", exception.reason);
    }
    
    @try{
        irNavBarButtonPosition = call.arguments[@"navBarButtonPosition"];
        if (irNavBarButtonPosition == (id)[NSNull null] || irNavBarButtonPosition.length == 0 ){
            irNavBarButtonPosition = nil;
        }
    }
    @catch(NSException *exception){
        NSLog(@"NAV-BAR-BUTTON-POSITION ERROR : %@", exception.reason);
    }
    
    @try{
        irNavBarButtonTitle = call.arguments[@"navBarButtonTitle"];
        if (irNavBarButtonTitle == (id)[NSNull null] || irNavBarButtonTitle.length == 0 ){
            irNavBarButtonTitle = nil;
        }
    }
    @catch(NSException *exception){
        NSLog(@"NAV-BAR-BUTTON-TITLE ERROR : %@", exception.reason);
    }
    
    @try{
        irNavBarTextFontName = call.arguments[@"navBarTextFontName"];
        if (irNavBarTextFontName == (id)[NSNull null] || irNavBarTextFontName.length == 0 ){
            irNavBarTextFontName = nil;
        }
    }
    @catch(NSException *exception){
        NSLog(@"NAV-BAR-TEXT-FONT-NAME ERROR : %@", exception.reason);
    }
    
    @try{
        NSString * tmp = call.arguments[@"navBarTitleFontSize"];
        if (tmp == (id)[NSNull null] || tmp.length == 0 ){
            irNavBarTitleFontSize = 0;
        } else{
            irNavBarTitleFontSize = [tmp floatValue];
        }
        
    }
    @catch(NSException *exception){
        NSLog(@"NAV-BAR-TITLE-FONT-SIZE ERROR : %@", exception.reason);
    }
    
    @try{
        NSString * tmp = call.arguments[@"navBarButtonFontSize"];
        if (tmp == (id)[NSNull null] || tmp.length == 0 ){
            irNavBarButtonFontSize = 0;
        } else{
            irNavBarButtonFontSize = [tmp floatValue];
        }
        
    }
    @catch(NSException *exception){
        NSLog(@"NAV-BAR-BUTTON-FONT-SIZE ERROR : %@", exception.reason);
    }
    
    @try{
        NSString * tmp = call.arguments[@"navBarButtonIconWidth"];
        if (tmp == (id)[NSNull null] || tmp.length == 0 ){
            irNavBarButtonIconWidth = 0;
        } else{
            irNavBarButtonIconWidth = [tmp floatValue];
        }
    }
    @catch(NSException *exception){
        NSLog(@"NAV-BAR-BUTTON-ICON-WIDTH ERROR : %@", exception.reason);
    }
    
    @try{
        NSString * tmp = call.arguments[@"navBarButtonIconHeight"];
        if (tmp == (id)[NSNull null] || tmp.length == 0 ){
            irNavBarButtonIconHeight = 0;
        } else{
            irNavBarButtonIconHeight = [tmp floatValue];
        }
        
    }
    @catch(NSException *exception){
        NSLog(@"NAV-BAR-BUTTON-ICON-HEIGHT ERROR : %@", exception.reason);
    }
    
    @try{
        irNavBarButtonTintColor = call.arguments[@"navBarButtonTintColor"];
        if (irNavBarButtonTintColor == (id)[NSNull null] || irNavBarButtonTintColor.length == 0 ){
            irNavBarButtonTintColor = nil;
        }
    }
    @catch(NSException *exception){
        NSLog(@"NAV-BAR-BUTTON-TINT-COLOR ERROR : %@", exception.reason);
    }
    
    @try{
        barInActiveCampaignScreenTitle = call.arguments[@"barInActiveCampaignScreenTitle"];
        if (barInActiveCampaignScreenTitle == (id)[NSNull null] || barInActiveCampaignScreenTitle.length == 0 ){
            barInActiveCampaignScreenTitle = nil;
        }
    }
    @catch(NSException *exception){
        NSLog(@"INACTIVE-CAMPAIGN-SCREEN-TITLE ERROR : %@", exception.reason);
    }
    
    
    @try{
        [InviteReferrals setDefaultNavigationController:nil BarStyle:irNavBarStyle PreferedStatusBarStyleLightContent:irNavCustomStatusBarStyleLightContent BarSetTranslucent:irNavSetBarTranslucent BarLoginScreenTitle:irNavBarLoginScreenTitle BarShareScreenTitle:irNavBarShareScreenTitle BarInActiveCampaignScreenTitle:barInActiveCampaignScreenTitle BarTitleTextAttributes:nil BarTitleColor:irNavBarTitleColor BarBackground:irNavBarBackground BarButtonPosition:irNavBarButtonPosition BarButtonTitle:irNavBarButtonTitle BarTextFontName:irNavBarTextFontName BarTitleFontSize:irNavBarTitleFontSize BarButtonTextAttributes:nil BarButtonFontSize:irNavBarButtonFontSize BarButtonIconWidth:irNavBarButtonIconWidth BarButtonIconHeight:irNavBarButtonIconHeight BarButtonTintColor:irNavBarButtonTintColor];
    }
    @catch(NSException *exception){
        NSLog(@"SET-UP-NAVIGATION ERROR : %@", exception.reason);
    }
}



/* Close Button callback event */
-(void)HandleDoneButtonActionWithUserInfo:(NSMutableDictionary *)userInfo{
    @try {
        NSLog(@"CLOSE BUTTON LISTENER !!");
        [self.channel invokeMethod:@"HandleDoneButton" arguments:@"success"];
    }@catch(NSException *exception){
        NSLog(@"%@", exception.reason);
    }
}


/* tracking callback event */
-(void)InviteReferralsTrackingFinishedforEventname:(NSString *)eventName withResponse:(NSMutableDictionary *)trackingResponse{
    @try {
        NSLog(@"INVITEREFERRS TRACKING FINISHED FOR EVENT NAME  !!");
        NSError * irErr;
        NSData * irResponseJsonData = [NSJSONSerialization dataWithJSONObject: trackingResponse options: 0 error: &irErr];
        NSString * irResponseStr = [[NSString alloc] initWithData: irResponseJsonData encoding: NSUTF8StringEncoding];
        trackingResult(irResponseStr);
    }@catch(NSException *exception){
        NSLog(@"%@", exception.reason);
    }
}

/* set Inviteferrals Delegate */
-(void)setIRDelegate{
    @try {
        NSLog(@"SET IR DELEGATE!!");
        if(!wasDelegateSet){
            [InviteReferrals sharedInstance].delegate = self;
            wasDelegateSet = YES;
        } else{
            NSLog(@"IR DELEGATE ALLREADY SET !!");
        }
    }@catch(NSException *exception){
        NSLog(@"%@", exception.reason);
    }
    
}


@end


//NSLog(@"name =  %@",self.mName);
//NSLog(@"campaign =  %@",self.mCampaign);
//NSLog(@"email  =  %@",self.mEmail);
//NSLog(@"mobile =  %@",self.mMobile);
//NSLog(@"sub id =  %@",self.mSubscriptionId);
