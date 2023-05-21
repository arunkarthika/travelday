import 'dart:convert';

import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:travelday/Services/ApiServices.dart';
import 'package:travelday/Services/httpclient.dart';
import 'package:travelday/Utils/UserStore.dart';
import 'package:travelday/Utils/Validation.dart';
import 'package:rflutter_alert/rflutter_alert.dart';



class EmergencyContactList extends StatefulWidget {
  const EmergencyContactList({Key? key}) : super(key: key);

  @override
  _EmergencyContactListState createState() => _EmergencyContactListState();
}

class _EmergencyContactListState extends State<EmergencyContactList> {

  bool? bl_dialog=true;
  String?token;
  //UserAuth userAuth=  UserAuth();
  var date;
  List<String> _title=[ ];
 // List<String> _title=[];
  List<String> _emergencymobilenumber=[ ];
  List<String> _name=[ ];
  List<String> _user_id=[];
  List<String> _orgname=[ ];
  List<int> _status=[];
  List<String> _routetype=["Pickup" ];
  List<dynamic> seatno=[ "15"];
  List<String> _eta=[ "3:15 Pm"];
  List<String> _fromdate=[];
  List<dynamic> data=[];
  var loading = true;
  final GlobalKey<ScaffoldState>_scafkey=GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  TextEditingController empnameController = TextEditingController();
  TextEditingController mobilenumberController = TextEditingController();
  var _userAuth = UserStore();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    date = DateTime.now().millisecondsSinceEpoch;
    Future.delayed(const Duration(milliseconds: 500), () async{
      var connection= await CheckConnection.check();
      if(connection)
      {
        //CheckConnection.showDialog(_scafkey.currentState!.context, SimpleFontelicoProgressDialogType.phoenix, 'Phoenix');

        getLoginToken(date);
        setState(() {

        });

        print("bl_dialog==${bl_dialog}");
      }else{
        //CheckConnection.showErrorSnackBar(_scafkey.currentState!.context,"No internet connection!");
        setState(() {
          bl_dialog=false;
          print("bl_dialog1==${bl_dialog}");
        });

      }

    });

