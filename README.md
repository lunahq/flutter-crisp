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

## Required setup - only iOS

You need to setup setup the a key in iOS, as described at [flutter_webview_plugin](https://github.com/fluttercommunity/flutter_webview_plugin#ios).

## How to use

These are the steps to configure and start working with the plugin:

1. Initialize with your website id, you can take it here: https://app.crisp.chat/website/%5BWEBISTE_ID%5D/inbox/
2. Optionally register an user;
3. Set a initial message.

Pretty straightforward:

```
  @override
  void initState() {
    super.initState();

    crisp.initialize('WEBSITE_ID');
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
