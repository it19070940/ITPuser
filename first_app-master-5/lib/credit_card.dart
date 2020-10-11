import 'dart:math';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'extra/card_type.dart';
import 'extra/helper.dart';
import 'style/card_back_layout.dart';
import 'style/card_front_layout.dart';

class CreditCard extends StatefulWidget {
  final String cardNumber;
  final String cardExpiry;
  final String cardHolderName;
  final String bankName;
  final String cvv;
  final Color frontTextColor;
  final Color backTextColor;
  final bool showBackSide;
  final Widget frontBackground;
  final Widget backBackground;
  final Widget frontLayout;
  final Widget backLayout;
  final bool showShadow;
  final CardType cardType;
  final double width;
  final double height;
  final Color bgcolor;

  CreditCard(
      {Key key,
      this.cardNumber,
      this.cardExpiry,
      this.cardHolderName,
      this.bankName,
      this.cvv,
      this.showBackSide = false,
      @required this.frontBackground,
      @required this.backBackground,
      this.cardType,
      this.frontLayout,
      this.backLayout,
      this.frontTextColor = Colors.white,
      this.backTextColor = Colors.black,
      this.bgcolor = Colors.pink,
      this.showShadow = false,
      this.width,
      this.height})
      : assert(frontBackground != null),
        assert(backBackground != null),
        super(key: key);

  @override
  _CreditCardState createState() => _CreditCardState();
}

class _CreditCardState extends State<CreditCard>
    with SingleTickerProviderStateMixin {
  double cardWidth;
  double cardHeight;
  AnimationController _controller;
  Animation<double> _moveToBack;
  Animation<double> _moveToFront;

  @override
  void initState() {
    _controller = new AnimationController(
        duration: new Duration(milliseconds: 1000), vsync: this);

    _moveToBack = new TweenSequence<double>([
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.0, end: pi / 2)
              .chain(CurveTween(curve: Curves.easeInBack)),
          weight: 50.0),
      TweenSequenceItem<double>(
          tween: ConstantTween<double>(pi / 2), weight: 50.0)
    ]).animate(_controller);

    _moveToFront = new TweenSequence<double>(
      [
        TweenSequenceItem<double>(
          tween: ConstantTween<double>(pi / 2),
          weight: 50.0,
        ),
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: -pi / 2, end: 0.0)
              .chain(CurveTween(curve: Curves.easeOutBack)),
          weight: 50.0,
        ),
      ],
    ).animate(_controller);

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    widget.width == null
        ? cardWidth = MediaQuery.of(context).size.width - 40
        : cardWidth = widget.width;
    widget.height == null
        ? cardHeight = (cardWidth / 2) + 10
        : cardHeight = widget.height;

    if (widget.showBackSide) {
      _controller.forward().orCancel;
    } else {
      _controller.reverse().orCancel;
    }

    return Center(
      child: Stack(
        children: <Widget>[
          AwesomeCard(
            animation: _moveToBack,
            child: _buildFrontCard(),
          ),
          AwesomeCard(
            animation: _moveToFront,
            child: _buildBackCard(),
          ),
        ],
      ),
    );
  }

  Widget _buildFrontCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      width: cardWidth,
      height: cardHeight,
      decoration: BoxDecoration(
        boxShadow: widget.showShadow
            ? [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 12.0,
                  spreadRadius: 0.2,
                  offset: Offset(
                    3.0, // horizontal, move right 10
                    3.0, // vertical, move down 10
                  ),
                )
              ]
            : [],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Stack(
          children: <Widget>[
            // Background for card
            widget.frontBackground,

            // Front Side Layout
            widget.frontLayout ??
                CardFrontLayout(
                        bankName: widget.bankName,
                        cardNumber: widget.cardNumber,
                        cardExpiry: widget.cardExpiry,
                        cardHolderName: widget.cardHolderName,
                        cardTypeIcon: getCardTypeIcon(
                            cardType: widget.cardType,
                            cardNumber: widget.cardNumber),
                        cardHeight: cardHeight,
                        cardWidth: cardWidth,
                        // bgcolor:widget.c
                        textColor: widget.frontTextColor)
                    .layout1(),
          ],
        ),
      ),
    );
  }

  Widget _buildBackCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      width: cardWidth,
      height: cardHeight,
      decoration: BoxDecoration(
        boxShadow: widget.showShadow
            ? [
                BoxShadow(
                  color: Colors.black45,
                  blurRadius: 12.0,
                  spreadRadius: 0.2,
                  offset: Offset(
                    3.0, // horizontal, move right 10
                    3.0, // vertical, move down 10
                  ),
                )
              ]
            : [],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Stack(
          children: <Widget>[
            // Background for card
            widget.backBackground,

            // Back Side Layout
            widget.backLayout ??
                CardBackLayout(
                        cvv: widget.cvv,
                        width: cardWidth,
                        height: cardHeight,
                        color: widget.backTextColor)
                    .layout1()
          ],
        ),
      ),
    );
  }
}

