import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Deliceus {
  static const String appName = 'deliceus';

  static SharedPreferences sharedPreferences;
  static User user;
  static FirebaseAuth auth;
  static FirebaseFirestore firestore;

  static String collectionUser = "users";
  static String userCartList = "userCart";

  static final String userName = "name";
  static final String userEmail = "email";
  static final String userPhotoUrl = "photoUrl";
  static final String userUID = "uid";
  static final String userDepartment = "department";
  static final String userAvatarUrl = "url";
}
