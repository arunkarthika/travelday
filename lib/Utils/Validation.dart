import 'dart:io';



import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';
import 'package:travelday/Views/LoginScreen.dart';
import 'package:url_launcher/url_launcher.dart';

import 'UserStore.dart';

//import 'DatabaseHelper.dart';

class CheckConnection {
  static  void showProgressDialog(BuildContext context, SimpleFontelicoProgressDialogType type, String text) async{
    SimpleFontelicoProgressDialog? _dialog;
    if(_dialog == null) {
      _dialog = SimpleFontelicoProgressDialog(context: context, barrierDimisable:  true,);
    }
    if(type == SimpleFontelicoProgressDialogType.custom) {
      _dialog.show(message: text, type: type, width: 150.0, height: 75.0, loadingIndicator: Text('C', style: TextStyle(fontSize: 24.0),));
    } else {
      _dialog.show(message: text, type: type, horizontal: true, width: 150.0, height: 75.0, hideText: true, indicatorColor: Color(0xFF013B46));
    }
    // await Future.delayed(Duration(seconds: 1));
    // _dialog!.hide();
  }
  static void hideDialog(BuildContext context) async{
    Navigator.of(context,rootNavigator: true).pop();
  }

  static Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;

    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }
  static void exitApplication(BuildContext context)
  {
    Alert(
      context: context,
      type: AlertType.warning,
      style: AlertStyle(
        isCloseButton: false,
        isOverlayTapDismiss: false,
      ),
      title: "Staff Commute Gate Attendance.",
      desc: "Are you sure want to exit?",
      buttons: [
        DialogButton(
          child: Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => SystemNavigator.pop(),
          color: Color(0xFF283593),
        ),
        DialogButton(
          child: Text(
            "Cancel",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          gradient: LinearGradient(colors: [
            Colors.grey,
            Colors.grey
          ]),
        )
      ],
    ).show();
  }

  static void errorAlertDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context){
        return CupertinoAlertDialog(
          title: Text("Staff commute gate gttendance"),
          content: Text(message),
          actions: <Widget>[
            CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: () {
                  // Navigator.pop(context);
                  Navigator.of(context, rootNavigator: true).pop("Ok");
                },
                child: Text("Ok", style: TextStyle(color: Colors.red),)
            ),
          ],
        );

      },
    );
  }

  static void showErrorSnackBar(BuildContext buildContext, String s)
  {
    final snackBar = SnackBar(
      backgroundColor: Colors.red,
      content: Container(
          color: Colors.red,
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.error,color: Colors.white,),
              SizedBox(width: 10,),
              Expanded(
                child: Container(
                  //color: Colors.blue,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Error",style: TextStyle(fontSize: 16,color: Colors.white),),
                      SizedBox(height: 10,),
                      Expanded(child: Text(s,style: TextStyle(fontSize: 16,color: Colors.white),)),
                      //Text(s!,style: TextStyle(fontSize: 16,color: Colors.white),)
                    ],
                  ),
                ),
              ),
            ],
          )
      ),

      action: SnackBarAction(
        label: '',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );
    // Find the ScaffoldMessenger in the widget tree
    // and use it to show a SnackBar.
    ScaffoldMessenger.of(buildContext).showSnackBar(snackBar);
  }
  static void showSuccessmessage(GlobalKey<ScaffoldState> scafkey,
      String message) {
    ScaffoldMessenger.of(scafkey.currentContext!).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 3),
        backgroundColor: Colors.green,
      ),
    );
  }
}
class Validation{

