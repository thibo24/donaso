import 'package:flutter/material.dart';

import 'database.dart';
import 'main.dart';

class SubscriptionPage extends StatefulWidget {
  Database db;
  SubscriptionPage({Key? key, required this.db}) : super(key: key);

  @override
  _SubscriptionPageState createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  final TextEditingController loginController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  bool isLoginValid = true;
  bool isPasswordValid = true;
  bool isEmailValid = true;
  bool isPhoneValid = true;
  RegExp password = RegExp(r"^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$");
  RegExp email = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  RegExp phone = RegExp(r'^0[0-9]{9}$');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 3, 142, 13),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          alignment: Alignment.center,
          color: Colors.white,
          child: Column(
            children: [
              const Expanded(child: SizedBox()),
              TextField(
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  errorText: isLoginValid
                      ? null
                      : 'Login is too short or already exists',
                  labelText: 'Login',
                ),
                controller: loginController,
                onChanged: (value) async {
                  setState(() async {
                    isLoginValid =
                        value.length > 4 || !(await widget.db.checkUser(value));
                  });
                },
              ),
              TextField(
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Password',
                  errorText: isPasswordValid
                      ? null
                      : 'Password is too short or does not meet requirements',
                ),
                obscureText: true,
                autocorrect: false,
                controller: passwordController,
                onChanged: (value) {
                  setState(() {
                    isPasswordValid = password.hasMatch(value);
                  });
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
                  errorText: isEmailValid ? null : 'Email is not valid',
                ),
                obscureText: false,
                autocorrect: false,
                controller: emailController,
                onChanged: (value) {
                  setState(() {
                    isEmailValid = email.hasMatch(value);
                  });
                },
              ),
              TextField(
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Phone',
                  errorText: isPhoneValid ? null : 'Phone number is not valid',
                ),
                controller: phoneController,
                onChanged: (value) {
                  setState(() {
                    isPhoneValid = phone.hasMatch(value);
                  });
                },
              ),
              ElevatedButton(
                onPressed: () async {
                  if (isEmailValid && isLoginValid && isPasswordValid) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyHomePage(
                          title: "Donaso",
                          db: widget.db,
                        ),
                      ),
                    );
                    await widget.db.addUser(
                        loginController.text,
                        passwordController.text,
                        emailController.text,
                        firstNameController.text,
                        lastNameController.text,
                        phoneController.text,
                        null);
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Error'),
                          content: const Text(
                            'Please check your information and try again',
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: const Text('Submit'),
              ),
              const Expanded(child: SizedBox()),
            ],
          ),
        ),
      ),
    );
  }
}
