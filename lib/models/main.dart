import 'dart:collection';

import 'package:crisp/models/user.dart';

class CrispMain {
  CrispMain({
    required this.websiteId,
    String locale = 'en',
    String? userToken,
    CrispUser? user,
  }) {
    this.locale = locale;
    this.userToken = userToken;
  }

  final String websiteId;
  String locale = 'en';
  String? userToken;
  Queue commands = Queue<String>();
  CrispUser? user;

  void register({required CrispUser user}) {
    if (user.verificationCode != null)
      appendScript("window.\$crisp.push([\"set\", \"user:email\", [\"" +
          user.email +
          "\", \"" +
          user.verificationCode! +
          "\"]])");
    else
      appendScript("window.\$crisp.push([\"set\", \"user:email\", [\"" +
          user.email +
          "\"]])");

    if (user.nickname != null)
      appendScript("window.\$crisp.push([\"set\", \"user:nickname\", [\"" +
          user.nickname! +
          "\"]])");

    if (user.avatar != null)
      appendScript("window.\$crisp.push([\"set\", \"user:avatar\", [\"" +
          user.avatar! +
          "\"]])");

    if (user.phone != null)
      appendScript("window.\$crisp.push([\"set\", \"user:phone\", [\"" +
          user.phone! +
          "\"]])");

    this.user = user;
  }

  setMessage(String text) {
    appendScript(
        "window.\$crisp.push([\"set\", \"message:text\", [\"$text\"]])");
  }

  void appendScript(String script) {
    commands.add(script);
  }
}
