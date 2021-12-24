# Flutter Crisp

<p>
  <a href="https://pub.dartlang.org/packages/crisp">
    <img src="https://img.shields.io/pub/v/crisp.svg" alt="pub package" height="18">
  </a>
  <a href="#" target="_blank">
    <img alt="License: MIT" src="https://img.shields.io/badge/License-MIT-yellow.svg" />
  </a>
  <a href="https://twitter.com/oilunabr" target="_blank">
    <img alt="Twitter: oilunabr" src="https://img.shields.io/twitter/follow/oilunabr.svg?style=social" />
  </a>
</p>

Connect with Crisp Chat, register a user to chat (or not) and render a chat widget.

Tested on Android and iOS.

## Required setup

Min SDK version:

`minSdkVersion 17`

`AndroidManifest.xml` necessary changes:

```android
    <application
        android:usesCleartextTraffic="true">
        ...
        <meta-data
            android:name="flutterEmbedding"
            android:value="2" />
        <provider
            android:name="com.pichillilorenzo.flutter_inappwebview.InAppWebViewFileProvider"
            android:authorities="${applicationId}.flutter_inappwebview.fileprovider"
            android:exported="false"
            android:grantUriPermissions="true">
            <meta-data
                android:name="android.support.FILE_PROVIDER_PATHS"
                android:resource="@xml/provider_paths" />
        </provider>
    </application>
```

For details check the example folder.

## How to use

Initialize with:

- Your website id (https://app.crisp.chat/website/%5BWEBISTE_ID%5D/inbox/);
- An optional locale.

```dart
  CrispMain crispMain;

  @override
  void initState() {
    super.initState();

    crispMain = CrispMain(
      websiteId: 'WEBSITE_ID',
      locale: 'pt-br',
    );

    crispMain.register(
      user: CrispUser(
        email: "example@provider.com",
        avatar: 'https://avatars2.githubusercontent.com/u/16270189?s=200&v=4',
        nickname: "João Cardoso",
        phone: "5511987654321",
      ),
    );

    crispMain.setMessage("Hello world");

    crispMain.setSessionData({
      "order_id": "111",
      "app_version": "0.1.1",
    });
  }
```

Then use with:

- Optional clear cache.

```dart
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Your brand'),
        ),
        body: CrispView(
          crispMain: crispMain,
          clearCache: false,
        ),
      ),
    );
  }
```

## Additional parameters

Chat user token with `userToken`

```dart
crispMain.initialize(
  websiteId: 'WEBSITE_ID',
  locale: 'pt-br',
  userToken: '<USERTOKENHERE>',
);
```

Verification token with `verificationCode` ([User Verification](https://help.crisp.chat/en/article/how-to-verify-user-identity-with-cryptographic-email-signatures-166sl01/))

```dart
crispMain.register(
  user: CrispUser(
    email: "example@provider.com",
    avatar: 'https://avatars2.githubusercontent.com/u/16270189?s=200&v=4',
    nickname: "João Cardoso",
    phone: "5511987654321",
    verificationCode: "<HMAC256CODEHERE>",
  ),
);
```

Custom data via `setSessionData` ([Set custom data](https://help.crisp.chat/en/article/how-can-i-automatically-set-custom-data-1xh7pqk/))

```dart
crispMain.setSessionData({
  "order_id": "111",
  "app_version": "0.1.1",
});
```

Custom `onLinkPressed` event

```dart
CrispView(
  crispMain: crispMain,
  clearCache: true,
  onLinkPressed: (url) {
    if (url.contains('example.com')) {
      loadDeeplinkWithUrl(url: url);
    } else
      launch(url);
  },
),
```
