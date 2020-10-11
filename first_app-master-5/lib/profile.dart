import 'package:firebase_database/firebase_database.dart';
import 'package:first_app/config/config.dart';
import 'package:first_app/paymentMethods.dart';
import 'package:flutter/material.dart';

import 'tableReserve.dart';


class Profile extends StatefulWidget {
  Map userData;
  String canteenName;
  Profile(this.userData,this.canteenName);
  @override
  _ProfileState createState() => _ProfileState(userData,canteenName);
}

class _ProfileState extends State<Profile> {
  Map userData;
  String canteenName;
  _ProfileState(this.userData,this.canteenName);
  DatabaseReference dRef = FirebaseDatabase.instance.reference();
  var tables = 0;
  Map canteen={};
  var aTable=0;
  @override
  void initState() {
    //print(userData);
    // TODO: implement initState
    super.initState();
    print(canteenName);
    dRef.child('canteens').child(canteenName).once().then((value) {
      Map count = value.value;
      setState(() {
        canteen = value.value;
        aTable = canteen['aTable'];
        tables = count['reservation'][userData['emailDot']];
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    print(userData);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text('Profile'),),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                height: 300,
                width: 200,
                image: NetworkImage('${userData['url']}'),
              ),
              Text(userData['name']),
              SizedBox(height: 10,),
              Text(userData['email']),
              SizedBox(height: 10,),
              Text(userData['department']),
              SizedBox(height: 10,),
              FlatButton(
                onPressed: (){
                  Route route = MaterialPageRoute(builder: (c) => PaymentMethods(userData));
                  Navigator.push(context, route);
                },
                child: Text('Payment Methods'),

              ),

              FlatButton(
                onPressed: (){

                  Route route = MaterialPageRoute(builder: (c) => TableRes(userData,canteenName));
                  Navigator.push(context, route);
                },
                child: Text('Table Reservation'),

              ),


            ],
          ),
        ),
      ),
    );
  }
}
