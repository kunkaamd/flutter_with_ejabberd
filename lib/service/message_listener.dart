import 'package:flutter/foundation.dart';
import 'package:xmpp_stone/xmpp_stone.dart';

class AppMessageListener implements MessagesListener{
  @override
  void onNewMessage(MessageStanza? message) {
    print("afaiwhfuahwfhwaihf");
    if (message?.body != null) {
      if (kDebugMode) {
        print('New Message from {color.blue}${message?.fromJid?.userAtDomain}{color.end} message: {color.red}${message?.body}{color.end}');
      }
    }
  }
}