    /*Future.delayed(const Duration(milliseconds: 3000), () {


      setState(() {
        // Here you can write your code for open new view
        //Validation.Progressdialog(_scafkey).show();

        bl_dialog =false;
      });

    });*/
  }
  Future<void> getLoginToken(date) async
  {
    // status= await userAuth.getLoginStatus();
    //token= await userAuth.getLoginToken();
    //print("token--------->>>>>>$token");
    getRoutelist();

  }
  void getRoutelist() async {
    var connection= await CheckConnection.check();
    if(connection)
    {
      _emergencymobilenumber.clear();
      _name.clear();
      _user_id.clear();
      _status.clear();


      print("date====${date}");
      try {
        Dio dio = Dio();
        dio.options.headers['content-Type'] = 'application/json';
        //dio.options.headers["authorization"] = "Token ${token}";
        Response response = await dio.get(ApiService.baseUrl+"emergency_contacts",
            /*data: {
              //"tripDate": date
              //"date" :date
            },
            options: Options(
              //headers: {"Token": "$token"},
            )*/
        );
        print("data coming");
        print(response.toString());

        var successresponse=jsonDecode(response.toString());

       int status=successresponse['status'];
       String str_message= successresponse['message'];
       if(str_message=='success')
         {
           setState(() {
             // Here you can write your code for open new view
             //Validation.Progressdialog(_scafkey).show();

             bl_dialog =false;
           });


           try{
             final data=successresponse['data'] as List;
             for(int i=0;i<data.length;i++)
               {
                 String str_emergencynumber=data[i]['emergency_mobile_number'];
                 String str_name=data[i]['name'];
                 String str_user_id=data[i]['user_id'];

                 _emergencymobilenumber.add(str_emergencynumber);
                 _name.add(str_name);
                 _user_id.add(str_user_id);


               }
           }catch(e){

             print(e.toString());
             //_vehicle.add("--");
           }
         }



      } on DioError catch (e) {
        print(e.response!.data);
        print(e.response!.headers);
        //print(e.response!.request);
      }
    }else
    {
      //CheckConnection.showErrorSnackBar(_scafkey.currentState!.context,"No internet connection!");
      setState(() {
        bl_dialog=false;
      });
    }
  }

  void createEmergencyContacts(String? str_userid, String name, String mobile, String s) async {
    var connection= await CheckConnection.check();
    if(connection)
    {
      print("date====${date}");
      try {
        Dio dio = Dio();
        dio.options.headers['content-Type'] = 'application/json';
        //dio.options.headers["authorization"] = "Token ${token}";
        Response? response;
        if(s=="update")
          {
            response = await dio.post(ApiService.baseUrl+"emergency_contacts/update/${str_userid}",
                data: {
                  "user_id" : str_userid,
                  "name":name,
                  "emergency_mobile_number":mobile
                },
                options: Options(
                  //headers: {"Token": "$token"},
                )
            );
          }else{
          response = await dio.post(ApiService.baseUrl+"emergency_contacts/create",
              data: {
                "user_id" : str_userid,
                "name":name,
                "emergency_mobile_number":mobile
              },
              options: Options(
                //headers: {"Token": "$token"},
              )
          );
        }

        print("data coming");
        print(response.toString());

        var successresponse=jsonDecode(response.toString());
        if(s=='update')
          {
            var data=successresponse['data'];
            int status=data['status'];
            String str_message= data['message'];
            setState(() {
              // Here you can write your code for open new view
              //Validation.Progressdialog(_scafkey).show();
              bl_dialog =false;
              empnameController.clear();
              mobilenumberController.clear();
            });

            getRoutelist();
            //Validation.showSuccessSnackBar(_scafkey.currentState!.context, s);

          }else{
          int status=successresponse['status'];
          String str_message= successresponse['message'];
          if(str_message=='success')
          {
            setState(() {
              // Here you can write your code for open new view
              //Validation.Progressdialog(_scafkey).show();
              bl_dialog =false;
              empnameController.clear();
              mobilenumberController.clear();
            });

            getRoutelist();
          }
        }





      } on DioError catch (e) {
        print(e.response!.data);
        print(e.response!.headers);
        //print(e.response!.request);
      }
    }else
    {
      //CheckConnection.showErrorSnackBar(_scafkey.currentState!.context,"No internet connection!");
      setState(() {
        bl_dialog=false;
      });
    }
  }

  _showSingleChoiceDialog(BuildContext context, String s, String user_id) => showDialog(
      context: context,

      barrierDismissible: false,
      builder: (context) {
        String? groupvaluecity;
        return AlertDialog(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text("Add Employee",textAlign: TextAlign.center,),
          content: SingleChildScrollView(
            child: Column(
              children: [
                Form(
                  key: formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        //obscureText: true,
                        autofocus: true,
                        controller: empnameController,
                        decoration: InputDecoration(
                          icon: Icon(Icons.person),
                          labelText: 'Name ',
                        ),
                        validator: (value){
                          if(value!.isEmpty || value.length==0 ){
                            //allow upper and lower case alphabets and space
                            return "Please enter name";
                          }else{
                            return null;
                          }
                        },
                      ),

                      TextFormField(
                        //obscureText: true,

                        autofocus: true,
                        maxLength: 10,
                        keyboardType: TextInputType.number,
                        controller: mobilenumberController,
                        decoration: InputDecoration(
                          focusColor: Color(0xFF013B46),

                          icon: Icon(Icons.phone_android),
                          labelText: 'Mobile number ',

                        ),

                        validator: (value){
                          if(value!.isEmpty || value.length==0 ){
                            //allow upper and lower case alphabets and space
                            return "Please enter mobile number";
                          }else{
                            return null;
                          }
                        },
                      ),



                    ],
                  ),
                ),
              ],
            ),

          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 1,
                  child: DialogButton(
                    color: Colors.grey,
                    onPressed: (){
                      Navigator.pop(context);
                      mobilenumberController.clear();
                      empnameController.clear();
                      //_singleNotifier.updateCountry(countries[0]);
                      setState(() {
                        //visibility=false;
                      });
                    },
                    child: Text(
                      "Close",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),

                Expanded(
                  flex: 1,
                  child: DialogButton(
                    color: Color(0xFF013B46),
                    onPressed: () async {
                      if(formKey.currentState!.validate()){
                        //check if form data are valid,
                        // your process task ahed if all data are valid
                        print("_emergencymobilenumber${_emergencymobilenumber.length}");


                        if(s=="update")
                          {
                            setState(() {
                              bl_dialog=true;
                            });
                            try{
                              var connection= await CheckConnection.check();
                              if(connection)
                              {
                                Navigator.pop(context);
                                setState(() {
                                  bl_dialog=true;
                                });
                                //String? str_userid=await _userAuth.getUserid();
                                createEmergencyContacts(user_id,empnameController.text.toString(),mobilenumberController.text.toString(),s);
                                //checkEmployeeid(token!,empidController.text,empnameController.text,_singleNotifier);
                              }else
                              {
                                ScaffoldMessenger.of(context).showSnackBar(new SnackBar(content: new Text("No internet connection!"),backgroundColor: Colors.red,));
                                // CheckConnection.showErrorSnackBar(_scafkey.currentContext!,"No internet connection!");
                                setState(() {
                                  bl_dialog=false;
                                });
                              }

                            }catch(ex)
                            {
                              print(ex);
                              setState(() {
                                bl_dialog=false;
                              });
                            }
                          }else{
                          if(_emergencymobilenumber.length>5)
                          {
                            Navigator.pop(context);
                            empnameController.clear();
                            mobilenumberController.clear();
                            //CheckConnection.showErrorSnackBar(_scafkey.currentContext!, "Employee already added.");
                            ScaffoldMessenger.of(context).showSnackBar(new SnackBar(content: new Text("Maximum five contacts only add."),backgroundColor: Colors.red,));
                          }else
                          {
                            setState(() {
                              bl_dialog=true;
                            });
                            try{
                              var connection= await CheckConnection.check();
                              if(connection)
                              {
                                Navigator.pop(context);
                                setState(() {
                                  bl_dialog=true;
                                });
                                String? str_userid=await _userAuth.getUserid();
                                createEmergencyContacts(str_userid,empnameController.text.toString(),mobilenumberController.text.toString(),s);
                                //checkEmployeeid(token!,empidController.text,empnameController.text,_singleNotifier);
                              }else
                              {
                                ScaffoldMessenger.of(context).showSnackBar(new SnackBar(content: new Text("No internet connection!"),backgroundColor: Colors.red,));
                                // CheckConnection.showErrorSnackBar(_scafkey.currentContext!,"No internet connection!");
                                setState(() {
                                  bl_dialog=false;
                                });
                              }

                            }catch(ex)
                            {
                              print(ex);
                              setState(() {
                                bl_dialog=false;
                              });
                            }

                          }
                        }




                      }


                    },
                    child: Text(
                      "Add",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 20,
            )

          ],
        );

      });
  _onAlertButtonPressed(BuildContext context, String id,) {
    Alert(
      context: context,
      type: AlertType.error,
      title: "Travel Day",
      desc: "Are you sure want to delete.",
      buttons: [
        DialogButton(
          child: Text(
            "Confirm",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: (){
            //BookingHistorylist.closedialog="close";
            Navigator.of(context,rootNavigator: true).pop();
            //CheckConnection.showDialog(_scaffoldkey.currentState!.context, SimpleFontelicoProgressDialogType.phoenix, 'Phoenix');
            setState(() {
              bl_dialog=true;
            });
            deleteComplaint(id);
          },
          width: 120,
          color: Colors.red,
        )
      ],
    ).show();
  }
  void deleteComplaint(String id) async {
    /*print("token--------->>>>>>$token");
    print("routeID--------->>>>>>$routeID");
    print("seatnumder--------->>>>>>$seatnumder");
    print("trip--------->>>>>>$trip");
    print("bookingid--------->>>>>>$bookingid");
    print("vehRegNo--------->>>>>>$vehRegNo");
    print("index--------->>>>>>$index");*/
    print("id--------->>>>>>$id");
    var connection= await CheckConnection.check();
    if(connection)
    {
      try {
        Dio dio = Dio();
        dio.options.headers['content-Type'] = 'application/json';
        //dio.options.headers["authorization"] = "Token ${token}";
        Response response = await dio.post(ApiService.baseUrl+"/emergency_contacts/delete/${id}",
            /*data: {
              "routeID" : routeID,
              "vehRegNo" : vehRegNo,
              "seatNo" : seatnumder,
              "tripDate" : trip,
              "bookingID" : bookingid,
              "pickuppointID":ll_pickuppointid
            },
            options: Options(
              headers: {"Token": "$token"},
            )*/
        );
        print("data coming");
        print(response.toString());


        var failureresponse=jsonDecode(response.toString());
        String str_status=failureresponse['status'];


      } on DioError catch (e) {
        print(e.response!.data);
        print(e.response!.headers);
        setState(() {
          bl_dialog=false;
        });
        //print(e.response!.request);
      }
    }else
    {
      //CheckConnection.showErrorSnackBar(_scaffoldkey.currentState!.context,"No internet connection!");
      setState(() {
        bl_dialog=false;
      });
    }


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scafkey,
      appBar: AppBar(
        backgroundColor: const Color(0xFF013B46),
        title:  const Padding(
          padding: EdgeInsets.only(left: 15),
          child: Text('Emergency Contact'),
        ),
      ),
      body: Stack(
        children: [
          bl_dialog==true?
          Center(
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
          ):  Container(
            //color: Colors.green,
              child: /*_vehicle.length==0?Center( child: Text("No routes available.",style: TextStyle(fontSize: 17),)):*/
              _emergencymobilenumber.length==0?Center(child: Text("No assigned routes")):Column(
                children: [
                  Expanded(
                      flex: 6,
                      child: Container(
                        alignment: Alignment.topCenter,
                        //color: Colors.red,

                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount:_emergencymobilenumber.length,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Container(
                              //margin:EdgeInsets.all(15),
                              color: Colors.transparent,
                              // child:Expanded(
                              //   flex: 1,
                              child: GestureDetector(
                                  onTap: ()
                                  {


                                  },
                                  child: Card(
                                      semanticContainer: true,
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      elevation: 5,
                                      margin: EdgeInsets.all(10),
                                      child: Container(
                                          margin: EdgeInsets.all(15),
                                          child:
                                          Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Row(
                                                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [

                                                      Icon(Icons.person,color: Colors.grey,size: 20,),
                                                      SizedBox(width: 5,),
                                                      Text(_name[index],style: TextStyle(fontSize: 15,color: Colors.grey),),
                                                      //Text(_endtime[index],style: TextStyle(fontSize: 15,color: Colors.grey),),


                                                    ],

                                                  ),

                                                  Row(
                                                    // mainAxisAlignment: MainAxisAlignment.end,
                                                    children: [
                                                      // Text(_transitmode[index],style: TextStyle(fontSize: 15,color: Colors.grey),),
                                                    ],

                                                  ),

                                                ],

                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),

                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Row(
                                                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      //Expanded(child: child)
                                                      //Text(_title[index].capitalize().length>25?_title[index].capitalize().substring(0,25)+"....":_title[index].capitalize(),style: TextStyle(fontSize: 20),),
                                                      Icon(Icons.phone,color: Colors.grey,size: 20,),
                                                      SizedBox(width: 5,),
                                                      Text(_emergencymobilenumber[index]==null || _emergencymobilenumber[index]==""?"--":_emergencymobilenumber[index] ,style: TextStyle(fontSize: 18,color: Colors.grey.shade500,fontWeight: FontWeight.bold),),


                                                    ],

                                                  ),


                                                  Row(
                                                    children: [
                                                      InkWell(
                                                        onTap: (){
                                                          _onAlertButtonPressed(context,_user_id[index].toString());
                                                        },
                                                        child:Icon(Icons.delete,color: Colors.grey,size: 20,),
                                                      ),

                                                      SizedBox(
                                                        width: 20,
                                                      ),
                                                      InkWell(
                                                        onTap: (){
                                                          _showSingleChoiceDialog(context,"update",_user_id[index]);
                                                        },
                                                        child:Icon(Icons.edit,color: Colors.grey,size: 20,),
                                                      )

                                                      //Text("ETA"+" - ",style: TextStyle(fontSize: 15,color: Colors.grey),),
                                                      //Text(_eta[index],style: TextStyle(fontSize: 15,color: Colors.grey),),
                                                    ],
                                                  )

                                                ],

                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),


                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  //Text(ll_description[index],style: TextStyle(fontSize: 14,color: Colors.grey),),
                                                  Row(
                                                    children: [
                                                      // Icon(Icons.house_rounded,color: Colors.grey,size: 20,),
                                                      // SizedBox(width: 5,),
                                                      // Text(_orgname[index],style: TextStyle(fontSize: 14,color: Colors.grey),),
                                                    ],
                                                  ),

                                                  //Text("${_fromdate[index]}",style: TextStyle(fontSize: 14,color: Colors.green),),
                                                  //Text("09-11-2021 06:12 PM",style: TextStyle(fontSize: 14),),
                                                ],
                                              )
                                            ],
                                          )
                                      )
                                  )
                              ),
                              //)
                            );
                          },
                        ),

                      ))
                ],
              )
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                backgroundColor: Color(0xFF013B46),
                onPressed: (){
                  _showSingleChoiceDialog(context,'create',"");
                },child: Icon(Icons.add),

              ),
            ),
          )
        ],
      )


    );
  }
}
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}