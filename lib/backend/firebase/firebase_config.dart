import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyA2Lo7J3oJikEDLORtOYdckAXOQLA0NvGY",
            authDomain: "palakkadnews.firebaseapp.com",
            projectId: "palakkadnews",
            storageBucket: "palakkadnews.firebasestorage.app",
            messagingSenderId: "974926284581",
            appId: "1:974926284581:web:4d27b4a0f278af1fbcbccc"));
  } else {
    await Firebase.initializeApp();
  }
}
