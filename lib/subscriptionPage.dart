import 'package:flutter/material.dart';

import 'database.dart';
import 'main.dart';

class SubscriptionPage extends StatelessWidget {
  final TextEditingController loginController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  late Database db;

  SubscriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(children: [
        TextField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Login',
          ),
          controller: loginController,
        ),
        TextField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Password',
          ),
          obscureText: true,
          autocorrect: false,
          controller: passwordController,
        ),
        TextField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Email',
          ),
          obscureText: false,
          autocorrect: false,
          controller: emailController,
        ),
        TextField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'First Name',
          ),
          obscureText: false,
          autocorrect: false,
          controller: firstNameController,
        ),
        TextField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Last Name',
          ),
          obscureText: false,
          autocorrect: false,
          controller: lastNameController,
        ),
        ElevatedButton(
          onPressed: () async {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const MyHomePage(
                        title: "Donaso",
                      )),
            );
            db = await Database.connect();
            await db.addUser(
                loginController.text,
                passwordController.text,
                emailController.text,
                firstNameController.text,
                lastNameController.text,
                "06 06 06 06 06");
          },
          child: const Text('Submit'),
        ),
      ]),
    ));
  }
}
