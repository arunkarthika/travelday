

import 'dart:convert';
import 'dart:io';



import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:travelday/Services/ApiServices.dart';
import 'package:travelday/Utils/UserStore.dart';
import 'package:travelday/Utils/Validation.dart';
import 'package:travelday/Views/ProfileUpdateScreen.dart';


class ProfileDetailScreen extends StatefulWidget {
  @override
  _ProfileDetailScreen createState() => _ProfileDetailScreen();
}
class _ProfileDetailScreen extends State<ProfileDetailScreen>{
  final GlobalKey<ScaffoldState>_scafkey=GlobalKey<ScaffoldState>();
  String? UserId;
  String? LoginToken;
  String? FcmToken;
  var _userAuth = UserStore();
  //int dob;
  var dob;
  var loading = true;
  String? str_email='email',str_empid='empid',str_mobile="mobile number",str_empname='name',str_licienceno='licno',str_address='address',str_city='city',str_state='state',str_country='country',str_pin='pin',str_bloodgroup='bloodgroup';
  int? str_emergencycontact=000000000,str_licienceexp=0;


    //  String str_empid="pop",str_mobile="pop",str_emergencycontact="pop",str_licienceno="pop",str_licienceexp="pop",str_address="pop",str_city="pop",str_state="pop",str_country="pop",str_pin="pop",str_bloodgroup="B+Ve";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(const Duration(milliseconds: 1000), () {


