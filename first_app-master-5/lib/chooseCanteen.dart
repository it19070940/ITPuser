import 'package:firebase_database/firebase_database.dart';
import 'package:first_app/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';




class ChooseCanteen extends StatefulWidget {
  Map userData;
  ChooseCanteen(this.userData);
  @override
  _ChooseCanteenState createState() => _ChooseCanteenState(userData);
}

class _ChooseCanteenState extends State<ChooseCanteen> {
  Map userData;
  _ChooseCanteenState(this.userData);
  DatabaseReference dRef = FirebaseDatabase.instance.reference();
  Map canteens = {};
  List canteenNames=[];
  Future<SharedPreferences> _pref = SharedPreferences.getInstance();
  String userID='a@bcom';
  @override
  void initState() {
    userID = userData['emailDot'];
    print(userData);
    dRef.child('canteens').once().then((value) {
      Map val = value.value;
      print(val);
      setState(() {
        canteens =  val;
        val.forEach((key, value) {
          canteenNames.add(key);
        });
      });

      print(val);
    });
    // TODO: implement initState

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Canteens'),),
      body: Container(
        child: ListView.builder(
            itemCount: canteens.length,
            itemBuilder:(context,index) {
              return FlatButton(
                onPressed: (){
                  _pref.then((value) {
                    value.setString('canteenCurrent', canteens[canteenNames[index]]['cName']);
                  });

                  Navigator.of(context).push(new CupertinoPageRoute(
                      builder: (BuildContext context) => MyHomePage(canteens[canteenNames[index]]['cName'],userData)));
                },
                child: Card(
                  child: Text(canteens[canteenNames[index]]['cName']),
                ),
              );
            } ),
      ),
    );
  }
}
