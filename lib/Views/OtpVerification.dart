import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:travelday/Modal/ApiResponse.dart';
import 'package:travelday/Services/ApiServices.dart';
import 'package:travelday/Utils/UserStore.dart';
import 'package:travelday/Utils/Validation.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';
import 'package:travelday/Views/DashboardScreen.dart';
import 'package:travelday/Views/LoginScreen.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:travelday/Views/ProfileScreen.dart';
import 'package:travelday/di/di.dart';
import 'package:alt_sms_autofill/alt_sms_autofill.dart';



class OtpVerfication extends StatefulWidget {
  final String? str_mobilenumber;
  const OtpVerfication({Key? key,required this.str_mobilenumber}) : super(key: key);

  @override
  State<OtpVerfication> createState() => _OtpVerficationState();
}

class _OtpVerficationState extends State<OtpVerfication> {
  final GlobalKey<ScaffoldState>_scafkey=GlobalKey<ScaffoldState>();
  final RoundedLoadingButtonController _btnController1 = RoundedLoadingButtonController();
  TextEditingController? textEditingController1;
  String _code="";
  int _start = 60;
  Timer? _timer;
  bool _isResendAgain = false;
  var _userAuth = UserStore();
  String? _commingSms = 'Unknown',str_otp;

  void resend() {
    setState(() {
      _isResendAgain = true;
    });

    const oneSec = Duration(seconds: 1);
    _timer = new Timer.periodic(oneSec, (timer) {
      if(mounted)
        setState(() {
          if (_start == 0) {
            _start = 60;
            _isResendAgain = false;
            timer.cancel();
            _btnController1.stop();
            textEditingController1!.clear();
          } else {
            _start--;
          }
        });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    textEditingController1 = TextEditingController();
    resend();
    Future.delayed(const Duration(milliseconds: 60000), () async{
      _start=0;
      _code="";
      setState(() {
      });
    });
    initSmsListener();

  }
  Future<void> initSmsListener() async {
    String? commingSms;
    try {
      commingSms = await AltSmsAutofill().listenForSms;
    } on PlatformException {
      commingSms = 'Failed to get Sms.';
    }
    if (!mounted) return;

    setState(() {
      _commingSms = commingSms;
      print("====>Message: ${_commingSms}");
      if(_commingSms!.length>6)
      {
        var pop=_commingSms!.split(" ");
        print("====>pop: ${pop[7]},${pop[8]}");
        String str_combine= pop[7]+""+pop[8];
        print("====>str_combine: ${str_combine}");
        if(str_combine=="TravelDay.")
        {
          str_otp=_commingSms!.split(" ")[12];

          print("====>str_otp: ${str_otp}");
          _commingSms=str_otp;
          //num=str_otp!;
          textEditingController1!.text =str_otp!;

        }else
        {
          print("====>message not match");
        }

      }


      //AltSmsAutofill().unregisterListener();
    });
  }
  Future<dynamic> verifyOTP(String mobile,String otp, BuildContext context) async {
    //print("imei====="+imei);
    print("mobile====="+mobile.toString());
    print("otp====="+otp);

    //print("otp====="+otp);
    Map map = {
      "mobile_no":mobile,
      "otp":otp
    };

    final loginresponse = locator.get<ApiService>().apiRequest("verifyotp", map);
    return loginresponse.then((res) async {
      try{
        print("Rsponse"+res.toString());
        //var map =res['data'];
        final data= jsonDecode(res.toString());
        print("map=====${data}");
        print("map1=====${data['data']}");
        //
        //var data= map["data"];
        //print("data====="+data);

        if(data['data']['status']=="success")
        {
          print("status====="+data['data']["status"]);
          print("token====="+data['data']["token"]);
          print("userType====="+data['data']["userType"]);

          _btnController1.stop();
          textEditingController1!.clear();

          _userAuth.setUserLoggedIn(data['data']["status"]);
          _userAuth.setToken(data['data']["token"]);
          _userAuth.setUserid(data['data']["userId"].toString());

          if(data['data']["userType"]=="new")
          {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProfileScreen( str_mobile: mobile,)),);
          }else{
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DashBoardScreen()),);
          }

          //}
        }
        /*else
        {
          //LoginFailureResponse loginData=LoginFailureResponse.fromJson(jsonDecode(res.toString()));
          print("Rsponse"+res.toString());
          if(data['data']['status']=="error")F
          {
            try{
              _btnController1.stop();
              //CheckConnection.hideDialog(_scafkey.currentState!.context);
              // pr.hide();
              //Validation.Progressdialog(_scafkey).hide();
              print("Failure=="+data['data']['message']);
              if(Platform.isAndroid)
              {
                //this._showToast(context, loginData.str_message);
                //Validation.errorAlertDialog(context,loginData.str_message);
                Validation.showErrormessage(_scafkey,data['data']['message']);
              }else
              {
                Validation.errorAlertDialog(context, data['data']['message']);
              }


            }catch(ex)
            {
              //Validation.Progressdialog(_scafkey).hide();
              print("enterException");

              // pr.hide();

            }

          }
        }*/
        // map[""]

      }catch(ex)
      {
        // pr.hide();
        //Validation.Progressdialog(_scafkey).hide();
        print(ex.toString());
        final data= jsonDecode(res.toString());
        _btnController1.stop();
        //CheckConnection.hideDialog(_scafkey.currentState!.context);
        // pr.hide();
        //Validation.Progressdialog(_scafkey).hide();
        print("Failure=="+data['message']);
        if(Platform.isAndroid)
        {
          //this._showToast(context, loginData.str_message);
          //Validation.errorAlertDialog(context,loginData.str_message);
          Validation.showErrormessage(_scafkey,data['message']);
        }else
        {
          Validation.errorAlertDialog(context, data['message']);
        }
      }
    });
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
        //CheckConnection.hideDialog(_scafkey.currentState!.context);
        //CheckConnection.onAlertButtonPressed(_scaffoldkey.currentState!.context,str_message);
      } else
      {
        try{
          //print("Rsponse"+res.toString());
          //var map =jsonDecode(res.toString());
          //print("Rsponse Status====="+map["status"]);
          if(str_status=="Success")
          {
            //_btnController1.stop();
            //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => OtpVerfication(str_mobilenumber: mobile,)),);

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
  void dispose() {
    // TODO: implement dispose
    AltSmsAutofill().unregisterListener();
    textEditingController1!.dispose();
    if(_timer!.isActive)
    {
      _timer!.cancel();
    }
    super.dispose();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scafkey,
      appBar: AppBar(
        backgroundColor: Color(0xFF013B46),
        title: Text("Validate OTP"),
        leading: InkWell(
          onTap: (){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()),);
          },
          child: Icon(Icons.arrow_back_outlined,color: Colors.white,),
        ),
      ),
      body: Center(
        child: Container(
          height: 350,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  Text("We have sent the verification code to\n your mobile number : ${widget.str_mobilenumber}",style: TextStyle(fontSize: 18,color: Colors.grey),),
                  SizedBox(height: 10,),
                  Text("Enter OTP",style: TextStyle(fontSize: 20,color: Color(0xFF013B46)),),
                  Container(
                    padding: EdgeInsets.all(10),
                    child:
                    /*PinFieldAutoFill(
                        autoFocus: true,
                          cursor: Cursor(
                            width: 1.5,
                            height: 25,
                            color:Color(0xFF283593),
                            radius: Radius.circular(1),
                            enabled: true,
                          ),

                        decoration: UnderlineDecoration(
                          textStyle: TextStyle(fontSize: 20, color: Color(0xFF283593)),
                          colorBuilder: FixedColorBuilder(Color(0xFF283593).withOpacity(0.3)),
                        ),
                        codeLength: 6,
                        //currentCode: sms,
                        onCodeSubmitted: (code) {
                          print("onCodeSubmitted");
                        },
                        onCodeChanged: (code) {
                          if (code!.length == 6) {
                            FocusScope.of(context).requestFocus(FocusNode());
                            print("onCodeChanged"+code);
                            _code=code;

                          }
                        },
                      )*/
                    PinCodeTextField(
                      appContext: context,
                      pastedTextStyle: TextStyle(
                        color: Colors.green.shade600,
                        fontWeight: FontWeight.bold,
                      ),
                      length: 6,
                      obscureText: false,
                      animationType: AnimationType.fade,
                      pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(10),
                          fieldHeight: 50,
                          fieldWidth: 40,
                          inactiveFillColor: Colors.white,
                          inactiveColor: Colors.grey,
                          selectedColor: Colors.grey,
                          selectedFillColor: Colors.white,
                          activeFillColor: Colors.white,
                          activeColor: Colors.grey
                      ),
                      cursorColor: Colors.black,
                      animationDuration: Duration(milliseconds: 300),
                      enableActiveFill: true,
                      controller: textEditingController1,
                      keyboardType: TextInputType.number,
                      boxShadows: [
                        BoxShadow(
                          offset: Offset(0, 1),
                          color: Colors.black12,
                          blurRadius: 10,
                        )
                      ],
                      onCompleted: (v) {
                        //do something or move to next screen when code complete
                        //otp = pin;
                        //print("Completed: " + pin);
                        /*setState(() {
                            otp = v;
                          });*/

                      },
                      onChanged: (value) {
                        print(value);
                        setState(() {
                          print('$value');
                          //num=value;
                          _code=value;
                        });
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 10,top: 10),
                    //color: Colors.blue,
                    //alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Didn't receive the OTP?", style: TextStyle(fontSize: 14, color: Colors.grey.shade500),),
                        TextButton(
                            onPressed: () {
                              if (_isResendAgain) return;
                              //Resendjsondata();
                              // ResendOtpverification();

                              //_start=1;
                              //CheckConnection.showProgressDialog(_scafkey.currentState!.context, SimpleFontelicoProgressDialogType.phoenix, 'Phoenix');
                              getLogin(widget.str_mobilenumber.toString(), context);

                              resend();



                              //num="";
                              //otpController.clear();
                              _btnController1.stop();
                              textEditingController1!.clear(); // by paramesh
                              initSmsListener(); // by paramesh



                            },
                            child:Text(_isResendAgain ? "Retry in " + _start.toString() : "Resend", style: TextStyle(color: Color(0xFF013B46)),)
                        )
                      ],
                    ),
                    /*Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Visibility(
                              visible: timervisible! ,
                              child: Text("")
                            //Text(_start.toString().length==1?"00:0"+_start.toString():"00:"+_start.toString(),style: TextStyle(color: Color(0xFF283593),fontSize: 16),)
                          ),
                          Visibility(
                              visible: resendvisible! ,
                              child: Text("Didn't recieve OTP? ",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold),)
                          ),
                          InkWell(
                            onTap: (){
                              print("send");
                              textEditingController1!.clear();
                              initSmsListener();

                              _start=1;
                              CheckConnection.showProgressDialog(_scafkey.currentState!.context, SimpleFontelicoProgressDialogType.phoenix, 'Phoenix');
                              getLogin(mobile, str_imei, "resend", context);
                            },
                            child:Visibility(
                                visible: resendvisible! ,
                                child: Text("Resend OTP",style: TextStyle(color: Color(0xFF283593),fontWeight: FontWeight.bold),)
                            ) ,

                          ),


                        ],
                      ),*/

                  ),

                  SizedBox(height: 30,),
                  RoundedLoadingButton(
                      successIcon: Icons.check_circle,
                      height: 40,
                      width: 300,
                      successColor: Colors.green,
                      failedIcon: Icons.error,
                      borderRadius: 5,
                      color:Color(0xFF013B46),
                      child:Text("Submit OTP",style: TextStyle(color: Colors.white,fontSize: 18),),
                      controller: _btnController1,
                      onPressed: () async {
                        var connection= await CheckConnection.check();

                        if(connection)
                        {
                          FocusManager.instance.primaryFocus?.unfocus();

                          if(_code.length==6)
                          {
                            print("_code===="+_code);
                            //CheckConnection.showProgressDialog(_scafkey.currentState!.context, SimpleFontelicoProgressDialogType.phoenix, 'Phoenix');
                            Validation.checkConnection().then((connectionResult) {
                              print("check=======$connectionResult");
                              if(connectionResult)
                              {
                                // pr.show();
                                // getLogin(mobile, str_imei,_code, context);
                                verifyOTP(widget.str_mobilenumber.toString(),_code,context);

                              }else{
                                CheckConnection.hideDialog(_scafkey.currentState!.context);
                                if(Platform.isAndroid)
                                {
                                  _btnController1.stop();
                                  Validation.showNointernetErrormessage(_scafkey, "No internet connection.");
                                }else
                                {
                                  _btnController1.stop();
                                  Validation.errorAlertDialog(context,"No internet connection.");
                                }
                              }
                            });

                          }else
                          {
                            _btnController1.stop();
                            Validation.showErrormessage(_scafkey,'Please enter valid OTP!');

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
                    width: 250,
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
                        // Navigator.push(
                        //     context, MaterialPageRoute(builder: (_) => HomePage()));

                        //_timer!.cancel();

                        if(_code.length==6)
                        {
                          print("_code===="+_code);
                          //CheckConnection.showProgressDialog(_scafkey.currentState!.context, SimpleFontelicoProgressDialogType.phoenix, 'Phoenix');
                          Validation.checkConnection().then((connectionResult) {
                            print("check=======$connectionResult");
                            if(connectionResult)
                            {
                              // pr.show();
                             // getLogin(mobile, str_imei,_code, context);
                              if(_code=="123456"){
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DashBoardScreen()),);
                              }

                            }else{
                              CheckConnection.hideDialog(_scafkey.currentState!.context);
                              if(Platform.isAndroid)
                              {
                                Validation.showErrormessage(_scafkey, "There is no internet connection!");
                              }else
                              {
                                Validation.errorAlertDialog(context,"There is no internet connection");
                              }
                            }
                          });

                        }else
                        {
                          Validation.showErrormessage(_scafkey,'Please enter valid OTP!');

                        }
                      },
                      child: Text(
                        'Submit OTP',
                        style:
                        TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),*/

                  //Text(sms)
                ],
              ),
            ),
          ),
        ),
      ),
    );
      Container(
      child: Text("hi"),
    );
  }
}
