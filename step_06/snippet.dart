import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  runApp(
    ChangeNotifierProvider<AuthState>(
      create: (_) => AuthState(),
      child: const MyApp(),
    ),
  );
}

/// Holds the authentication state of the user.
class AuthState extends ChangeNotifier {
  final _auth = FirebaseAuth.instance;

  User? _user;
  User? get user => _user;

  AuthState() {
    _auth.authStateChanges().listen((user) {
      _user = user;
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

class PollsState extends ChangeNotifier {
  final _firestore = FirebaseFirestore.instance;

  List<QueryDocumentSnapshot<Poll>>? _polls;
  List<QueryDocumentSnapshot<Poll>> get polls => _polls ?? [];

  CollectionReference<Poll> get _pollsRef =>
      _firestore.collection('poll').withConverter<Poll>(
            fromFirestore: (snapshot, _) => Poll.fromJson(snapshot.data()),
            toFirestore: (Poll poll, _) => poll.toJson(),
          );

  PollsState() {
    _pollsRef.snapshots().listen((event) {
      _polls = event.docs;
      notifyListeners();
    });
  }

  Future<void> createPoll(Poll poll) async {
    //TODO(1): Implement `createPoll`.
  }

  Future<void> vote(String uid, String pollId, int answerId) async {
    await _pollsRef.doc(pollId).update({'users.$uid': answerId});
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
      home: Consumer<AuthState>(
        builder: (_, auth, __) {
          // If a guest has signed in.
          if (auth._user != null) {
            return ChangeNotifierProvider<PollsState>(
              create: (_) => PollsState(),
              child: const PollsPage(),
            );
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
    final currentUser = context.read<AuthState>().user!;

    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome ${currentUser.displayName ?? 'User'}'),
      ),
      body: Column(
        children: [
          // TODO(2): Add `CreatePollButton` and use the `createPoll` method in `onTap` callback.
          Expanded(
            child: Consumer<PollsState>(
              builder: (_, pollsState, __) => ListView.builder(
                padding: const EdgeInsets.all(30),
                itemCount: pollsState.polls.length,
                itemBuilder: (_, index) {
                  final pollDoc = pollsState.polls[index];

                  return PollListItem(
                    poll: pollDoc,
                    onVote: (i) =>
                        pollsState.vote(currentUser.uid, pollDoc.id, i),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}

class PollListItem extends StatelessWidget {
  const PollListItem({Key? key, required this.poll, required this.onVote})
      : super(key: key);

  final QueryDocumentSnapshot<Poll> poll;
  final void Function(int) onVote;

  @override
  Widget build(BuildContext context) {
    final uid = context.read<AuthState>().user!.uid;
    final pollData = poll.data();
    final answers = pollData.answers;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            pollData.question,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        for (var i = 0; i < answers.length; i++)
          ListTile(
            title: Text(answers[i].text),
            selected: pollData.users[uid] == i,
            trailing: Text('Votes: ${answers[i].votes}'),
            onTap: () => onVote(answers[i].id),
          ),
        const Divider(),
      ],
    );
  }
}

class CreatePollButton extends StatelessWidget {
  const CreatePollButton({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.amber[100],
      child: InkWell(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(20),
          height: 60,
          width: double.infinity,
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

class NewPollSheet extends StatefulWidget {
  const NewPollSheet({
    Key? key,
    required this.onSave,
  }) : super(key: key);
  final Function(Poll) onSave;

  @override
  State<NewPollSheet> createState() => _NewPollSheetState();
}

class _NewPollSheetState extends State<NewPollSheet> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final questionController = TextEditingController();
  final answer1 = TextEditingController();
  final answer2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      onClosing: () {},
      builder: (context) {
        return Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: [
                TextFormField(
                  controller: questionController,
                  validator: (value) =>
                      value != null && value.isNotEmpty ? null : 'required',
                  decoration: const InputDecoration(
                    labelText: 'Question',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 50),
                TextFormField(
                  controller: answer1,
                  validator: (value) =>
                      value != null && value.isNotEmpty ? null : 'required',
                  decoration: const InputDecoration(
                    labelText: 'Answer 1',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: answer2,
                  validator: (value) =>
                      value != null && value.isNotEmpty ? null : 'required',
                  decoration: const InputDecoration(
                    labelText: 'Answer 2',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      Poll poll = Poll(
                        answers: [
                          Answer(id: 0, text: answer1.text),
                          Answer(id: 1, text: answer2.text)
                        ],
                        question: questionController.text,
                      );
                      widget.onSave(poll);
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Create'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// New types added below, do not change anything.

class Poll {
  final String question;
  final List<Answer> answers;
  final Map<String, int> users;

  Poll({
    required this.question,
    required this.answers,
    this.users = const {},
  });

  factory Poll.fromJson(Map<String, dynamic>? data) {
    final users = (data!['users'] ?? {}).cast<String, int>();
    final answers = data['answers']
        .map((answerData) => Answer.fromJson(answerData, users))
        .toList()
        .cast<Answer>();

    return Poll(
      answers: answers,
      question: data['question'],
      users: users,
    );
  }

  toJson() {
    final answersMap = <Map<String, dynamic>>[];

    for (var answer in answers) {
      answersMap.add(answer.toJson());
    }

    return {
      'question': question,
      'answers': answersMap,
      'users': users,
    };
  }
}

class Answer {
  final String text;
  final int votes;
  final int id;

  Answer({required this.text, required this.id, this.votes = 0});
  factory Answer.fromJson(Map<String, dynamic> data, Map<String, int> users) {
    // Votes is the total of users who voted for this answer by its Id.
    int votes = 0;

    for (String user in users.keys) {
      if (users[user] == data['id']) {
        votes++;
      }
    }

    return Answer(
      text: data['text'],
      id: data['id'],
      votes: votes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'id': id,
    };
  }
}
