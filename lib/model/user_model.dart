import 'package:xmpp_stone/xmpp_stone.dart';

import '../constant.dart';

class UserModel {
  final String username;
  final String host;
  final String password;

  String get userJid => "$username@$host";

  late final Jid jid;

  factory UserModel.fromUsername(String username) =>
      UserModel(username: username, password: "");
  
  UserModel({
    required this.username,
    this.host = domain,
    required this.password,
  }) {
    jid = Jid.fromFullJid("$username@$host");
  }
}
