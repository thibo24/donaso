import 'package:donaso/database.dart';
import 'package:donaso/maps.dart';
import 'package:donaso/subscriptionPage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:bcrypt/bcrypt.dart';

void main() async {
  Database data = await Database.connect();
  print("-----------------zizi-------------------------");
  try {
    // Provide the latitude, longitude, and maxDistance values
    double maxDistance = 10000;
    var locations =
        await data.findLocationsNearby(-122.084969, 37.421725, maxDistance);
    // Longitude
    // Print the retrieved locations
    for (var location in locations) {
      var coordinates = location['location']['coordinates'];
      print('Latitude: ${coordinates[1]}');
      print('Longitude: ${coordinates[0]}');
      print('Description: ${location['description']}');
      print('--------------');
    }
  } catch (e) {
    print('Error: $e');
  }
  print("-----------------zizi-------------------------");

  runApp(MyApp(db: data));
}

class MyApp extends StatelessWidget {
  Database db;
  MyApp({Key? key, required this.db}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(
        title: 'Flutter Demo Home Page',
        db: db,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title, required this.db})
      : super(key: key);
  final String title;
  Database db;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
                List<Map<String, dynamic>> map = await widget.db
                    .selectSQL("user", "username", loginController.text);
                if (map.isNotEmpty) {
                  map.forEach((element) {
                    if (BCrypt.checkpw(
                        passwordController.text, element["password"])) {
                      debugPrint("Mot de passe correct");
                      passwordController.clear();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Maps(
                              username: loginController.text,
                              db: widget.db,
                            ),
                          ));
                      //TODO passer le login en paramettre dans maps
                    } else {
                      debugPrint("Mot de passe incorrect");
                      passwordController.clear();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Password incorrect"),
                        ),
                      );
                    }
                  });
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
