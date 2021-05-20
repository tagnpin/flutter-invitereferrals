import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_invitereferrals/flutter_invitereferrals.dart';

void main() {
  const MethodChannel channel = MethodChannel('flutter_invitereferrals');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await FlutterInvitereferrals.platformVersion, '42');
  });
}
