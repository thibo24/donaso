import 'package:flutter/material.dart';

import 'database.dart';
import 'main.dart';

class SubscriptionPage extends StatelessWidget {
  final TextEditingController loginController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  late Database db;
  bool isLoginValid = true;
  bool isPasswordValid = true;
  bool isEmailValid = true;
  RegExp password = RegExp(r"^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$");
  RegExp email = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

// Ajoutez d'autres variables booléennes pour les autres vérifications

  SubscriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(children: [
        TextField(
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              errorText:
                  isLoginValid ? null : 'Login is too short or already exists',
              labelText: 'Login',
            ),
            controller: loginController,
            onChanged: (value) async => {
                  db = await Database.connect(),
                  if (value.length <= 3 && await db.checkUser(value))
                    {isLoginValid = false}
                  else
                    {isLoginValid = true}
                }),
        TextField(
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: 'Password',
            errorText: isPasswordValid
                ? null
                : 'password is too short or hasn\'t a number',
          ),
          obscureText: true,
          autocorrect: false,
          controller: passwordController,
          onChanged: (value) => {
            if (value.length <= 3 && !password.hasMatch(value))
              {isPasswordValid = false}
            else
              {isPasswordValid = true}
          },
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
        TextField(
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: 'Email',
            errorText: isEmailValid ? null : 'email dosn\'t match the pattern',
          ),
          obscureText: false,
          autocorrect: false,
          controller: emailController,
          onChanged: (value) => {
            if (!email.hasMatch(value))
              {isEmailValid = false}
            else
              {isEmailValid = true}
          },
        ),
        TextField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Phone',
          ),
          controller: phoneController,
        ),
        ElevatedButton(
          onPressed: () async {
            if (isEmailValid && isLoginValid && isPasswordValid) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const MyHomePage(
                          title: "Donaso",
                        )),
              );
              await db.addUser(
                  loginController.text,
                  passwordController.text,
                  emailController.text,
                  firstNameController.text,
                  lastNameController.text,
                  phoneController.text);
            }
          },
          child: const Text('Submit'),
        ),
      ]),
    ));
  }
}
