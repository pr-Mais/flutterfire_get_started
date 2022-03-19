# Step 2: Anonymous Authentication

## 💡 Explanation
Upon creating a new poll, or voting in existing polls, we need to be able to uniquely identify a user.
This step is necessary to make sure votes are unique for each user.

We will use the simplest authentication provider in Firebase, which is `anonymous` sign in. 
The user doesn't need to provide any email, or phone number to sign in, but it also means if the browser cache is clean or if the user signed out, they will lose that identifier forever.

To use Firebase Auth in Flutter, we first need to import the [`firebase_auth` package](https://pub.dev/packages/firebase_auth).

## ✅ TODO list
1. Import `firebase_auth` package.
2. Inside `AuthState` class, add a private final property `_auth` and assign it a `FirebaseAuth` instance from `firebase_auth` package.
3. Create a constructor.
4. Inside the constructor, register a listener to `authStateChanges()` stream from `_auth`.
5. Inside the listener, update the local `_user` property emitted by the stream.
6. Create a new asynchronous method named `signUpNewGuest()`, return type is `Future<void>`, and it accepts a `String` argument with the name of the user.
7. Inside the new method, use auth to sign-in a new user anonymously.
8. After sign-in, update the display name and reload the user.

# 🥲 Stuck?
Just click on **Show Solution** button somewhere below 👇🏻.