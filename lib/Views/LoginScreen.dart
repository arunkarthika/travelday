import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:travelday/Modal/ApiResponse.dart';
import 'package:travelday/Services/ApiServices.dart';
import 'package:travelday/Utils/Validation.dart';
import 'package:travelday/Views/OtpVerification.dart';
import 'package:travelday/di/di.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  final GlobalKey<ScaffoldState>_scafkey=GlobalKey<ScaffoldState>();
  final FocusNode _emailFocus = FocusNode();
  final RoundedLoadingButtonController _btnController1 = RoundedLoadingButtonController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  Future<dynamic> getLogin(String mobile, BuildContext context) async {

    Map map = {
      "mobile_no":mobile,
    };

    final loginresponse = locator.get<ApiService>().apiRequest("sendotp", map);
    return loginresponse.then((res) async {

      var failureresponse=jsonDecode(res.toString());
      String str_status=failureresponse['status'];
      if(str_status=="failure")
      {
        _btnController1.stop();
        String str_message=failureresponse['message'];
        if(str_message=="Token expired.")
        {
          try{
            //CheckConnection.RenewalToken(token!);
          }catch(e)
          {
            print(e);
          }


        }else{

          if(Platform.isAndroid)
          {
            Validation.showErrormessage(_scafkey, str_message);
          }else
          {
            Validation.errorAlertDialog(context,str_message);
          }

        }
        CheckConnection.hideDialog(_scafkey.currentState!.context);
        //CheckConnection.onAlertButtonPressed(_scaffoldkey.currentState!.context,str_message);
      } else
      {
        try{
          //print("Rsponse"+res.toString());
          //var map =jsonDecode(res.toString());
          //print("Rsponse Status====="+map["status"]);
          if(str_status=="success")
          {
            _btnController1.stop();
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => OtpVerfication(str_mobilenumber: mobile,)),);

          }
          // map[""]

        }catch(ex)
        {
          // pr.hide();
          //Validation.Progressdialog(_scafkey).hide();
          /* if(Platform.isAndroid)
            this._showToast(context, "Email must be a valid email");
            else if(Platform.isIOS)
            Validation.errorAlertDialog(context, "Email must be a valid email");*/
          print("enterException");
        }
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scafkey,
      body: Container(
        //color: Colors.yellow,
        child: Column(

          children: [
            Expanded(
              flex: 4, child: Container(
              width: MediaQuery.of(context).size.width,
              //height: 100,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage("images/login_logo.png"),
                ),
              ),
            )
            ),
            Expanded(
                flex: 3, child: Container(
                alignment: Alignment.center,
                 //color: Colors.green,
                 child:SingleChildScrollView(
                   child: Center(
                     child: Container(
                       //color: Colors.red,

                       //height: 100,
                       child: Column(
                         mainAxisSize: MainAxisSize.max,
                         crossAxisAlignment: CrossAxisAlignment.center,
                         children: [
                           SizedBox(
                               width: 300,
                               height: 40,
                               child: TextField(
                                  controller:emailController,
                                   autocorrect: true,
                                   maxLength: 10,
                                   keyboardType: TextInputType.number,
                                   cursorColor: Color(0xFF013B46),
                                   decoration: InputDecoration(
                                     counterText: "",
                                     hintText: 'Mobile Number',
                                     hintStyle: TextStyle(color: Color(0xFF013B46)),
                                     filled: true,
                                     prefixIcon: Icon(Icons.phone_android,size: 20,color: Color(0xFF013B46),),
                                     fillColor: Colors.white,
                                     contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                     enabledBorder: OutlineInputBorder(

                                       borderRadius:
                                       BorderRadius.all(Radius.circular(5.0)),
                                       borderSide:
                                       BorderSide(color: Color(0xFF013B46), width: 2),
                                     ),
                                     focusedBorder: OutlineInputBorder(
                                       borderRadius:
                                       BorderRadius.all(Radius.circular(5.0)),
                                       borderSide: BorderSide(color: Color(0xFF013B46),width: 2),
                                     ),
                                   ))
                           ),
                           SizedBox(height: 15,),
                           RoundedLoadingButton(
                               successIcon: Icons.check_circle,
                               height: 40,
                               width: 300,
                               successColor: Colors.green,
                               failedIcon: Icons.error,
                               borderRadius: 5,
                               color:Color(0xFF013B46),
                               child:Text("Get OTP",style: TextStyle(color: Colors.white,fontSize: 18),),
                               controller: _btnController1,
                               onPressed: () async {
                                 var connection= await CheckConnection.check();

                                 if(connection)
                                 {
                                   FocusManager.instance.primaryFocus?.unfocus();
                                   print("email:"+emailController.text);
                                   // print("password:"+passwordController.text);

                                     if(emailController.text.length==0||emailController.text.isEmpty)
                                     {

                                       _btnController1.stop();
                                       //print("Please enter email:");
                                       if(Platform.isAndroid)
                                       {
                                         Validation.showErrormessage(_scafkey,'Please enter  mobile number!');
                                       }else if(Platform.isIOS)
                                       {
                                         Validation.errorAlertDialog(context,'Please enter  mobile number!');
                                       }
                                     } else if(RegExp(r'(^(?:(?:\+|0{0,2})91(\s*[\-]\s*)?|[0]?)?[6789]\d{9}$)').hasMatch(emailController.text.toString()))
                                     {
                                       //Validation.showErrormessage(_scafkey,'');
                                       //final signature=await SmsAutoFill().getAppSignature;
                                       // print(signature);

                                       //CheckConnection.showProgressDialog(_scafkey.currentState!.context, SimpleFontelicoProgressDialogType.phoenix, 'Phoenix');
                                      // getlogindetails(context);
                                       //print("Please enter password:");

                                       getLogin(emailController.text.toString(), context);

                                     }
                                     else{
                                       _btnController1.stop();
                                       if(Platform.isAndroid)
                                       {
                                         Validation.showErrormessage(_scafkey,'Please enter valid mobile number!');
                                       }else if(Platform.isIOS)
                                       {
                                         Validation.errorAlertDialog(context,'Please enter valid mobile number!');
                                       }

                                       /*if(emailController.tex t=="paramesh"&&passwordController.text=="admin123")
                                    {
                                      _userAuth.setUserLoggedIn("success");
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(builder: (context) => VehicleListScreen()),
                                    );
                                  }*/
                                     //Validation.Progressdialog(_scafkey).show();

                                   }

                                 }else{
                                   _btnController1.stop();
                                   //CheckConnection.showErrorSnackBar(_scafkey.currentState!.context,"No Internet Connection!");
                                   Validation.showNointernetErrormessage(_scafkey,'No internet connection.');

                                 }

                                 //CheckConnection.showDialog(_scaffoldkey.currentState!.context, SimpleFontelicoProgressDialogType.phoenix, 'Phoenix');

                               }
                             // => _doSomething(_btnController1),
                           ),
                           /*Container(
                             height: 40,
                             width: 300,
                             decoration: BoxDecoration(
                               //color: Color(0xff066990),
                                 gradient: LinearGradient(
                                   colors: [Color(0xFF013B46),Color(0xFF013B46)],
                                   //begin: FractionalOffset.center,
                                   //end: FractionalOffset.bottomLeft,
                                 ),
                                 borderRadius: BorderRadius.circular(5)),
                             child: FlatButton(
                               onPressed: () async {
                                 FocusManager.instance.primaryFocus?.unfocus();
                                 // Navigator.push(
                                 //     context, MaterialPageRoute(builder: (_) => HomePage()));
                                 *//*Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => SchedulePage()));*//*

                                 print("email:"+emailController.text);
                                // print("password:"+passwordController.text);

                                 if(emailController.text.length==0||emailController.text.isEmpty)
                                 {


                                   //print("Please enter email:");
                                   if(Platform.isAndroid)
                                   {
                                     Validation.showErrormessage(_scafkey,'Please enter  mobile number!');
                                   }else if(Platform.isIOS)
                                   {
                                     Validation.errorAlertDialog(context,'Please enter  mobile number!');
                                   }
                                 } else if(RegExp(r'(^(?:(?:\+|0{0,2})91(\s*[\-]\s*)?|[0]?)?[6789]\d{9}$)').hasMatch(emailController.text.toString()))
                                 {
                                   //Validation.showErrormessage(_scafkey,'');
                                   //final signature=await SmsAutoFill().getAppSignature;
                                  // print(signature);

                                   CheckConnection.showProgressDialog(_scafkey.currentState!.context, SimpleFontelicoProgressDialogType.phoenix, 'Phoenix');
                                   getlogindetails(context);
                                   //print("Please enter password:");
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => OtpVerfication()),);

                                     }
                                 else{
                                   if(Platform.isAndroid)
                                   {
                                     Validation.showErrormessage(_scafkey,'Please enter valid mobile number!');
                                   }else if(Platform.isIOS)
                                   {
                                     Validation.errorAlertDialog(context,'Please enter valid mobile number!');
                                   }

                                   *//*if(emailController.tex t=="paramesh"&&passwordController.text=="admin123")
                                  {
                                    _userAuth.setUserLoggedIn("success");
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (context) => VehicleListScreen()),
                                    );
                                  }*//*
                                   //Validation.Progressdialog(_scafkey).show();

                                 }


                               },
                               child: Text(
                                 'Get OTP',
                                 style:
                                 TextStyle(color: Colors.white, fontSize: 18),
                               ),
                             ),
                           ),*/
                           SizedBox(height: 15,),
                           InkWell(onTap: (){

                           },
                             child: Text("Forgot Password?",style: TextStyle(color: Color(0xFF013B46),fontWeight: FontWeight.bold),),
                           )




                         ],
                       ),
                     ),

                   ),

              )

              //color: Colors.blue,
            )),
            Expanded(
                flex: 3, child: Container(
              width: MediaQuery.of(context).size.width,
              //height: 100,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage("images/bottom_img.png"),
                ),
              ),
            )
            ),
          ],
        ),
      ),
    );
  }
}
