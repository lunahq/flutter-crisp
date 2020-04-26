import 'package:flutter/material.dart';

class CrispUser {
  final String email;
  final String avatar;
  final String nickname;
  final String phone;

  CrispUser({
    @required this.email,
    this.avatar,
    this.nickname,
    this.phone,
  }) : assert(email != null);
}
