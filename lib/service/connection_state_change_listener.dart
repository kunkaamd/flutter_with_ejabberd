import 'dart:async';
import 'dart:io';
import 'package:image/image.dart' as image;

import 'package:xmpp_stone/xmpp_stone.dart';
const TAG = "xmpp_log:";

class AppConnectionStateChangedListener implements ConnectionStateChangedListener {
  late Connection? _connection;
  late MessagesListener? _messagesListener;

  late StreamSubscription<String>? subscription;

  AppConnectionStateChangedListener(Connection connection, MessagesListener messagesListener) {
    _connection = connection;
    _messagesListener = messagesListener;
    _connection?.connectionStateStream.listen(onConnectionStateChanged);
  }

  @override
  void onConnectionStateChanged(XmppConnectionState state) {
    if (state == XmppConnectionState.Ready) {
      Log.d(TAG, 'Connected');
      var vCardManager = VCardManager(_connection!);
      vCardManager.getSelfVCard().then((vCard) {
        if (vCard != null) {
          Log.d(TAG, 'Your info${vCard.buildXmlString()}');
        }
      });
      var messageHandler = MessageHandler.getInstance(_connection!);
      var rosterManager = RosterManager.getInstance(_connection!);
      messageHandler.messagesStream.listen(_messagesListener?.onNewMessage);
      sleep(const Duration(seconds: 1));
      var receiver = 'nemanja2@test';
      var receiverJid = Jid.fromFullJid(receiver);
      rosterManager.addRosterItem(Buddy(receiverJid)).then((result) {
        if (result.description != null) {
          Log.d(TAG, 'add roster${result.description}');
        }
      });
      sleep(const Duration(seconds: 1));
      vCardManager.getVCardFor(receiverJid).then((vCard) {
        Log.d(TAG, 'Receiver info${vCard.buildXmlString()}');
        if (vCard.image != null) {
          var file = File('test456789.jpg')..writeAsBytesSync(image.encodeJpg(vCard.image!));
          Log.d(TAG, 'IMAGE SAVED TO: ${file.path}');
        }
      });
      var presenceManager = PresenceManager.getInstance(_connection!);
      presenceManager.presenceStream.listen(onPresence);
    }
  }

  void onPresence(PresenceData event) {
    Log.d(TAG, 'presence Event from ${event.jid?.fullJid} PRESENCE: ${event.showElement}');
  }
}
