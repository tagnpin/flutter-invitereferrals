package com.flutter.invitereferrals;

import android.app.Activity;
import android.app.Application;
import android.content.Context;

import androidx.annotation.NonNull;

import com.invitereferrals.invitereferrals.IRInterfaces.IRCloseButtonCallbackInterface;
import com.invitereferrals.invitereferrals.IRInterfaces.IRTrackReferrerCode;
import com.invitereferrals.invitereferrals.IRInterfaces.IRTrackingCallback;
import com.invitereferrals.invitereferrals.IRInterfaces.InviteReferralsSharingInterface;
import com.invitereferrals.invitereferrals.IRInterfaces.UserDetailsCallback;
import com.invitereferrals.invitereferrals.InviteReferralsApi;
import com.invitereferrals.invitereferrals.InviteReferralsApplication;

import org.json.JSONObject;

import io.flutter.Log;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/**
 * InviteReferralsPlugin
 */
public class InviteReferralsPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {

    private MethodChannel channel;

    private static final String TAG = "InviteReferrals";
    private static final String PLUGIN_VERSION = "1.0.2";

    private static final String INLINE_BUTTON = "inline_btn";
    private static final String USER_DETAILS = "userDetails";
    private static final String TRACKING = "tracking";
    private static final String INVITE = "invite";
    private static final String WELCOME_MSG = "welcomeMessage";
    private static final String REFERRER_CODE = "getReferrerCode";
    private static final String SET_LANGUAGE = "setLocale";
    private static final String GET_SHARING_DETAILS = "getSharingDetails";
    private static final String HANDEL_DONE_BUTTON = "closeButtonListener";
    private static final String GET_REFERRING_PARAMS = "getReferringParams";
    private static final String GET_LINK_INFO = "getLinkInfo";
    private static final String SHOW_POP_UP = "showPopUp";

    private Context flutterContext;
    private Activity activity;

