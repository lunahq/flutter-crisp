/// Model for chat user data
class CrispUser {
  /// The email of this
  final String email;

  /// The avatar os this
  final String? avatar;

  /// The nickname of this
  final String? nickname;

  /// The phone of this
  final String? phone;

  /// The verification code of this
  final String? verificationCode;

  /// Creates a new instance of chat user to be user in [CrispMain.register]
  CrispUser({
    required this.email,
    this.avatar,
    this.nickname,
    this.phone,
    this.verificationCode,
  });
}
