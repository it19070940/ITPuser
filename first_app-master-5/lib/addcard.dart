import 'package:firebase_database/firebase_database.dart';
import 'package:first_app/paymentMethods.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


import 'credit_card.dart';
import 'style/card_background.dart';



class addcard extends StatefulWidget {
  // addcard({Key key, this.title}) : super(key: key);
  // final String title;
  Map userData;
  addcard(this.userData);
  @override
  _addcardState createState() => _addcardState(userData);
}

class _addcardState extends State<addcard> {
  Map userData;
  _addcardState(this.userData);
  String cardNumber = "";
  String cardHolderName = "";
  String expiryDate = "";
  String cvv = "";
  String bankName = "";
  bool showBack = false;
  DatabaseReference dRef = FirebaseDatabase.instance.reference();

  getCardName(cardName) {
    this.cardHolderName = cardName;
  }

  getCardNo(cardNo) {
    this.cardNumber = cardNo;
  }

  getExpDate(exp) {
    this.expiryDate = exp;
  }

  getSvp(svp) {
    this.cvv = svp;
  }

  getBankName(bankName) {
    this.bankName = bankName;
  }

  var _formKey = GlobalKey<FormState>();

  createDate() {
    DocumentReference ds = Firestore.instance.collection('Payment').document();
    Map<String, dynamic> tasks = {
      //cardnumber,expirydate,holdername,svp
      "holdername": cardHolderName,
      "cardnumber": cardNumber,
      "expirydate": expiryDate,
      "cardname": bankName,
      "svp": cvv,
    };

    ds.setData(tasks).whenComplete(() {
      print("Details added");
    });
  }

  FocusNode _focusNode;
  @override
  void initState() {
    super.initState();
    _focusNode = new FocusNode();
    _focusNode.addListener(() {
      setState(() {
        _focusNode.hasFocus ? showBack = true : showBack = false;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // title: Text(widget.title),
          ),
      key: _formKey,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 40,
            ),
            CreditCard(
              cardNumber: cardNumber,
              cardExpiry: expiryDate,
              cardHolderName: cardHolderName,
              cvv: cvv,
              bankName: bankName,
              showBackSide: showBack,
              frontBackground: CardBackgrounds.black,
              backBackground: CardBackgrounds.white,
              showShadow: true,
            ),
            SizedBox(
              height: 60,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: TextFormField(
                    decoration: InputDecoration(hintText: "Bank Name"),
                    maxLength: 19,
                    onChanged: (String bankName) {
                      setState(() {
                        bankName = bankName;
                        getBankName(bankName);
                      });
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: TextFormField(
                    decoration: InputDecoration(hintText: "Card Number"),
                    maxLength: 19,
                    onChanged: (String cardNo) {
                      setState(() {
                        cardNumber = cardNo;
                        getCardNo(cardNo);
                      });
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: TextFormField(
                    decoration: InputDecoration(hintText: "Card Expiry"),
                    maxLength: 5,
                    onChanged: (String exp) {
                      setState(() {
                        expiryDate = exp;
                        getExpDate(exp);
                      });
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: TextFormField(
                    decoration: InputDecoration(hintText: "Card Holder Name"),
                    onChanged: (String holderName) {
                      setState(() {
                        cardHolderName = holderName;
                        getCardName(holderName);
                      });
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                  child: TextFormField(
                    decoration: InputDecoration(hintText: "CVV"),
                    maxLength: 3,
                    onChanged: (String cvv) {
                      setState(() {
                        cvv = cvv;
                        getSvp(cvv);
                      });
                    },
                    focusNode: _focusNode,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    RaisedButton(
                        child: new Text('Cancel'),
                        onPressed: () {
                          Navigator.pop(context);
                          //createDate();
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(builder: (context) => payInfo()),
                          // );
                          // {
                          //   if (_formKey.currentState.validate()) {}
                          // }
                        }),
                    RaisedButton(
                        child: new Text('Add'),
                        onPressed: () {
                          dRef.child('card').child(userData['emailDot']).push().set(
                              {
                                'bankName' : bankName,
                                'number' : cardNumber,
                                'expiry' : expiryDate,
                                'name' : cardHolderName,
                                'cvv' :cvv
                              }
                          );
                          //createDate();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => PaymentMethods(userData)),
                          );
                          // {
                          //   if (_formKey.currentState.validate()) {}
                          // }
                        }),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
