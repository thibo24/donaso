import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/profile/user.dart';
import 'package:flutter_application_2/startPage.dart';
import 'package:flutter_application_2/subscriptionPage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'database.dart';

void main() async {
  HttpOverrides.global = MyHttpOverrides();
  runApp(MyApp());
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatelessWidget {
  final DatabaseLoader databaseLoader = DatabaseLoader();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: databaseLoader.connect(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/DoNaSo_logo.png",
                      width: 100,
                      height: 100,
                    ),
                    SizedBox(height: 20),
                    CircularProgressIndicator(),
                  ],
                ),
              ),
            ),
          );
        } else {
          if (snapshot.hasError) {
            return const MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                body: Center(
                  child: Text('Erreur de connexion à la base de données.'),
                ),
              ),
            );
          } else {
            final Database data = databaseLoader.db;
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Login page',
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              home: MyHomePage(
                title: 'Login page',
                db: data,
              ),
            );
          }
        }
      },
    );
  }
}

class DatabaseLoader {
  late Database db;

  Future<void> connect() async {
    try {
      db = await Database.connect();
    } catch (error) {
      print('Erreur de connexion à la base de données : $error');
      rethrow;
    }
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title, required this.db})
      : super(key: key);
  final String title;
  final Database db;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController loginController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  Future<void> _handleGoogleSignIn() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        final String email = googleUser.email;
        final String? userid = googleUser.id;

        String fullName = googleUser.displayName ?? '';
        List<String> nameParts = fullName.split(' ');
        String firstName = nameParts.isNotEmpty ? nameParts.first : '';

        if (await widget.db.checkUserGoogle(firstName)) {
          User user = await widget.db.createUser(firstName);
          navigateToMainMenu(user);
        } else {
          widget.db.addUserGoogle(email, fullName);
          User user = await widget.db.createUser(fullName);
          navigateToMainMenu(user);
        }
      }
    } catch (error) {
      print('Erreur de connexion avec Google : $error');
    }
  }

  void saveAccount() {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString("username", loginController.text);
      prefs.setString("password", passwordController.text);
    });
  }

  void isSavedAccount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');
    String? password = prefs.getString('password');
    if (await widget.db.checkUser(username!, password!)) {
      User user = await widget.db.createUser(username);
      navigateToMainMenu(user);
    }
  }

  void navigateToMainMenu(User user) {
    final mainMenu = AppLoader(db: widget.db, user: user);
    Navigator.push(context, MaterialPageRoute(builder: (context) => mainMenu));
  }

  @override
  void dispose() {
    loginController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> requestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (permission == LocationPermission.denied || !isLocationServiceEnabled) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception("Non autorisé");
      }
      if (!isLocationServiceEnabled) {
        throw Exception("Service de localisation désactivé");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    requestLocationPermission();
    isSavedAccount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Login',
            ),
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Login',
              ),
              controller: loginController,
            ),
            const Text(
              'Password',
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
            ElevatedButton(
              onPressed: () async {
                if (await widget.db
                    .checkUser(loginController.text, passwordController.text)) {
                  saveAccount();
                  User user = await widget.db.createUser(loginController.text);
                  navigateToMainMenu(user);
                } else {
                  passwordController.clear();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Utilisateur inconnu"),
                    ),
                  );
                }
              },
              child: const Text("Connexion"),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SubscriptionPage(
                            db: widget.db,
                          )),
                );
              },
              child: const Text("Inscription"),
            ),
            ElevatedButton(
              onPressed: _handleGoogleSignIn,
              child: const Text('Se connecter avec Google'),
            ),
          ],
        ),
      ),
    );
  }
}
