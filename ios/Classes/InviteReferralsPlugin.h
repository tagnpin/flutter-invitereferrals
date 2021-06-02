#import <Flutter/Flutter.h>
#import <InviteReferrals/InviteReferrals.h>

#define TAG @"FLUTTER-INVITEREFERRALS"
#define PLUGIN_VERSION @"1.0.3"
#define INLINE_BUTTON @"inline_btn"
#define USER_DETAILS @"userDetails"
#define TRACKING @"tracking"
#define INVITE @"invite"
#define WELCOME_MSG @"welcomeMessage"
#define REFERRER_CODE @"getReferrerCode"
#define SET_LANGUAGE @"setLocale"
#define GET_SHARING_DETAILS @"getSharingDetails"
#define HANDEL_DONE_BUTTON @"closeButtonListener"
#define GET_REFERRING_PARAMS @"getReferringParams"
#define GET_LINK_INFO @"getLinkInfo"
#define SHOW_POP_UP @"showPopUp"
#define SET_UP_NAVIGATION @"setUpNavigation"


@interface InviteReferralsPlugin : NSObject<FlutterPlugin, InviteReferralsDelegate>

@property (nonatomic, strong)NSString * mName;
@property (nonatomic, strong)NSString * mEmail;
@property (nonatomic, strong)NSString * mMobile;
@property (nonatomic, strong)NSString * mCampaign;
@property (nonatomic, strong)NSString * mSubscriptionId;

@property (strong, nonatomic) FlutterMethodChannel * channel;

+ (instancetype)sharedInstance;

@end
