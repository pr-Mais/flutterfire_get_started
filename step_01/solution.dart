//TODO(1): import `firebase_core` package.
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';

//TODO(2): paste your credentials.
const firebaseOptions = FirebaseOptions(
  apiKey: '',
  appId: '',
  messagingSenderId: '',
  projectId: '',
  authDomain: '',
  storageBucket: '',
);

void main() async {
  //TODO(2): Ensure WidgetsFlutterBinding is initialized.
  WidgetsFlutterBinding.ensureInitialized();

  //TODO(4): calls `Firebase.initializeApp()` and pass firebaseOptions.
  await Firebase.initializeApp(options: firebaseOptions);

  runApp(
    const MyApp(),
  );
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
