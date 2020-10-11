import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';



class TableRes extends StatefulWidget {
  Map userData;
  String canteenName;
  TableRes(this.userData,this.canteenName);
  @override
  _TableResState createState() => _TableResState(userData,canteenName);
}

class _TableResState extends State<TableRes> {
  Map userData;
  String canteenName;
  _TableResState(this.userData,this.canteenName);
  var tables = 0;
  Map canteen={};
  var aTable=0;
  DatabaseReference dRef = FirebaseDatabase.instance.reference();
  @override
  void initState() {
    // TODO: implement initState
    print(canteenName);
    dRef.child('canteens').child(canteenName).once().then((value) {
      Map count = value.value;
      setState(() {
        canteen = value.value;
        aTable = canteen['aTable'];
        if(count['reservation'][userData['emailDot']]!=null)  tables = count['reservation'][userData['emailDot']];
      });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text('Reservation'),),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text('Reserved Tables'),
                SizedBox(height: 10,),
                Text('$tables'),
                SizedBox(height: 10,),
                Text('Available Tables'),
                SizedBox(height: 10,),
                Text('$aTable'),
                SizedBox(height: 10,),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all()
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('New'),
                      IconButton(
                          icon: Icon(Icons.add_circle),
                          onPressed: (){
                            setState(() {

                            });
                            dRef.child('canteens').child(canteenName).child('aTable').set(
                                aTable-1
                            );
                            dRef.child('canteens').child(canteenName).child('reservation').child(userData['emailDot']).set(
                                tables+1
                            );
                            aTable = aTable - 1;
                            tables = tables +1 ;
                          }),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all()
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Cancel'),
                      IconButton(
                          icon: Icon(Icons.add_circle),
                          onPressed: (){
                            setState(() {

                            });
                            dRef.child('canteens').child(canteenName).child('aTable').set(
                                aTable+1
                            );
                            dRef.child('canteens').child(canteenName).child('reservation').child(userData['emailDot']).set(
                                tables-1
                            );
                            aTable = aTable + 1;
                            tables = tables - 1 ;
                          }),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
