import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MyWebView extends StatelessWidget {
  final num amount;
  final String redirectUrl;
  final String name;
  final String address;
  final String city;
  final String telph;
  final String delName;
  final String delAddress;
  final String delState;
  final String delPh;
  final String billingEmail;

  const MyWebView({super.key, required this.amount, required this.redirectUrl, required this.name, required this.address, required this.city, required this.telph, required this.delName, required this.delAddress, required this.delState, required this.delPh, required this.billingEmail});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pay Now'),
      ),
      body: WebView(
        initialUrl: 'https://payment.travelday.in/#/viewcart?merchant_id=2308157&order_id=64654&currency=INR&amount=$amount&redirect_url=$redirectUrl&cancel_url=$redirectUrl&language=EN&billing_name=$name&billing_address=$address&billing_city=$city&billing_state=MH&billing_zip=pincode&billing_country=India&billing_tel=$telph&delivery_name=$delName&delivery_address=$delAddress&delivery_city=$delState&delivery_state=$delState&delivery_zip=$delAddress&delivery_country=India&delivery_tel=$delPh&billing_email=$billingEmail',
        javascriptMode: JavascriptMode.unrestricted,

      ),
    );
  }
}
