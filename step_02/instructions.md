# Step 2: Anonymous Authentication

## 💡 Explanation
Upon creating a new poll, or voting in existing polls, we need to be able to uniquely identify a user.
This step is necessary to make sure votes are unique for each user.

We will use the simplest authentication provider in Firebase, which is `anonymous` sign in. 
The user doesn't need to provide any email, or phone number to sign in, but it also means if the browser cache is clean or if the user signed out, they will lose that identifier forever.

To use Firebase Auth in Flutter, we first need to import the [`firebase_auth` package](https://pub.dev/packages/firebase_auth).

### On this step:
1. Set up a listener to changes in authentication states and update the current user accordingly.
2. Use `firebase_auth` to sign in users anonymously.

# 🥲 Stuck?
Just click on **Show Solution** button somewhere below 👇🏻.