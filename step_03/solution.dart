import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

// TODO(1): import provider package
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

const firebaseOptions = FirebaseOptions(
  apiKey: 'AIzaSyBzTujHR_zs6CnxcBR-e2PuFcj8U0EfyK0',
  appId: '1:252234506814:web:a5950ff065e27301a8676f',
  messagingSenderId: '252234506814',
  projectId: 'get-started-with-flutter-3bdfb',
  authDomain: 'get-started-with-flutter-3bdfb.firebaseapp.com',
  storageBucket: 'get-started-with-flutter-3bdfb.appspot.com',
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configure the default Firebase project.
  await Firebase.initializeApp(options: firebaseOptions);

  // TODO(2): wrap with `ChangeNotifierProvider` and create a new `AuthState` instance.
  runApp(
    ChangeNotifierProvider<AuthState>(
      create: (_) => AuthState(),
      child: const MyApp(),
    ),
  );
}

/// Holds the authentication state of the user.
// TODO(3): extend `ChangeNotifier`.
class AuthState extends ChangeNotifier {
  final _auth = FirebaseAuth.instance;

  User? _user;
  User? get user => _user;

  AuthState() {
    _auth.authStateChanges().listen((user) {
      _user = user;
      // TODO(4): call `notifyListeners()`.
      notifyListeners();
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
      // TODO(5): Use `Consumer` to dynamically show the user based on `AuthState` user property.
      home: Consumer<AuthState>(
        builder: (_, auth, __) {
          // If a guest has signed in.
          if (auth._user != null) {
            return PollsPage();
          } else {
            // If no guest signed in, we prompt them to sign in.
            return const WelcomePage();
          }
        },
      ),
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
              // TODO(6): Use `Consumer` to use the `AuthState` method `signUpNewGuest()` on pressed event.
              Consumer<AuthState>(
                builder: (_, auth, __) => ElevatedButton(
                  onPressed: () => auth.signUpNewGuest(nameController.text),
                  child: const Text('Start'),
                ),
              )
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
    // TODO(7): Read the user display name from `AuthState` using context.
    final name = context.read<AuthState>().user!.displayName;

    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome ${name ?? 'User'}'),
      ),
      body: Column(
        children: [
          const CreatePollButton(),
        ],
      ),
    );
  }
}

// TODO(8): Add a new StatelessWidget named `CreatePollButton`.
class CreatePollButton extends StatelessWidget {
  const CreatePollButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.amber[100],
      child: InkWell(
        onTap: () {},
        child: Container(
          margin: const EdgeInsets.all(30),
          height: 100,
          width: double.infinity,
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            alignment: Alignment.center,
            child: const Text(
              'Create a Poll',
              style: TextStyle(fontSize: 20),
            ),
          ),
        ),
      ),
    );
  }
}