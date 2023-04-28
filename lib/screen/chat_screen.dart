import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xmpp_flutter_lochandsome/model/user_model.dart';
import 'package:xmpp_flutter_lochandsome/service/app_xmpp.dart';

class ChatScreen extends StatefulWidget {
  final String receiver;

  const ChatScreen({super.key, required this.receiver});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final chatController = TextEditingController();
  late final UserModel receiverUser = UserModel.fromUsername(widget.receiver);

  @override
  void initState() {
    AppXmpp.instance?.queryMessages(jid: receiverUser.jid);
    super.initState();
  }

  sendMessageToReceiver() async {
    AppXmpp.instance?.sendMessage(
        message: chatController.text, receiverJid: receiverUser.jid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.close),
        onPressed: () {
          AppXmpp.instance?.connection.close();
        },
      ),
      appBar: AppBar(
        title: Text(widget.receiver),
      ),
      body: Column(
        children: [
          const Expanded(child: SizedBox()),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 5),
            color: Colors.grey[300],
            child: SafeArea(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      controller: chatController,
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  IconButton(
                      onPressed: () {
                        sendMessageToReceiver();
                      },
                      icon: const Icon(Icons.send))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
