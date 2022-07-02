import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

// TODO(2): import provider package

import 'package:flutter/material.dart';

//TODO(1): paste your credentials.
const firebaseOptions = FirebaseOptions(
  apiKey: '',
  appId: '',
  messagingSenderId: '',
  projectId: '',
  authDomain: '',
  storageBucket: '',
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configure the default Firebase project.
  await Firebase.initializeApp(options: firebaseOptions);

  // TODO(3): wrap with `ChangeNotifierProvider` and create a new `AuthState` instance.
  runApp(
    const MyApp(),
  );
}

/// Holds the authentication state of the user.
// TODO(4): extend `ChangeNotifier`.
class AuthState {
  final _auth = FirebaseAuth.instance;

  User? _user;
  User? get user => _user;

  AuthState() {
    _auth.authStateChanges().listen((user) {
      _user = user;
      // TODO(5): call `notifyListeners()`.
    });
  }

  Future<void> signUpNewGuest(String name) async {
    try {
      await _auth.signInAnonymously();
      await _auth.currentUser!.updateDisplayName(name);
      await _auth.currentUser!.reload();
    } on FirebaseAuthException {
      rethrow;
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Get Started with FlutterFire',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      // TODO(6): Use `Consumer` to dynamically show the user based on `AuthState` user property.
      home: const WelcomePage(),
    );
  }
}

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Get Started with FlutterFire'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome to FlutterFire Polls!',
                style: Theme.of(context).textTheme.headline4,
              ),
              const SizedBox(height: 20),
              const Text('To get started, enter your name.'),
              const SizedBox(height: 20),
              SizedBox(
                width: 300,
                child: TextField(
                  controller: nameController,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              // TODO(7): Use `Consumer` to use the `AuthState` method `signUpNewGuest()` on pressed event.
              ElevatedButton(
                onPressed: () {},
                child: const Text('Start'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PollsPage extends StatelessWidget {
  const PollsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO(8): Read the user display name from `AuthState` using context.
    final name = '';

    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome ${name ?? 'User'}'),
      ),
      body: Column(
        children: [],
      ),
    );
  }
}
