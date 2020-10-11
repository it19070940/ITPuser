import 'package:firebase_database/firebase_database.dart';
import 'package:first_app/addcard.dart';
import 'package:first_app/config/config.dart';
import 'package:flutter/material.dart';

import 'credit_card.dart';
import 'style/card_background.dart';



class PaymentMethods extends StatefulWidget {
  Map userData;
  PaymentMethods(this.userData);
  @override
  _PaymentMethodsState createState() => _PaymentMethodsState(userData);
}

class _PaymentMethodsState extends State<PaymentMethods> {
  DatabaseReference dRef = FirebaseDatabase.instance.reference();
  Map userData;
  Map cards ={};
  List cardKeys=[];
  _PaymentMethodsState(this.userData);
  @override
  void initState() {
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
              return Card(
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
                  ],
                ),
              );
            }),
      ),
    );
  }
}
