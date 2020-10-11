import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'Registrationpage.dart';
import 'chooseCanteen.dart';
import 'config/config.dart';
import 'dialog/error.dart';
import 'dialog/loading.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  Deliceus.auth = FirebaseAuth.instance;
  Deliceus.sharedPreferences = await SharedPreferences.getInstance();
  Deliceus.firestore = FirebaseFirestore.instance;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ITP',
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _key = GlobalKey<FormState>();

  TextEditingController _emailContoller = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  DatabaseReference dRef = FirebaseDatabase.instance.reference();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Form(
            key: _key,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Image.asset('assets/logo.png'),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.red[700],
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      children: [
                        SizedBox(height: 30),
                        TextFormField(
                          controller: _emailContoller,
                          decoration: InputDecoration(
                              labelText: 'Email',
                              labelStyle: TextStyle(
                                color: Colors.red[700],
                              )),
                          style: TextStyle(
                            color: Colors.red[700],
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Email cannot be empty';
                            } else {
                              return null;
                            }
                          },
                        ),
                        SizedBox(height: 30),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Password cannot be empty';
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                              labelText: 'Password',
                              labelStyle: TextStyle(
                                color: Colors.red[700],
                              )),
                          style: TextStyle(
                            color: Colors.red[700],
                          ),
                        ),
                        SizedBox(height: 5),
                        FlatButton(
                          child: Text('Not registerd? Sign up'),
                          onPressed: () {
                            Navigator.of(context).push(
                              CupertinoPageRoute(
                                fullscreenDialog: true,
                                builder: (context) => RegistrationScreen(),
                              ),
                            );
                          },
                          textColor: Colors.red[700],
                        ),
                        SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            FlatButton(
                              child: Text('Login'),
                              onPressed: () {
                                _emailContoller.text.isNotEmpty &&
                                    _passwordController.text.isNotEmpty
                                    ? loginUser()
                                    : showDialog(
                                    context: context,
                                    builder: (c) {
                                      return ErrorAlertDialog(
                                        message:
                                        "Please enter the email and password.",
                                      );
                                    });
                              },
                              color: Colors.red[700],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  FirebaseAuth _auth = FirebaseAuth.instance;
  void loginUser() async {
    showDialog(
        context: context,
        builder: (c) {
          return LoadingAlertDialog(
            message: "Signing In Please Wait..",
          );
        });
    User firebaseUser;
    await _auth
        .signInWithEmailAndPassword(
      email: _emailContoller.text.trim(),
      password: _passwordController.text.trim(),
    )
        .then((authUser) {
      firebaseUser = authUser.user;
    }).catchError((error) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c) {
            return ErrorAlertDialog(
              message: error.message.toString(),
            );
          });
    });
    if (firebaseUser != null) {
      readData(firebaseUser).then((s) {
        Navigator.pop(context);
        var email='';
        _emailContoller.text.split('.').forEach((element) {
          email = email+ element;
        });
        print(email);
        dRef.child('users').child(email).once().then((value) {
          Route route = MaterialPageRoute(builder: (c) => ChooseCanteen(value.value));
          Navigator.pushReplacement(context, route);
        });

      });
    }
  }

  Future readData(User fUser) async {
    FirebaseFirestore.instance
        .collection("users")
        .doc(fUser.uid)
        .get()
        .then((dataSnapshot) async {
      await Deliceus.sharedPreferences
          .setString("uid", dataSnapshot.data()[Deliceus.userUID]);
      await Deliceus.sharedPreferences
          .setString(Deliceus.userEmail, dataSnapshot.data()[Deliceus.userUID]);
      await Deliceus.sharedPreferences
          .setString(Deliceus.userName, dataSnapshot.data()[Deliceus.userName]);
      await Deliceus.sharedPreferences.setString(Deliceus.userDepartment,
          dataSnapshot.data()[Deliceus.userDepartment]);
      await Deliceus.sharedPreferences.setString(
          Deliceus.userAvatarUrl, dataSnapshot.data()[Deliceus.userAvatarUrl]);
    });
  }
}
