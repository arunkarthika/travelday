

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/services.dart';
import 'package:travelday/Utils/UserStore.dart';
import 'package:travelday/Views/DashboardScreen.dart';

import 'LoginScreen.dart';
import 'ProfileScreen.dart';

//import 'dashboardscreen.dart';
//import 'loginscreen.dart';



class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  UserStore userAuth= UserStore();
  String? status,token;
  var loginstatus;

  static const colorizeColors = [
    Colors.white,
    Colors.blue,
    Colors.yellow,
    Colors.red,
  ];

  static const colorizeTextStyle = TextStyle(
    fontSize: 25.0,
    fontFamily: 'Horizon',
  );
  @override
  void initState() {
    super.initState();
    getLoginStatus();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.bottom]);
    Future.delayed(const Duration(milliseconds: 5000), () {
          // Here you can write your code
      if(loginstatus)
        {
          //DashBoardScreen LoginScreen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) =>  DashBoardScreen()),
          );
        }else
          {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          }


    });
  }
  Future<void> getLoginStatus() async
  {

     loginstatus= await userAuth.getUserLoggedIn();
     token= await userAuth.getToken();
     print("loginstatus------>>>>$loginstatus");
     print("token--------->>>>>>$token");

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: Stack(
          children: [
            Container(
              decoration:const BoxDecoration(
                gradient: LinearGradient(
                  //begin: Alignment.topLeft,
                  //end: Alignment.topRight,
                    colors: [Color(0xFF013B46),Color(0xFF013B46)]
                ),

              ),
              child:  Center(
                  child: Image.asset("images/app_icon.png") ,



              ),
            ),


          ],
        )

    );
  }
}
