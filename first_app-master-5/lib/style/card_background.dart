import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CardBackgrounds {
  CardBackgrounds._();
  List<Color> colors = [Colors.blue, Colors.black];
  static QuerySnapshot querySnapshot;

  getDriversList() async {
    querySnapshot =
        await Firestore.instance.collection('Payment').getDocuments();
    return await Firestore.instance.collection('Payment').getDocuments();
  }

  static Widget black = new Container(
    width: double.maxFinite,
    height: double.maxFinite,
    color: Color(0xff0B0B0F),
  );

  static Widget white = new Container(
    width: double.maxFinite,
    height: double.maxFinite,
    color: Color(0xffF9F9FA),
  );

  // static Widget choose = new ListView.builder(
  //       if (querySnapshot != null) {
  //     primary: false,
  //     itemCount: querySnapshot.documents.length,
  //     padding: EdgeInsets.all(12),
  //     itemBuilder: (context, i) {
  //       child:
  //       Container(
  //         key: ObjectKey(querySnapshot.documents.elementAt(i)),
  //         color: (i % 2 == 0) ? Colors.red : Colors.green,
  //       );
  //     });

  // static Widget _show() {

  // }

  static Widget show() {
    if (querySnapshot != null) {
      return ListView.builder(
          primary: false,
          itemCount: querySnapshot.documents.length,
          padding: EdgeInsets.all(12),
          itemBuilder: (context, i) {
            child:
            Container(
              key: ObjectKey(querySnapshot.documents.elementAt(i)),
              color: (i % 2 == 0) ? Colors.red : Colors.green,
            );
          });
    }
  }
}