  static void showSuccessSnackBar(BuildContext context, String? s)
  {
    final snackBar = SnackBar(
      backgroundColor: Colors.green,

      content: Container(
          color: Colors.green,
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image(image: AssetImage("images/checkcircle.png"),height: 20,width: 20,color: Colors.white,),
              SizedBox(width: 10,),
              //Text(s!),
              Expanded(
                child: Container(
                  //color: Colors.blue,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      //Text("Success",style: TextStyle(fontSize: 16,color: Colors.white),),
                      //SizedBox(height: 10,),
                      Text(s!,style: TextStyle(fontSize: 16,color: Colors.white),),
                    ],
                  ),
                ),
              ),

            ],
          )

      ),

      action: SnackBarAction(
        label: '',
        onPressed: () {
          // Some code to undo the change.
        },
      ),

    );

    // Find the ScaffoldMessenger in the widget tree
    // and use it to show a SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static void showErrormessage(GlobalKey<ScaffoldState> scafkey,
      String message) {
    ScaffoldMessenger.of(scafkey.currentContext!).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 3),
        backgroundColor: Color(0xFF013B46),
      ),
    );
  }
  static void showNointernetErrormessage(GlobalKey<ScaffoldState> scafkey,
      String message) {
    ScaffoldMessenger.of(scafkey.currentContext!).showSnackBar(
      SnackBar(
        content: Text(message,style: TextStyle(color: Colors.black,fontSize: 16),textAlign: TextAlign.center,),
        duration: Duration(seconds: 3),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

 /* static ProgressDialog Progressdialog(GlobalKey<ScaffoldState> scafkey)
  {
    ProgressDialog pr = ProgressDialog(scafkey.currentContext,type: ProgressDialogType.Normal,
      isDismissible: false,);
    pr.style(
        message: 'Processing...',
        borderRadius: 10.0,

        backgroundColor: Colors.white,
        progressWidget: CircularProgressIndicator(),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600)
    );
    return pr;
  }*/

  static Future<bool> checkConnection() async{

    ConnectivityResult connectivityResult = await (new Connectivity().checkConnectivity());

    debugPrint(connectivityResult.toString());

    if ((connectivityResult == ConnectivityResult.mobile) || (connectivityResult == ConnectivityResult.wifi)){
      return Future<bool>.value(true);
    } else {
      return Future<bool>.value(false);
    }

  }

  static void errorAlertDialog(BuildContext context, String message) {
    showDialog(
        context: context,
        builder: (BuildContext context){
          return CupertinoAlertDialog(
            title: Text("Travel Day"),
            content: Text(message),
            actions: <Widget>[
              CupertinoDialogAction(
                  isDefaultAction: true,
                  onPressed: () {
                    // Navigator.pop(context);
                    Navigator.of(context, rootNavigator: true).pop("Ok");

                  },
                  child: Text("Ok", style: TextStyle(color: Colors.red),)
              ),

            ],
          );

        },
        );
  }
  static void showIOSAlertDialog(BuildContext context, GlobalKey<ScaffoldState> globalkey) {
    showDialog(
        context: context,
        builder: (BuildContext context){
          return CupertinoAlertDialog(
            title: Text("Log out?"),
            content: Text("Are you sure you want to log out?"),
            actions: <Widget>[
              CupertinoDialogAction(
                  isDefaultAction: true,
                  onPressed: () {
                    //Navigator.pop(context);
                    Navigator.of(globalkey.currentState!.context, rootNavigator: true).pop("Cancel");
                  },
                  child: Text("Cancel", style: TextStyle(color: Colors.red),)
              ),
              CupertinoDialogAction(
                  textStyle: TextStyle(color: Colors.green),
                  isDefaultAction: true,
                  onPressed: () async {
                    //final dbHelper = DatabaseHelper.instance;
                   // dbHelper.deleteallscandata();
                    var pref= UserStore();
                    pref.setUserLoggedIn("");
                    SharedPreferences prefs = await SharedPreferences
                        .getInstance();
                    prefs.clear();
                    // Navigator.pop(context);
                    /*SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.remove('isLogin');
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (BuildContext ctx) => LoginScreen()));*/
                    Navigator.of(globalkey.currentState!.context, rootNavigator: true).pop("Log out");
                    Navigationscreen(globalkey.currentState!.context, LoginScreen());

                  },
                  child: Text("Log out")
              ),
            ],
          );
        }

        );
  }
  static void logOut(BuildContext context, GlobalKey<ScaffoldState> globalkey) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(

          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('images/yellowcircle.jpg', height:70,width:70,),
            ],
          ),
        content: Text('Are you sure you want to log out?',textAlign:TextAlign.center,style: TextStyle(),),
         actions: [
           Row(
             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
             children: [


                 //color: Colors.red,
                  ElevatedButton(
                   style: ElevatedButton.styleFrom( shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(5.0)),
                     // height: 40,
                     // minWidth: 70,
                     backgroundColor: Colors.red,),
                   child: Text('No',style: TextStyle(color: Colors.white),),
                   onPressed: () {
                     Navigator.of(context).pop(); // Dismiss the Dialog
                   },
                 ),

               TextButton(
                 style: TextButton.styleFrom(
                   shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(5.0)),
                   // height: 40,
                   // minWidth: 70,
                   backgroundColor: Colors.green,
                 ),

                 child: Text('Yes',style: TextStyle(color: Colors.white),),
                 onPressed: () async {
                   //final dbHelper = DatabaseHelper.instance;
                   //dbHelper.deleteallscandata();
                   //dbHelper.deleteallrows();
                   Navigator.of(context).pop();
                   SharedPreferences prefs = await SharedPreferences
                       .getInstance();
                   prefs.clear();

                   //Navigator.of(context).pop(); // Navigate to login
                   Navigationscreen(globalkey.currentState!.context, LoginScreen());

                 },
               ),

             ],
           ),
           SizedBox(
             height: 20,
           )

         ],
        );
      },
    );
  }

  static void onAlertButtonsPressed(context) async {
    UserStore userAuth=  UserStore();
    //final dbHelper = DatabaseHelper.instance;
    //String? str_emiail=  await userAuth.getEmployeeemail();
   // String? str_employeeid = await userAuth.getEmployeeid();
    //print("Str_email====="+str_emiail!);
    //var email=str_emiail.replaceAll("@", "~");
    //print("EmployeeEmailid====$email");
    //print("Str_employeeid====="+str_employeeid!);

    SharedPreferences preferences = await SharedPreferences.getInstance();
    Alert(
      context: context,
      type: AlertType.warning,
      style: AlertStyle(
        isCloseButton: false,
        isOverlayTapDismiss: false,
      ),
      title: "Travel Day",
      desc: "Are you sure want to logout?",
      buttons: [
        DialogButton(
          child: Text(
            "NO",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          onPressed: () => Navigator.pop(context),
          color: Colors.grey,
        ),
        DialogButton(
          child: Text(
            "Logout ",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          onPressed: () async {

            Navigator.pop(context);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) =>  LoginScreen()),
            );
            preferences.clear();
            //await FirebaseMessaging.instance.unsubscribeFromTopic(email).then((value) => print('Email TopicUnSubscribed'));
            //await FirebaseMessaging.instance.unsubscribeFromTopic(str_employeeid).then((value) => print('${str_employeeid} TopicUnSubscribed'));
            //dbHelper.deleteallboardingrows();
            //dbHelper.deleteallsafedroprows();
          },
          color:  Color(0xFF013B46),
          /*gradient: LinearGradient(colors: [
            Color.fromRGBO(116, 116, 191, 1.0),
            Color.fromRGBO(52, 138, 199, 1.0),
          ]),*/
        )
      ],
    ).show();
  }
  static   TokenexpireAlert(scafkey, String? str_message) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    Alert(
  context: scafkey.currentState!.context,
  title: "Employee Security",
  desc: str_message,
      style: AlertStyle(
        isCloseButton: false,
        isOverlayTapDismiss: false,
      ),
  //image: Image.asset("images/checkcircle.png",color: Colors.green,),
  buttons: [
  DialogButton(
  child: Text(
  "OK",
  style: TextStyle(color: Colors.white, fontSize: 20),
  ),
  onPressed: (){
    preferences.clear();
  Navigator.pop(scafkey.currentState!.context);
  //exit(0);
  //SystemNavigator.pop();
  Navigator.pushReplacement(
    scafkey.currentState!.context,
  MaterialPageRoute(builder: (context) => LoginScreen()),
  );

  } ,
  color: Color(0xFF283593),
  radius: BorderRadius.circular(0.0),
  ),
  ],
  ).show();
}
  static openDialPad(String phoneNumber) async {
    Uri url = Uri(scheme: "tel", path: phoneNumber);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      print("Can't open dial pad.");
    }
  }

  static   ValidationAlert(context, String? str_message) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    Alert(
      context: context,
      title: "Travel Day",
      desc: str_message,
      style: AlertStyle(
        isCloseButton: false,
        isOverlayTapDismiss: false,
      ),

      //image: Image.asset("images/checkcircle.png",color: Colors.green,),
      buttons: [
      /*DialogButton(
      color: Colors.grey,
      onPressed: (){
        Navigator.pop(context);
      },
        child: Text(
        "Close",
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
       ),*/
        DialogButton(
          child: Text(
            "Call",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: (){
            //preferences.clear();
            Navigator.pop(context);
            openDialPad("8977485285");

          } ,
          color: Color(0xFF013B46),
          radius: BorderRadius.circular(0.0),
        ),
      ],
    ).show();
  }
  static void Navigationscreen(BuildContext context,Widget widget)
  {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) =>widget),
    );
  }
}
/*
return AlertDialog(

          title: Text('Are you sure?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('We will be redirected to login page.'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the Dialog
              },
            ),
            FlatButton(
              child: Text('Yes'),
              onPressed: () async {
                Navigator.of(context).pop();
                 SharedPreferences prefs = await SharedPreferences
                    .getInstance();
                prefs.clear();
                //Navigator.of(context).pop(); // Navigate to login
                Navigationscreen(globalkey.currentState!.context, LoginScreen());
              },
            ),
          ],
        );
 */