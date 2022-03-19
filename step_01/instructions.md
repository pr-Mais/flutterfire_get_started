# Step 1: Connect our Flutter app to Firebase

## 💡 Explanation
[Firebase](https://firebase.google.com) offers many products to build scalable apps on multiple platforms.
[FlutterFire](https://firebase.flutter.dev) is a collection of plugins used to integrate Firebase in Flutter.

Some products Firebase offers:
1. **Authentication** with multiple providers such as Email and Password, Phone, and social providers such as Google and Apple.
2. **Firestore database**: a NoSQL real-time database.
3. **Cloud Functions**: write functions and deploy them easily to the cloud.

In this workshop, we will learn how to use Firebase in Flutter.
We will build a polls game that enables users to create polls and answer them in real-time.

In the first step, we will configure Firebase in our Flutter app.
There's already some code provided, if you run the app at this step, you will see a welcome page with a field that ask you for your name.

## ✅ TODO list
1. Call `Firebase.initializeApp()` method in `main()`, and pass it the constant `FirebaseOptions` that's already defined.
2. Ensure widgets are initialized by calling `WidgetsFlutterBinding.ensureInitialized()` before `initializeApp()`.

# 🥲 Stuck?
Just click on **Show Solution** button somewhere below 👇🏻.