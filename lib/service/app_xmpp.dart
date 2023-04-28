import 'package:flutter/foundation.dart';
import 'package:xmpp_flutter_lochandsome/constant.dart';
import 'package:xmpp_flutter_lochandsome/model/user_model.dart';
import 'package:xmpp_stone/xmpp_stone.dart';

class AppXmpp {
  static AppXmpp? instance;
  late final Jid jid;
  late final Connection connection;
  MessageArchiveManager? messageArchiveManager;
  final UserModel user;
  late final MessageHandler messageHandler;

  factory AppXmpp.createConnect(UserModel user) {
    if (instance != null) {
      return instance!;
    }
    instance = AppXmpp(user: user);
    return instance!;
  }

  void onMessageReceive(MessageStanza? message) {
    if (message?.body != null) {
      if (kDebugMode) {
        print(
            'New Message from {color.blue}${message?.fromJid?.userAtDomain}{color.end} message: {color.red}${message?.body}{color.end}');
      }
    }
  }

  queryMessages({Jid? jid}) {
    messageArchiveManager?.queryAll();
  }

  AppXmpp({required this.user}) {
    jid = Jid.fromFullJid(user.userJid);
    final account = XmppAccountSettings(
      user.userJid,
      user.username,
      jid.domain,
      user.password,
      5222,
      resource: 'xmppstone',
      host: "localhost",
    );
    connection = Connection(account);
    connection.connect();
    connection.connectionStateStream.listen(onChangeState);
  }

  void sendMessage({required String message, required Jid receiverJid}) {
    // var receiver = 'user2@localhost';
    messageHandler.sendMessage(receiverJid, message);
  }

  void onChangeState(XmppConnectionState state) {
    if (state == XmppConnectionState.Ready) {
      messageArchiveManager = connection.getMamModule();
      messageHandler = MessageHandler.getInstance(connection);
      messageHandler.messagesStream.listen(onMessageReceive);
    }
  }
}
