import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:crisp/crisp.dart';

void main() {
  const MethodChannel channel = MethodChannel('crisp');

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
    expect(await Crisp.platformVersion, '42');
  });
}
