import 'package:first_app/home01.dart';
import 'package:first_app/menu.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'profile.dart';

class MyHomePage extends StatefulWidget {
  String canteenName;
  Map userData;
  String userID='a@bcom';
  MyHomePage(this.canteenName,this.userData);


  @override
  _MyHomePageState createState() => _MyHomePageState(canteenName,userData);
}

class _MyHomePageState extends State<MyHomePage> {
     String canteenName= '',userID;
     Map userData;
     _MyHomePageState(this.canteenName,this.userData);
    Future<SharedPreferences> _pref = SharedPreferences.getInstance();
    @override
    void initState() {
      userID = userData['emailDot'];
     _pref.then((value) {
       setState(() {
         //canteenName = value.getString('canteenCurrent');
         print(canteenName);
       });
     });
      // TODO: implement initState
      super.initState();
    }

  int _currentindex = 0;

  // var tabs = [
  //   Center(child: Homedish(canteenName)),
  //   Center(child: Menu(canteenName)),
  //   Center(child: Text('profile')),
  // ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /* appBar: AppBar(
        title: Text('WELCOME TO DELICEUS'),
      ),*/
      body: IndexedStack(
        index: _currentindex,
          children: [
            Homedish(canteenName,userData),
            Menu(canteenName,userData),
            Profile(userData,canteenName)

          ],),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentindex,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            //backgroundColor: Colors.blue),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fastfood),
            label: 'Menu',
            //backgroundColor: Colors.black),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'Profile',
            //backgroundColor: Colors.green),
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentindex = index;
          });
        },
      ),
    );
  }
}