class AwesomeCard extends StatelessWidget {
  final Animation<double> animation;
  final Widget child;

  AwesomeCard({@required this.animation, @required this.child});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget child) {
        return Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(animation.value),
          alignment: Alignment.center,
          child: this.child,
        );
      },
    );
  }
}

class card extends StatefulWidget {
  final String cardNumber;
  final String cardExpiry;
  final String cardHolderName;
  final String bankName;
  final String cvv;
  final Color frontTextColor;
  final Color backTextColor;
  final bool showBackSide;
  //final Widget frontBackground;
  //final Widget backBackground;
  final Widget frontLayout;
  final Widget backLayout;
  final bool showShadow;
  final CardType cardType;
  final double width;
  final double height;

  card(
      {Key key,
      this.cardNumber,
      this.cardExpiry,
      this.cardHolderName,
      this.bankName,
      this.cvv,
      this.showBackSide = false,
      //@required this.frontBackground,
      //@required this.backBackground,
      this.cardType,
      this.frontLayout,
      this.backLayout,
      this.frontTextColor = Colors.white,
      this.backTextColor = Colors.black,
      this.showShadow = false,
      this.width,
      this.height});
  //  : assert(frontBackground != null),
  //   assert(backBackground != null),
  //     super(key: key);

  @override
  _cardState createState() => _cardState();
}

class _cardState extends State<card> with SingleTickerProviderStateMixin {
  double cardWidth;
  double cardHeight;
  AnimationController _controller;
  Animation<double> _moveToBack;
  Animation<double> _moveToFront;

  static QuerySnapshot querySnapshot;

  getDriversList() async {
    querySnapshot =
        await Firestore.instance.collection('Payment').getDocuments();
    return await Firestore.instance.collection('Payment').getDocuments();
  }

  @override
  Widget build(BuildContext context) {
    widget.width == null
        ? cardWidth = MediaQuery.of(context).size.width - 40
        : cardWidth = widget.width;
    widget.height == null
        ? cardHeight = (cardWidth / 2) + 10
        : cardHeight = widget.height;
    return Container(
      //child: Stack(
      //children: <Widget>[
      //  AwesomeCard(
      //animation: _moveToBack,
      child: _buildFrontCard(),
      // ),
      //],
      //),
    );
  }

  Widget _buildFrontCard() {
    if (querySnapshot != null) {
      return ListView.builder(
          primary: false,
          itemCount: querySnapshot.documents.length,
          padding: EdgeInsets.all(12),
          itemBuilder: (context, i) {
            child:
            Container(
                key: ObjectKey(querySnapshot.documents.elementAt(i)),

                // return Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                width: cardWidth,
                height: cardHeight,
                decoration: BoxDecoration(
                  boxShadow: widget.showShadow
                      ? [
                          BoxShadow(
                            color: Colors.black,
                            blurRadius: 12.0,
                            spreadRadius: 0.2,
                            offset: Offset(
                              3.0, // horizontal, move right 10
                              3.0, // vertical, move down 10
                            ),
                          )
                        ]
                      : [],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Container(
                    //children: <Widget>[
                    color: (i % 2 == 0) ? Colors.red : Colors.green,
                    // Background for card
                    //  widget.frontBackground,
                    child: Stack(
                      children: <Widget>[
                        // Front Side Layout
                        widget.frontLayout ??
                            CardFrontLayout(
                                    bankName: widget.bankName,
                                    cardNumber: widget.cardNumber,
                                    cardExpiry: widget.cardExpiry,
                                    cardHolderName: widget.cardHolderName,
                                    cardTypeIcon: getCardTypeIcon(
                                        cardType: widget.cardType,
                                        cardNumber: widget.cardNumber),
                                    cardHeight: cardHeight,
                                    cardWidth: cardWidth,
                                    textColor: widget.frontTextColor)
                                .layout1(),
                      ],
                    ),
                  ),
                ));
          });
    }
  }
}
