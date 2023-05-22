import 'package:donaso/database.dart';
import 'package:donaso/subscriptionPage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Database db;
  TextEditingController loginController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'], // Définissez les scopes d'accès requis
  );

  Future<void> _handleGoogleSignIn() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser != null) {
        // Connexion réussie, récupérez les informations de l'utilisateur
        final String email = googleUser.email;
        final String? displayName = googleUser.displayName;
        final String? photo = googleUser.photoUrl;

        // Faites ce que vous voulez avec les informations de l'utilisateur
        // Par exemple, enregistrez l'utilisateur dans votre base de données
      }
    } catch (error) {
      // Gérez les erreurs de connexion
      print('Erreur de connexion avec Google : $error');
    }
  }

  @override
  void dispose() {
    loginController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
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
                List<Map<String, dynamic>> map = await db.selectSQL(
                    "user", "username", loginController.text);
                if (map.isNotEmpty) {
                  map.forEach((element) {
                    if (element["password"] == passwordController.text) {
                      debugPrint("Mot de passe correct");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MyHomePage(
                                title: 'Flutter Demo Home Page')),
                      );
                    } else {
                      debugPrint("Mot de passe incorrect");
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Password incorrect"),
                        ),
                      );
                    }
                  });
                } else {
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
                      builder: (context) => const SubscriptionPage()),
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
