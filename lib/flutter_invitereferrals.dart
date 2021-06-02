import 'dart:async';

import 'package:flutter/services.dart';

// Handlers for various events
typedef void CloseButtonCallback(String msg);

class Invitereferrals {

  static Invitereferrals shared = new Invitereferrals();

  MethodChannel _channel = const MethodChannel('flutter_invitereferrals');

  // event handlers
  CloseButtonCallback _closeButtonCallback;

  // constructor method
  Invitereferrals() {
    this._channel.setMethodCallHandler(_handleMethod);
  }

  Future<void> campaign(int campaignId) async {
    var campaignInfo = {'campaignId': campaignId};
    await _channel.invokeMethod('inline_btn', campaignInfo);
  }

  Future<String> userDetails(String name, String email, String mobile,
      int campaignId, String subscriptionId, String customValues) async {
    var userInfo = {'name': name,
      'email': email,
      'mobile': mobile,
      'campaignId': campaignId,
      'subscriptionId': subscriptionId,
      'customValues': customValues};
    String response = await _channel.invokeMethod('userDetails', userInfo);
    return response;
  }

  Future<String> tracking(String trackingName, String orderIdOrMailId,
      int purchaseValue, String referCode, String uniqueCode) async {
    var trackingInfo = {'trackingName': trackingName,
      'orderIdOrMailId': orderIdOrMailId,
      'purchaseValue': purchaseValue,
      'referCode': referCode,
      'uniqueCode': uniqueCode};
    String response = await _channel.invokeMethod('tracking', trackingInfo);
    return response;
  }

  Future<void> welcomeMessage() async {
    await _channel.invokeMethod('welcomeMessage');
  }

  Future<String> getReferrerCode() async {
    String response = await _channel.invokeMethod('getReferrerCode');
    return response;
  }

  Future<void> setLocale(String locale) async {
    var localeInfo = {'locale': locale};
    await _channel.invokeMethod('setLocale', localeInfo);
  }

  Future<void> campaignPopup(String customRule) async {
    var inviteInfo = {'rule': customRule};
    await _channel.invokeMethod('invite', inviteInfo);
  }

  Future<String> getSharingDetails(String name, String email,
      String mobile, int campaignId) async {
    var detailsInfo = {
      'name': name,
      'email': email,
      'mobile': mobile,
      'campaignId': campaignId
    };
    String response = await _channel.invokeMethod(
        'getSharingDetails', detailsInfo);
    return response;
  }

  Future<String> getReferringParams() async {
    String response = await _channel.invokeMethod('getReferringParams');
    return response;
  }

  Future<void> closeButtonListener(CloseButtonCallback handler) async {
    _closeButtonCallback = handler;
    await _channel.invokeMethod('closeButtonListener');
  }


  Future<void> showPopUp(String popUpType, int campaignId) async {
    var popupInfo = {'popUpType': popUpType, 'campaignId': campaignId};
    await _channel.invokeMethod('showPopUp', popupInfo);
  }

  Future<void> getLinkInfo() async {
    await _channel.invokeMethod('getLinkInfo');
  }

  Future<void> setUpNavigationIOS(String navigationBarStyle,
      bool preferedStatusBarStyleLightContent,
      bool navigationBarSetTranslucent,
      String navigationBarLoginScreenTitle,
      String navigationBarShareScreenTitle,
      String navigationBarTitleColor,
      String navigationBarBackground,
      String navigationBarButtonPosition,
      String navigationBarButtonTitle,
      String navigationBarTextFontName,
      String navigationBarTitleFontSize,
      String navigationBarButtonFontSize,
      String navigationBarButtonIconWidth,
      String navigationBarButtonIconHeight,
      String navigationBarButtonTintColor,
      String barInActiveCampaignScreenTitle) async {
    var navigationInfo = {
      "navBarStyle": navigationBarStyle,
      "statusBarStyleLightContent": preferedStatusBarStyleLightContent,
      "navBarSetTranslucent": navigationBarSetTranslucent,
      "navBarLoginScreenTitle": navigationBarLoginScreenTitle,
      "navBarShareScreenTitle": navigationBarShareScreenTitle,
      "navBarTitleColor": navigationBarTitleColor,
      "navBarBackground": navigationBarBackground,
      "navBarButtonPosition": navigationBarButtonPosition,
      "navBarButtonTitle": navigationBarButtonTitle,
      "navBarTextFontName": navigationBarTextFontName,
      "navBarTitleFontSize": navigationBarTitleFontSize,
      "navBarButtonFontSize": navigationBarButtonFontSize,
      "navBarButtonIconWidth": navigationBarButtonIconWidth,
      "navBarButtonIconHeight": navigationBarButtonIconHeight,
      "navBarButtonTintColor": navigationBarButtonTintColor,
      "barInActiveCampaignScreenTitle": barInActiveCampaignScreenTitle
    };

    await _channel.invokeMethod('setUpNavigation', navigationInfo);
  }


  // Private function that gets called by ObjC/Java
  Future<Null> _handleMethod(MethodCall call) async {
    if (call.method == "HandleDoneButton") {
      this._closeButtonCallback(call.arguments.toString());
    }
    return null;
  }

}
