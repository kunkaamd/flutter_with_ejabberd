import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xmpp_flutter_lochandsome/screen/chat_screen.dart';
import 'package:xmpp_flutter_lochandsome/service/app_xmpp.dart';
import 'package:xmpp_flutter_lochandsome/utils.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final AppXmpp appXmpp = AppXmpp.instance!;
  List<String> users = [];

  List<String> parseUsers(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<String>();
    return parsed;
  }

  void getUsers() async {
    try {
      String username = "${appXmpp.user.username}@${appXmpp.user.host}";
      String password = appXmpp.user.password;
      String basicAuth =
          'Basic ${base64.encode(utf8.encode('$username:$password'))}';
      final response = await http.get(
        Uri.parse(
          'https://localhost:5443/api/registered_users?host=${appXmpp.user.host}',
        ),
        headers: <String, String>{'authorization': basicAuth},
      );

      setState(() {
        users = parseUsers(response.body);
      });
    } catch (error) {
      Utils.showAlert(context, title: "Error", description: error.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Users"),
      ),
      body: ListView.builder(
        itemCount: users.length,
        padding: const EdgeInsets.only(top: 45),
        itemBuilder: (context, index) {
          return TextButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => ChatScreen(receiver: users[index])),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              child: Text(
                users[index],
                style: const TextStyle(fontSize: 18),
              ),
            ),
          );
        },
      ),
    );
  }
}
