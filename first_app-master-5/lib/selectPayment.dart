import 'package:barcode_scan/barcode_scan.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:first_app/addcard.dart';
import 'package:first_app/config/config.dart';
import 'package:first_app/scan.dart';
import 'package:flutter/material.dart';

import 'credit_card.dart';
import 'style/card_background.dart';



class SelectPayment extends StatefulWidget {
  Map userData,cartData;
  String canteenName;
  SelectPayment(this.userData,this.cartData,this.canteenName);
  @override
  _SelectPaymentState createState() => _SelectPaymentState(userData,cartData,canteenName);
}

class _SelectPaymentState extends State<SelectPayment> {
  DatabaseReference dRef = FirebaseDatabase.instance.reference();
  Map userData,cartData;
  Map cards ={};
  String canteenName;
  List cardKeys=[];
  _SelectPaymentState(this.userData,this.cartData,this.canteenName);
  String userID;
  @override
  void initState() {
    userID = userData['emailDot'];
    // TODO: implement initState
    dRef.child('card').child(userData['emailDot']).once().then((value) {
      print(value.value);
      setState(() {
        cards = value.value;
        cards.forEach((key, value) {
          cardKeys.add(key);
        });
      });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Payment Methods'),
            IconButton(
                icon: Icon(Icons.add),
              onPressed: () {
                Route route = MaterialPageRoute(builder: (c) => addcard(userData));
                Navigator.pushReplacement(context, route);
              },)
          ],
        ),),
      body: Center(
        child: ListView.builder(
          itemCount: cards.length,
            itemBuilder: (context,index){
              return FlatButton(
                onPressed: () async {
                  cartData.forEach((key, value) {
                    if(value['q']!=0) {
                      int tempPrice= int.parse(value['price']);
                      int tempQ= value['q'];
                      var itemCost=0;
                      itemCost = itemCost + (tempPrice*tempQ );
                      dRef.child('orders').child(canteenName).child(userID).child(value['itemName']).set(
                          {
                            'm' : 'qr',
                            'p' : value['price'],
                            'q' : value['q'],
                            't' : itemCost
                          }
                      );
                    }
                  });
                  await BarcodeScanner.scan();

                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => ScanPage()),
                  // );
                },
                child: Column(
                  children: [
                    CreditCard(
                      cardNumber: cards[cardKeys[index]]['number'],
                      cardExpiry: cards[cardKeys[index]]['expiry'],
                      cardHolderName: cards[cardKeys[index]]['name'],
                      cvv: cards[cardKeys[index]]['cvv'],
                      bankName: cards[cardKeys[index]]['bankName'],
                      showBackSide: false,
                      frontBackground: CardBackgrounds.black,
                      backBackground: CardBackgrounds.white,
                      showShadow: true,
                    ),
                    SizedBox(height: 5,)
                  ],
                ),
              );
            }),
      ),
    );
  }
}
