import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'chooseCanteen.dart';
import 'config/config.dart';
import 'dialog/error.dart';
import 'dialog/loading.dart';


class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _key = GlobalKey<FormState>();
  DatabaseReference dRef = FirebaseDatabase.instance.reference();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailContoller = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmpasswordController = TextEditingController();
  TextEditingController _departmentController = TextEditingController();

  String userImageUrl = "";
  File _imageFile;
  Map userData={};

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width,
        _screenHeight = MediaQuery.of(context).size.height;
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
                Text(
                  'Register',
                  style: TextStyle(
                    color: Colors.red[700],
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 5),
                InkWell(
                  onTap: _selectAndPickImage,
                  child: CircleAvatar(
                    radius: _screenWidth * 0.15,
                    backgroundColor: Colors.red[700],
                    backgroundImage:
                        _imageFile == null ? null : FileImage(_imageFile),
                    child: _imageFile == null
                        ? Icon(
                            Icons.add_a_photo,
                            size: _screenWidth * 0.15,
                            color: Colors.grey,
                          )
                        : null,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Name cannot be empty';
                          } else
                            return null;
                        },
                        decoration: InputDecoration(
                            labelText: 'Name',
                            labelStyle: TextStyle(
                              color: Colors.red[700],
                            )),
                        style: TextStyle(color: Colors.red[700]),
                      ),
                      SizedBox(height: 30),
                      TextFormField(
                        controller: _emailContoller,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Email cannot be empty';
                          } else
                            return null;
                        },
                        decoration: InputDecoration(
                            labelText: 'Email',
                            labelStyle: TextStyle(color: Colors.red[700])),
                        style: TextStyle(color: Colors.red[700]),
                      ),
                      SizedBox(height: 30),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Password cannot be empty';
                          } else
                            return null;
                        },
                        decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(color: Colors.red[700])),
                        style: TextStyle(
                          color: Colors.red[700],
                        ),
                      ),
                      SizedBox(height: 30),
                      TextFormField(
                        controller: _confirmpasswordController,
                        obscureText: true,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Password cannot be empty';
                          } else
                            return null;
                        },
                        decoration: InputDecoration(
                            labelText: 'Confirm Password',
                            labelStyle: TextStyle(color: Colors.red[700])),
                        style: TextStyle(
                          color: Colors.red[700],
                        ),
                      ),
                      SizedBox(height: 30),
                      TextFormField(
                        controller: _departmentController,
                        obscureText: false,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Department cannot be empty';
                          } else
                            return null;
                        },
                        decoration: InputDecoration(
                            labelText: 'Department',
                            labelStyle: TextStyle(color: Colors.red[700])),
                        style: TextStyle(
                          color: Colors.red[700],
                        ),
                      ),
                      SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          FlatButton(
                            child: Text('Sign Up'),
                            onPressed: () {
                              if (_key.currentState.validate()) {
                                uploadAndSaveImage();
                              }
                            },
                            color: Colors.red[700],
                          ),
                          FlatButton(
                            child: Text('Cancel'),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            color: Colors.red[700],
                          )
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
    ));
  }

  Future<void> _selectAndPickImage() async {
    // ignore: deprecated_member_use
    _imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
  }

  Future<void> uploadAndSaveImage() async {
    if (_imageFile == null) {
      showDialog(
          context: context,
          builder: (c) {
            return ErrorAlertDialog(
              message: "Please select an image ",
            );
          });
    } else {
      _passwordController.text == _confirmpasswordController.text
          ? _emailContoller.text.isNotEmpty &&
                  _passwordController.text.isNotEmpty &&
                  _passwordController.text.isNotEmpty &&
                  _nameController.text.isNotEmpty &&
                  _departmentController.text.isNotEmpty
              ? uploadToStorage()
              : displayDialog("Please fill the registration complete form.. ")
          : displayDialog("Password do not match !");
    }
  }

  displayDialog(String msg) {
    showDialog(
        context: context,
        builder: (c) {
          return ErrorAlertDialog(
            message: msg,
          );
        });
  }

  uploadToStorage() async {
    showDialog(
        context: context,
        builder: (c) {
          return LoadingAlertDialog(
            message: "Creating account ! Please Wait...",
          );
        });

    String imageFileName = DateTime.now().millisecondsSinceEpoch.toString();

    StorageReference storageReference =
        FirebaseStorage.instance.ref().child('userImages').child(imageFileName);

    StorageUploadTask storageUploadTask = storageReference.putFile(_imageFile);

    StorageTaskSnapshot taskSnapshot = await storageUploadTask.onComplete;

    await taskSnapshot.ref.getDownloadURL().then((urlImage) {
      userImageUrl = urlImage;

      _registerUser();
    });
  }

  FirebaseAuth _auth = FirebaseAuth.instance;
  void _registerUser() async {
    User firebaseUser;
    await _auth
        .createUserWithEmailAndPassword(
      email: _emailContoller.text.trim(),
      password: _passwordController.text.trim(),
    )
        .then((auth) {
      firebaseUser = auth.user;
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
      saveUserInfoToFireStore(firebaseUser).then((value) {
        Navigator.pop(context);
        Route route = MaterialPageRoute(builder: (c) => ChooseCanteen(userData));
        Navigator.pushReplacement(context, route);
      });
    }
  }

  Future saveUserInfoToFireStore(User fUser) async {
    FirebaseFirestore.instance.collection("users").doc(fUser.uid).set({
      "uid": fUser.uid,
      "email": fUser.email,
      "name": _nameController.text.trim(),
      "department": _departmentController.text.trim(),
      "url": userImageUrl,
    });
    var email='';
    _emailContoller.text.split('.').forEach((element) {
      email = email+ element;
    });
    print(email);
    setState(() {
      userData = {
        'emailDot' : email,
        'email' : _emailContoller.text.trim(),
        'name' :_nameController.text.trim(),
        'department' : _departmentController.text.trim(),
        'pass' :_passwordController.text.trim(),
        'url' : userImageUrl,
        'uID' : fUser.uid,

      };
    });
    dRef.child('users').child(email).set(userData);

    await Deliceus.sharedPreferences.setString("uid", fUser.uid);
    await Deliceus.sharedPreferences.setString(Deliceus.userEmail, fUser.email);
    await Deliceus.sharedPreferences
        .setString(Deliceus.userName, _nameController.text);
    await Deliceus.sharedPreferences
        .setString(Deliceus.userDepartment, _departmentController.text);
    await Deliceus.sharedPreferences
        .setString(Deliceus.userAvatarUrl, userImageUrl);
  }
}
