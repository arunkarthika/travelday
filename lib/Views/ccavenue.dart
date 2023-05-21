import 'dart:async';

import 'package:cc_avenue/cc_avenue.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class CCAVENE extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<CCAVENE> {
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  /// [initPlatformState] this calls the [cCAvenueInit]
  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      CcAvenue.cCAvenueInit(
          transUrl: 'https://secure.ccavenue.com/transaction/initTrans',
          accessCode: 'AVUJ49KD90AY38JUYA',
          amount: '10',
          cancelUrl: 'http://5.104.230.133/merchant/ccavResponseHandler.jsp',
          currencyType: 'INR',
          merchantId: '2308157',
          orderId: '874834',
          redirectUrl: 'http://5.104.230.133/merchant/ccavResponseHandler.jsp',
          rsaKeyUrl: 'https://travelday.in/getRSA.jsp'
      );
    } on PlatformException {
      print('PlatformException');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('CC Avenue Payment page'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: (){
              initPlatformState();
            }, child: Text('Payment Gateway'),
          ),
        ),
      ),
    );
  }
}