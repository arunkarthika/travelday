import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:travelday/Services/ApiServices.dart';
import 'package:travelday/Utils/UserStore.dart';
import 'package:travelday/Utils/Validation.dart';
import 'package:travelday/Views/DashboardScreen.dart';
import 'package:dio/dio.dart';


class FavirouteAddressScreen extends StatefulWidget {
  final String str_place;
  final double pickuplat,pickuplng;
  const FavirouteAddressScreen({Key? key, required this.str_place, required this.pickuplat,required this.pickuplng}) : super(key: key);

  @override
  State<FavirouteAddressScreen> createState() => _FavirouteAddressScreenState();
}

class _FavirouteAddressScreenState extends State<FavirouteAddressScreen> {
  TextEditingController nameController = TextEditingController();
  //TextEditingController mobilenumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController bloodgroupController = TextEditingController();
  final RoundedLoadingButtonController _btnController1 = RoundedLoadingButtonController();
  final GlobalKey<ScaffoldState>_scafkey=GlobalKey<ScaffoldState>();
  String? user_id;
  var _userAuth = UserStore();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   // mobilenumberController.text=widget.str_mobile;
    getLoginToken();

  }
  Future<void> getLoginToken() async
  {
    // status= await userAuth.getLoginStatus();
    user_id= await _userAuth.getUserid();
    print("user_id--------->>>>>>$user_id");
    emailController.text=widget.str_place;
    print("lat--------->>>>>>${widget.pickuplat}");
    print("lng--------->>>>>>${widget.pickuplng}");
    print("selectaddress--------->>>>>>${widget.str_place}");


  }
  void profileUpdate(String name, String mobilenumber, String email,) async {

    print("str_name------>$name");
    print("mobilenumber------>$mobilenumber");
    print("email------>$email");
    print("user_id------>$user_id");

    var connection= await CheckConnection.check();
    if(connection)
    {
      try {
        Dio dio = Dio();
        dio.options.headers['content-Type'] = 'application/json';
        //dio.options.headers["authorization"] = "Token ${token}";
        Response response = await dio.post(ApiService.baseUrl+"favarite_location/create",
            data: {
              "user_id" : 5,
              "name":"home",
              "place":"OTT popcorn., School Street, Puttuppedu, Karambakkam, Rajeswari Nagar, Porur, Chennai, Tamil Nadu",
              "latitude":13.0382019,
              "longitude":80.1579706
            },
            // options: Options(
            //   headers: {"Token": "$token"},
            // )
        );
        print("data coming");
        print(response.toString());

        final data_response=jsonDecode(response.toString());
        String str_status=data_response['data']['status'];
        if(str_status=="error")
        {
          String str_message=data_response['data']['data'];

          Validation.showErrormessage(_scafkey,str_message);

        }else
        {
          if(str_status=="success")
            {
            String str_message= data_response['data']['message'];
            Validation.showErrormessage(_scafkey,str_message);
            }
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DashBoardScreen()),);

          //CheckConnection.showSuccessSnackBar(_scaffoldkey.currentState!.context, str_message);
          //Navigator.pop(context);

        }


      } on DioError catch (e) {
        print(e.response!.data);
        print(e.response!.headers);
        //print(e.response!.request);
      }
    }else
    {
      //CheckConnection.showErrorSnackBar(_scaffoldkey.currentState!.context,"No internet connection!");
      setState(() {
        //bl_dialog=false;
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scafkey,
      appBar: AppBar(
        backgroundColor: Color(0xFF013B46),
        title: Text(" Add Favourie Address"),
      ),
      body: Container(
        margin: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Location Name*",style: TextStyle(fontSize: 18),),
                SizedBox(height: 10),
                SizedBox(
                    //width: 300,
                    height: 40,
                    child: TextField(
                        controller:nameController,
                        autocorrect: true,
                        //maxLength: 10,
                        //keyboardType: TextInputType.number,
                        cursorColor: Color(0xFF013B46),
                        decoration: InputDecoration(
                          counterText: "",
                          hintText: 'Enter location name',
                          hintStyle: TextStyle(color: Colors.grey),
                          filled: true,
                          //prefixIcon: Icon(Icons.phone_android,size: 20,color: Color(0xFF013B46),),
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

              ],
            ),

            SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Address*",style: TextStyle(fontSize: 18),),
                SizedBox(height: 10),
                Container(
                    //width: 300,
                    //color: Colors.red,
                    height: 100,
                    child: TextFormField(
                        controller:emailController,
                        autocorrect: true,
                        keyboardType: TextInputType.multiline,
                        maxLines: 8,
                        maxLength: 1000,
                        //maxLength: 10,
                        //keyboardType: TextInputType.number,
                        cursorColor: Color(0xFF013B46),
                        decoration: InputDecoration(
                          counterText: "",
                          hintText: 'Enter address',
                          hintStyle: TextStyle(color: Colors.grey),
                          filled: true,
                          //prefixIcon: Icon(Icons.phone_android,size: 20,color: Color(0xFF013B46),),
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.fromLTRB(10, 15, 0, 0),
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

              ],
            ),
            /*SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Blood Group",style: TextStyle(fontSize: 18),),
                SizedBox(height: 10),
                SizedBox(
                    //width: 300,
                    height: 40,
                    child: TextField(
                        controller:bloodgroupController,
                        autocorrect: true,
                        maxLength: 10,
                        //keyboardType: TextInputType.number,
                        cursorColor: Color(0xFF013B46),
                        decoration: InputDecoration(
                          counterText: "",
                          hintText: 'Enter blood group',
                          hintStyle: TextStyle(color: Colors.grey),
                          filled: true,
                          //prefixIcon: Icon(Icons.phone_android,size: 20,color: Color(0xFF013B46),),
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

              ],
            ),*/

            SizedBox(height: 45,),
            RoundedLoadingButton(
                successIcon: Icons.check_circle,
                height: 40,
                width: 300,
                successColor: Colors.green,
                failedIcon: Icons.error,
                borderRadius: 5,
                color:Color(0xFF013B46),
                child:Text("Submit",style: TextStyle(color: Colors.white,fontSize: 18),),
                controller: _btnController1,
                onPressed: () async {
                  var connection= await CheckConnection.check();

                  if(connection)
                  {
                    FocusManager.instance.primaryFocus?.unfocus();
                    print("email:"+emailController.text);
                    // print("password:"+passwordController.text);
                    if(nameController.text.length==0||nameController.text.isEmpty)
                    {

                      _btnController1.stop();
                      //print("Please enter email:");
                      if(Platform.isAndroid)
                      {
                        Validation.showErrormessage(_scafkey,'Please enter location name!');
                      }else if(Platform.isIOS)
                      {
                        Validation.errorAlertDialog(context,'Please enter location name!');
                      }
                    } /*else if(mobilenumberController.text.length==0||mobilenumberController.text.isEmpty)
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
                    }*/
                    else if(emailController.text.length==0||emailController.text.isEmpty)
                    {

                      _btnController1.stop();
                      //print("Please enter email:");
                      if(Platform.isAndroid)
                      {
                        Validation.showErrormessage(_scafkey,'Please enter  address!');
                      }else if(Platform.isIOS)
                      {
                        Validation.errorAlertDialog(context,'Please enter  address!');
                      }
                    }else
                      {
                        //profileUpdate(nameController.text.toString(), widget.str_mobile,emailController.text.toString());

                      }

                    /*else if(RegExp(r'(^(?:(?:\+|0{0,2})91(\s*[\-]\s*)?|[0]?)?[6789]\d{9}$)').hasMatch(emailController.text.toString()))
                    {
                      //Validation.showErrormessage(_scafkey,'');
                      //final signature=await SmsAutoFill().getAppSignature;
                      // print(signature);

                      //CheckConnection.showProgressDialog(_scafkey.currentState!.context, SimpleFontelicoProgressDialogType.phoenix, 'Phoenix');
                      // getlogindetails(context);
                      //print("Please enter password:");

                      //getLogin(emailController.text.toString(), context);

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

                      *//*if(emailController.tex t=="paramesh"&&passwordController.text=="admin123")
                                    {
                                      _userAuth.setUserLoggedIn("success");
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(builder: (context) => VehicleListScreen()),
                                    );
                                  }*//*
                      //Validation.Progressdialog(_scafkey).show();

                    }*/


                  }else{
                    _btnController1.stop();
                    //CheckConnection.showErrorSnackBar(_scafkey.currentState!.context,"No Internet Connection!");
                    Validation.showNointernetErrormessage(_scafkey,'No internet connection.');

                  }

                  //CheckConnection.showDialog(_scaffoldkey.currentState!.context, SimpleFontelicoProgressDialogType.phoenix, 'Phoenix');

                }
              // => _doSomething(_btnController1),
            ),

          ],
        ),
      ),
    );
  }
}