    public static void register(Context context) {
        Log.i(TAG, "REGISTER !!");
        try {
            InviteReferralsApplication.register((Application) context.getApplicationContext());
        } catch (Exception e) {
            Log.i(TAG, "REGISTER ERROR : " + e.toString());
        }
    }

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        Log.i(TAG, "ON ATTACHED TO ENGINE !!");
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "flutter_invitereferrals");
        channel.setMethodCallHandler(this);
        flutterContext = flutterPluginBinding.getApplicationContext();
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        Log.i(TAG, "ON DETACHED FROM ENGINE !!");
        channel.setMethodCallHandler(null);
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding activityBinding) {
        Log.i(TAG, "ON ATTACHED TO ACTIVITY !!");
        activity = activityBinding.getActivity();
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
        Log.i(TAG, "ON DETACHED FROM ACTIVITY FOR CONFIG CHANGES !!");
    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding activityPluginBinding) {
        Log.i(TAG, "ON REATTACHED TO ACTIVITY FOR CONFIG CHANGES !!");
    }

    @Override
    public void onDetachedFromActivity() {
        Log.i(TAG, "ON DETACHED FROM    ACTIVITY !!");
    }


    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        Log.i(TAG, "ON METHOD CALL !!");
        String action = call.method;
        switch (action) {
            case INLINE_BUTTON:
                sharing_screen(call);
                break;
            case USER_DETAILS:
                user_details(call, result);
                break;
            case TRACKING:
                tracking(call, result);
                break;
            case WELCOME_MSG:
                welcome_msg();
                break;
            case REFERRER_CODE:
                get_referrer_code(result);
                break;
            case SET_LANGUAGE:
                set_language(call);
                break;
            case INVITE:
                invite(call);
                break;
            case GET_SHARING_DETAILS:
                get_sharing_details(call, result);
                break;
            case HANDEL_DONE_BUTTON:
                handleDoneButton(result);
                break;
            case GET_REFERRING_PARAMS:
                getReferringParams(result);
                break;
            case SHOW_POP_UP:
                setShowPopUp(call);
                break;
            case GET_LINK_INFO:
                getLinkInfo();
                break;
            default:
                Log.e(TAG, "Invalid action : " + action);
                result.notImplemented();
        }
    }


    private void sharing_screen(MethodCall fetchData) {
        Log.i(TAG, "SHARING SCREEN !!");
        int campaignId = 0;
        try {
            campaignId = fetchData.argument("campaignId");
        } catch (Exception e) {
            Log.i(TAG, "GET CAMPAIGN ID ERROR : " + e);
            Log.i(TAG, "DEFAULT CAMPAIGN ID 0 IS PASSED !!");
        }

        try {
            InviteReferralsApi.getInstance(flutterContext).inline_btn(campaignId);
        } catch (Exception e) {
            Log.e(TAG, "SHARING SCREEN ERROR :" + e);
        }
    }

    private void user_details(MethodCall fetchData, final Result result) {
        Log.i(TAG, "USER-DETAILS !!");
        String mName = null;
        String mEmail = null;
        String mMobile = null;
        int mCampaign = 0;
        String mSubscriptionId = null;
        String mCustomValue = null;

        try {
            mName = fetchData.argument("name");
        } catch (Exception e) {
            Log.i(TAG, "NAME ERROR :" + e);
        }

        try {
            mEmail = fetchData.argument("email");
        } catch (Exception e) {
            Log.i(TAG, "EMAIL ERROR :" + e);
        }

        try {
            mMobile = fetchData.argument("mobile");
        } catch (Exception e) {
            Log.i(TAG, "MOBILE ERROR :" + e);
        }

        try {
            mCampaign = fetchData.argument("campaignId");
        } catch (Exception e) {
            Log.i(TAG, "CAMPAIGN ID ERROR :" + e);
            Log.i(TAG, "DEFAULT CAMPAIGN-ID 0 IS PASSED !!");
        }

        try {
            mSubscriptionId = fetchData.argument("subscriptionId");
        } catch (Exception e) {
            Log.i(TAG, "SUBSCRIPTION-ID ERROR :" + e);
        }

        try {
            mCustomValue = fetchData.argument("customValues");
        } catch (Exception e) {
            Log.i(TAG, "CUSTOM-VALUES ERROR :" + e);
        }


        try {
            InviteReferralsApi.getInstance(flutterContext).userDetails(mName, mEmail, mMobile, mCampaign, mSubscriptionId, mCustomValue);
        } catch (Exception e) {
            Log.e(TAG, "USER-DETAILS ERROR :" + e);
        }

        try {
            InviteReferralsApi.getInstance(flutterContext).userDetailListener(new UserDetailsCallback() {
                @Override
                public void userDetails(JSONObject response) {
                    result.success(response.toString());
                }
            });
        } catch (Exception e) {
            Log.e(TAG, "USER-DETAILS LISTENER ERROR :" + e);
        }
    }

    private void tracking(MethodCall fetchData, final Result result) {
        Log.i(TAG, "TRACKING !!");
        String trackingName = null;
        String orderIdOrMailId = null;
        int purchaseValue = 0;
        String mValue1 = null;
        String mValue2 = null;

        try {
            trackingName = fetchData.argument("trackingName");
        } catch (Exception e) {
            Log.e(TAG, "TRACKING-NAME ERROR :" + e);
        }

        try {
            orderIdOrMailId = fetchData.argument("orderIdOrMailId");
        } catch (Exception e) {
            Log.e(TAG, "ORDER-ID/MAIL-ID ERROR :" + e);
        }

        try {
            purchaseValue = fetchData.argument("purchaseValue");
        } catch (Exception e) {
            Log.e(TAG, "PURCHASE-VALUE ERROR :" + e);
        }

        try {
            mValue1 = fetchData.argument("referCode");
        } catch (Exception e) {
            Log.e(TAG, "M-VALUE1 ERROR :" + e);
        }

        try {
            mValue2 = fetchData.argument("uniqueCode");
        } catch (Exception e) {
            Log.e(TAG, "M-VALUE2 ERROR :" + e);
        }


        try {
            InviteReferralsApi.getInstance(flutterContext).tracking(trackingName, orderIdOrMailId, purchaseValue, mValue1, mValue2);
        } catch (Exception e) {
            Log.e(TAG, "TRACKING ERROR :" + e);
        }

        try {
            InviteReferralsApi.getInstance(flutterContext).ir_TrackingCallbackListener(new IRTrackingCallback() {
                @Override
                public void ir_trackingCallbackForEventName(JSONObject response) {
                    result.success(response.toString());
                }
            });
        } catch (Exception e) {
            Log.e(TAG, "TRACKING LISTENER ERROR :" + e);
        }

    }

    private void welcome_msg() {
        Log.i(TAG, "WELCOME-MSG !!");
        try {
            InviteReferralsApi.getInstance(flutterContext).showWelcomeMessage();
        } catch (Exception e) {
            Log.e(TAG, "WELCOME_MSG ERROR :" + e);
        }
    }

    private void get_referrer_code(final Result result) {
        Log.i(TAG, "GET-REFERRER-CODE !!");
        try {
            InviteReferralsApi.getInstance(flutterContext).getReferrerCode(new IRTrackReferrerCode() {
                @Override
                public void getReferrerCode(String response) {
                    result.success(response);
                }
            });
        } catch (Exception e) {
            Log.e(TAG, "GET-REFERRER-CODE ERROR :" + e);
        }
    }

    private void set_language(MethodCall fetchData) {
        Log.i(TAG, "SET-LANGUAGE !!");
        String locale = null;
        try {
            locale = fetchData.argument("locale");
        } catch (Exception e) {
            Log.e(TAG, "ERROR :" + e);
        }

        try {
            InviteReferralsApi.getInstance(flutterContext).setLocale(locale);
        } catch (Exception e) {
            Log.e(TAG, "SET-LANGUAGE ERROR :" + e);
        }
    }

    private void invite(MethodCall fetchData) {
        Log.i(TAG, "INVITE !!");
        String customRule = null;
        try {
            customRule = fetchData.argument("rule");
        } catch (Exception e) {
            Log.e(TAG, "ERROR :" + e);
        }

        try {
            if (activity != null)
                InviteReferralsApi.getInstance(activity).invite(customRule);
            else
                Log.i(TAG, "ACTIVITY PARAMETER CAN NOT BE NULL !!");
        } catch (Exception e) {
            Log.e(TAG, "INVITE ERROR :" + e);
        }
    }

    private void get_sharing_details(MethodCall fetchData, final Result result) {
        Log.i(TAG, "GET SHARING DETAILS !!");
        String mName = null;
        String mEmail = null;
        String mMobile = null;
        int mCampaignId = 0;

        try {
            mName = fetchData.argument("name");
        } catch (Exception e) {
            Log.i(TAG, "NAME ERROR :" + e);
        }

        try {
            mEmail = fetchData.argument("email");
        } catch (Exception e) {
            Log.i(TAG, "EMAIL ERROR :" + e);
        }

        try {
            mMobile = fetchData.argument("mobile");
        } catch (Exception e) {
            Log.i(TAG, "MOBILE ERROR :" + e);
        }

        try {
            mCampaignId = fetchData.argument("campaignId");
        } catch (Exception e) {
            Log.i(TAG, "CAMPAIGN ID ERROR :" + e);
            Log.i(TAG, "DEFAULT CAMPAIGN-ID 0 IS PASSED !!");
        }

        try {
            InviteReferralsApi.getInstance(flutterContext).getSharingDetails(new InviteReferralsSharingInterface() {
                @Override
                public void getShareData(JSONObject response) {
                    try {
                        result.success(response.toString());
                    } catch (Exception e) {
                        Log.i(TAG, "RESPONSE ERROR : " + e);
                    }
                }
            }, mName, mEmail, mMobile, mCampaignId);

        } catch (Exception e) {
            Log.e(TAG, "GET SHARING DETAIL LISTENER ERROR :" + e);
        }
    }

    private void handleDoneButton(final Result result) {
        Log.i(TAG, "HANDLE DONE BUTTON !!");
        try {
            InviteReferralsApi.getInstance(flutterContext).closeButtonListener(new IRCloseButtonCallbackInterface() {
                @Override
                public void HandleDoneButtonAction() {
                    channel.invokeMethod("HandleDoneButton", "success");
                    //result.success("success");
                }
            });
        } catch (Exception e) {
            Log.e(TAG, "CLOSE BUTTON LISTENER ERROR :" + e);
        }
    }

    private void getReferringParams(Result result) {
        Log.i(TAG, "GET REFERRING PARAMS !!");
        try {
            String mParams = InviteReferralsApi.getInstance(flutterContext).getReferringParams();
            result.success(mParams);
        } catch (Exception e) {
            Log.e(TAG, "GET REFERRING PARAMS ERROR :" + e);
        }
    }

    private void getLinkInfo() {
        Log.i(TAG, "GET LINK INFO !!");

    }

    private void setShowPopUp(MethodCall fetchData) {
        Log.i(TAG, "SHOW POP-UP !!");
        String popUpType = null;
        int mCampaignId = 0;

        try {
            popUpType = fetchData.argument("popUpType");
        } catch (Exception e) {
            Log.i(TAG, "POP-UP TYPE ERROR :" + e);
        }

        try {
            mCampaignId = fetchData.argument("campaignId");
        } catch (Exception e) {
            Log.i(TAG, "CAMPAIGN ID ERROR :" + e);
            Log.i(TAG, "DEFAULT CAMPAIGN-ID 0 IS PASSED !!");
        }

        try {
            if (activity != null)
                InviteReferralsApi.getInstance(activity).showPopup(popUpType, mCampaignId);
            else
                Log.i(TAG, "ACTIVITY PARAMETER CAN NOT BE NULL !!");
        } catch (Exception e) {
            Log.e(TAG, "SHOW POP-UP ERROR :" + e);
        }

    }

}
