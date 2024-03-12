

import 'package:firebase_auth/firebase_auth.dart';

class Authentication{


 static String? getCurrentUserID() {
    final User? user = FirebaseAuth.instance.currentUser;
    return user?.uid; // This will be null if no user is logged in
  }


}