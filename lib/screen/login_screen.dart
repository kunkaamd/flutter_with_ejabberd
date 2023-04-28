import 'package:flutter/material.dart';
import 'package:xmpp_flutter_lochandsome/screen/users_screen.dart';
import 'package:xmpp_flutter_lochandsome/service/app_xmpp.dart';
import 'package:xmpp_flutter_lochandsome/model/user_model.dart';

import '../utils.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> _login() async {
    try {
      final user = UserModel(username: usernameController.text, password: passwordController.text);
      final xmpp = AppXmpp.createConnect(user);
      goToUserScreen();
    } catch (error) {
      Utils.showAlert(context, title: "Error", description: error.toString());
    }
  }

  void goToUserScreen() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const UsersScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 60,
              ),
              const Text(
                'Login with xmpp account',
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                decoration: const InputDecoration(
                  label: Text("Username"),
                ),
                controller: usernameController,
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                decoration: const InputDecoration(
                  label: Text("Password"),
                ),
                controller: passwordController,
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(onPressed: _login, child: const Text("Login")),
            ],
          ),
        ),
      ),
    );
  }
}
