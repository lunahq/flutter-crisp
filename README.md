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

## Required setup for iOS

You need to setup setup the a key in iOS, as described at [flutter_webview_plugin](https://github.com/fluttercommunity/flutter_webview_plugin#ios).

## How to use

Initialize with:

- Your website id (https://app.crisp.chat/website/%5BWEBISTE_ID%5D/inbox/);
- An optional locale.

```dart
crisp.initialize(
  websiteId: 'WEBSITE_ID',
  locale: 'pt-br',
);
```

Optionally register an user

```dart
crisp.register(
  CrispUser(
    email: "example@provider.com",
    avatar: 'https://avatars2.githubusercontent.com/u/16270189?s=200&v=4',
    nickname: "João Cardoso",
    phone: "5511987654321",
  ),
);
```

Set a initial message

```dart
crisp.setMessage("Hello world - initial message");
```

Pretty straightforward:

```dart
  @override
  void initState() {
    super.initState();

    crisp.initialize(
      websiteId: 'WEBSITE_ID',
      locale: 'pt-br',
    );

    crisp.register(
      CrispUser(
        email: "example@provider.com",
        avatar: 'https://avatars2.githubusercontent.com/u/16270189?s=200&v=4',
        nickname: "João Cardoso",
        phone: "5511987654321",
      ),
    );

    crisp.setMessage("Hello world - initial message");
  }
```
