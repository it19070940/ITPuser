import 'package:firebase_database/firebase_database.dart';
import 'package:first_app/cart.dart';
import 'package:first_app/models/menu.dart';
import 'package:first_app/product.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Menu extends StatefulWidget {
  String canteenName,userID;
  Map userData;
  Menu(this.canteenName,this.userData);
  @override
  _MenuState createState() => _MenuState(canteenName,userData);
}

class _MenuState extends State<Menu> {
  String canteenName,userID;
  Map userData;
  _MenuState(this.canteenName,this.userData);
  String pname;
  String pprice;

  Map products = {};
  List productNames=[];
  DatabaseReference dRef = FirebaseDatabase.instance.reference();
  @override
  void initState() {
    userID = userData['emailDot'];
    dRef.child('products').child(canteenName).once().then((value) {
      Map val = value.value;
      setState(() {
        products =  val;
        val.forEach((key, value) {
          productNames.add(key);
        });
      });

      print(val);
    });
    // TODO: implement initState
    super.initState();
  }
  @override
  CreateTodos() {

    Map<String, String> Cart = {"productName": pname, "productPrice": pprice};

  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.redAccent,
        centerTitle: true,
        title: new Text('Deliceus'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.shopping_cart),
            color: Colors.white,
            onPressed: () {
              Navigator.of(context).pushReplacement(new CupertinoPageRoute(
                  builder: (BuildContext context) => Mycart(canteenName,userData)));
            },
          )
        ],
      ),
      //body:
      //Center(
      // color: Colors.grey[200],

      // ),
      //drawer: Drawer(),*/

      body: ListView.builder(
// scrollDirection: Axis.horizontal,
          itemCount: products.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: InkWell(
                        splashColor: Colors.blue.withAlpha(30),
                        onTap: () {
                          Navigator.of(context).push(
                              new CupertinoPageRoute(
                                  builder: (BuildContext context) =>
                                      Prdoucts()));
                        },
                        child: Container(
                          height: 132,
                          child: Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 18.0),
                                  child: Container(
// child: NetworkImage(products[index].imageLink),
                                      child: Image.network(
                                        products[productNames[index]]['imageLink'],
                                        height: 100,
                                        width:100,
                                      )),
                                ),
                                Padding(
                                  padding:
                                  const EdgeInsets.all(14.0),
                                  child: Column(
                                    children: [
                                      Text('Product Name:'),
                                      new Text(
                                        productNames[index],
                                        style: TextStyle(
                                            fontWeight:
                                            FontWeight.bold),
                                      ),
                                      Text('Product Price:'),
                                      new Text(
                                        '${products[productNames[index]]['price']}',
                                        style: TextStyle(
                                            fontWeight:
                                            FontWeight.bold),
                                      ),

//Spacer(),
                                    ],
                                  ),
                                ),
                                Spacer(),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 60.0),
                                  child: FlatButton(
                                    color: Colors.green,
                                    textColor: Colors.white,
                                    disabledColor: Colors.grey,
                                    disabledTextColor: Colors.black,
                                    padding: EdgeInsets.all(3.0),
                                    splashColor: Colors.green,
                                    onPressed: () {
                                      dRef.child('cart').child(canteenName).child(userID).push().set({
                                        'itemName' : '${productNames[index]}',
                                        'price' : '${products[productNames[index]]['price']}'
                                      });
                                    },
                                    child: Text(
                                      "ADD TO CART",
                                      style:
                                      TextStyle(fontSize: 12.0),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }
}