      setState(() {
        // Here you can write your code for open new view
        //Validation.Progressdialog(_scafkey).show();
        details();
        //loading =false;
      });

    });

  }
  Future<void>  details()  async {
    //LoginToken = await _userAuth.getToken();
    UserId = await _userAuth.getUserid();
    //FcmToken = await _userAuth.getFCMToken();
    //print("LoginToken====$LoginToken");
    print("UserId====$UserId");
    Validation.checkConnection().then((connectionResult) {
      print("check=======$connectionResult");
      if(connectionResult)
      {
        // pr.show();
        getProfileData(UserId);

      }else{
        //CheckConnection.hideDialog(_scafkey.currentState!.context);
        if(Platform.isAndroid)
        {
          Validation.showErrormessage(_scafkey, "There is no internet connection!");
        }else
        {
          Validation.errorAlertDialog(context,"There is no internet connection");
        }

      }
    });


  }
  Future<dynamic> getProfileData(  String? userId) async {
    var finalurl=Uri.parse(ApiService.baseUrl+"users/${userId}");
    print("Final URL======= $finalurl");
    //print("Final URL Logintoken======= $loginToken");
    //print("Final URL Fcmtoken======= $fcmtoken");
    /*Map map = {
      "FCMKey":fcmtoken,
    };*/
    //Pass headers below
    return http.get(
        finalurl,
        //body: map,
        headers: {
         // "Token": loginToken
        }).then(
            (http.Response response) {
          final int statusCode = response.statusCode;
          print("====response ${response.body.toString()}");

          if (statusCode < 200 || statusCode >= 400 || json == null) {
            //throw new ApiException(jsonDecode(response.body)["message"]);
            print("Exception");
          }
          try{

            //{"status":200,"data":[{"id":5,"name":"param","mobile_no":"8977485285","email":"rao@gmail.com","otp":307690,"status":1,"createAt":"2023-03-19T15:04:11.000Z"}]}



            setState(() {
              if (response.statusCode == 200) {

                setState(() {
                  final data= jsonDecode(response.body.toString());
                  int status=data['status'];

                  if(status==200)
                    {
                      loading=false;
                      var inner_data=data['data'] as List;
                      print(inner_data.length.toString());
                      for(int i=0;i<inner_data.length;i++)
                        {

                          str_empname=inner_data[i]['name'];
                          str_mobile=inner_data[i]['mobile_no'];
                           str_email=inner_data[i]['email'];


                        }
                    }

                });


                //Validation.Progressdialog(_scafkey).hide();
              }else {

                throw Exception('Failed to load post');
              }
            });

          }catch(ex)
              {

              }


          // return jsonDecode(response.body);
        });
  }



  @override
  Widget build(BuildContext context) {

   return Scaffold(
     key: _scafkey,
     appBar: AppBar(
       title: Text('Profile',style: TextStyle(fontSize: 24,color: Colors.white)),
       actions: [
         Padding(
             padding: EdgeInsets.all(8),
             child: InkWell(
               onTap: (){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ProfileUpdateScreen(str_mobile: str_mobile,str_email: str_email,str_name: str_empname,)));
               },
               child: Icon(Icons.edit,color: Colors.white,size: 25,),
             ),
         )
       ],
       //toolbarHeight: 75,
       backgroundColor:Color(0xFF013B46) ,
       elevation: 0.0,

     ),

     body:
          loading? /*Center(child: CircularProgressIndicator(
            color: Color(0xFF013B46),
            backgroundColor: Colors.grey,
          ))*/Center(
            child:
            Container(
                margin: EdgeInsets.all(10),
                //color: Color(0xFF283593),
                height:80,
                width: 130,
                /*decoration: BoxDecoration(
                //color: Colors.indigo[900],
                  color:Colors.white54,
                  borderRadius: BorderRadius.circular(20)
              ),*/

                child: Card(
                  semanticContainer: true,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 10,
                  child: Column(
                    //crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 30,
                        width: 30,
                        child: CircularProgressIndicator(
                          //value: controller.value,
                          color:Color(0xFF013B46),
                          semanticsLabel: 'Circular progress indicator',
                        ),
                      ),
                      SizedBox(height: 10,),
                      Center(
                          child:Text("Please wait...",textAlign:TextAlign.center,style: TextStyle(fontSize: 16,color:Color(0xFF013B46)),)
                      ),
                    ],
                  ),
                )

            ),
          ):
           Container(
             child:
             Container(
               child:Column(
                 children: [
                   /*Expanded(
                     flex: 1,
                       child: Container(
                           decoration: BoxDecoration(
                             gradient: LinearGradient(
                               colors: [Color(0xFF283593),Color(0xFF303F9F)],
                               //begin: FractionalOffset.center,
                               //end: FractionalOffset.bottomLeft,
                             ),
                           ),

                         child: Row(
                           mainAxisSize: MainAxisSize.max,
                           //mainAxisAlignment: MainAxisAlignment.spaceAround,


                           children: [

                              Padding(
                                  padding: EdgeInsets.only(left: 15),
                                            child:InkWell(
                                              onTap: (){
                                                   // _scafkey.currentState.openDrawer();
                                                Navigator.of(context).pop();

                                              },
                                              child: Icon(Icons.arrow_back,color: Colors.white,size: 30,),
                                                  ),
                                                          ),

                             Expanded(
                               flex: 1,
                                 child: Container(
                                   padding: EdgeInsets.only(left: 15),
                                    //alignment: Alignment.s,
                                   child:Text("Profile",style: TextStyle(fontSize: 28,color: Colors.white),) ,
                                 ),),

                            // Employee Transport solution


                             Text("",style: TextStyle(fontSize: 28,color: Colors.white),),

                           ],

                         )


                         //

                       )),*/


                   Expanded(
                       flex: 6,
                       child: Container(
                         alignment: Alignment.topCenter,

                         child: SingleChildScrollView(
                           child: Padding(
                             padding: EdgeInsets.fromLTRB(0,30,0,0),
                             child: Column(
                               crossAxisAlignment:CrossAxisAlignment.stretch ,
                               mainAxisSize: MainAxisSize.min,
                               mainAxisAlignment: MainAxisAlignment.spaceAround,
                               children: [

                                 // Expanded(
                                 //   flex: 1,
                                 Card(
                                   margin: EdgeInsets.all(20.0),
                                   shape: RoundedRectangleBorder(
                                       borderRadius: BorderRadius.circular(30.0),
                                       side: BorderSide(width: 1, color: Colors.black26)
                                   ),
                                   child: Container(


                                      // margin: EdgeInsets.all(20.0),

                                       decoration: BoxDecoration(
                                         border:Border.all(color: Colors.black26,width: 1),
                                         color: Colors.white,
                                         /*gradient: LinearGradient(
                                              //colors: [Color(0xff00B2FF),Color(0xff0089FF)],
                                              //begin: FractionalOffset.center,
                                              //end: FractionalOffset.bottomLeft,
                                            ),*/
                                         borderRadius: BorderRadius.only(
                                           topRight: Radius.circular(30.0),
                                           bottomLeft: Radius.circular(30.0),
                                           topLeft: Radius.circular(30.0),
                                           bottomRight: Radius.circular(30.0),
                                         ),
                                       ),

                                       child: Container(
                                         margin: EdgeInsets.all(20.0),
                                         child:Column(

                                           mainAxisSize: MainAxisSize.max,

                                           children: [
                                             Padding(
                                                 padding: EdgeInsets.only(top: 0),
                                                 child: Column(
                                                   mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                   crossAxisAlignment: CrossAxisAlignment.stretch,
                                                   children: [


                                                     Container(
                                                         margin:EdgeInsets.all(0) ,
                                                         alignment: Alignment.center,
                                                         height: 70,
                                                         width: 70,
                                                         child: Image.asset('images/profile.png',color: Colors.grey,)),
                                                     Padding(
                                                       padding: EdgeInsets.only(top: 10),
                                                       child:Text("${str_empname}",textAlign: TextAlign.center,style: TextStyle(fontSize: 16,color: Colors.black54,fontWeight: FontWeight.normal),),
                                                     ),





                                                     /*Container(
                                                         padding: EdgeInsets.only(top: 10),

                                                         child:Container(
                                                           padding: EdgeInsets.only(top: 10),

                                                           child: Text("Licence Expiry :",style: TextStyle(fontSize: 16,color: Colors.black,fontWeight: FontWeight.normal),),
                                                         )
                                                     ),
                                                     Container(

                                                       padding: EdgeInsets.only(top: 10),

                                                       child: Text(str_licienceexp,style: TextStyle(fontSize: 16,color: Colors.black54,fontWeight: FontWeight.normal),),
                                                     ),*/
                                                     Container(
                                                         padding: EdgeInsets.only(top: 10),

                                                         child:Container(
                                                           padding: EdgeInsets.only(top: 10),

                                                           child: Text("Mobile Number :",style: TextStyle(fontSize: 16,color: Colors.black,fontWeight: FontWeight.normal),),
                                                         )
                                                     ),
                                                     Container(

                                                       padding: EdgeInsets.only(top: 10),

                                                       child: Text( "${str_mobile}",style: TextStyle(fontSize: 16,color: Colors.black54,fontWeight: FontWeight.normal),),
                                                     ),

                                                     Container(
                                                         padding: EdgeInsets.only(top: 10),

                                                         child:Container(
                                                           padding: EdgeInsets.only(top: 10),

                                                           child: Text("Email :",style: TextStyle(fontSize: 16,color: Colors.black,fontWeight: FontWeight.normal),),
                                                         )
                                                     ),
                                                     Container(

                                                       padding: EdgeInsets.only(top: 10),

                                                       child: Text("${str_email}",style: TextStyle(fontSize: 16,color: Colors.black54,fontWeight: FontWeight.normal),),
                                                     ),


                                                   ],
                                                 )


                                             ),





                                           ],
                                         ),
                                       )

                                   ),
                                 ),
                                 //),



                                 // Expanded(
                                 //   flex: 1,

                                 // ),


                               ],

                             ),
                           )
                         )







                       ))
                 ],
               ),
             )

       ),




     //drawer: NavigationDrawer(_scafkey),

   );
  }

}
