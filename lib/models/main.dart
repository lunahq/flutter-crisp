import 'dart:collection';

import 'package:crisp/helpers.dart';
import 'package:crisp/models/user.dart';
import 'package:flutter/material.dart';

class _CrispMain {
  String websiteId;
  String locale;
  String userToken;
  Queue commands = Queue<String>();
  CrispUser user;

  void initialize({
    @required String websiteId,
    String locale,
    String userToken,
  }) {
    this.websiteId = websiteId;
    this.locale = locale;
    this.userToken = userToken;
  }

  void register(CrispUser user) {
    execute("window.\$crisp.push([\"set\", \"user:email\", [\"" +
        user.email +
        "\"]])");

    if (notNull(user.nickname))
      execute("window.\$crisp.push([\"set\", \"user:nickname\", [\"" +
          user.nickname +
          "\"]])");

    if (notNull(user.avatar))
      execute("window.\$crisp.push([\"set\", \"user:avatar\", [\"" +
          user.avatar +
          "\"]])");

    if (notNull(user.phone))
      execute("window.\$crisp.push([\"set\", \"user:phone\", [\"" +
          user.phone +
          "\"]])");

    this.user = user;
  }

  setMessage(String text) {
    execute("window.\$crisp.push([\"set\", \"message:text\", [\"$text\"]])");
  }

  void execute(String script) {
    commands.add(script);
  }
}

final crisp = _CrispMain();
