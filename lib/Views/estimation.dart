import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:travelday/Modal/TravelTypeList.dart';
import 'package:travelday/Modal/VehicleTypeTypeList.dart';
import 'package:travelday/Services/ApiServices.dart';
import 'package:travelday/Utils/CustomTimePicker.dart';
import 'package:travelday/Utils/Validation.dart';
import 'package:travelday/Views/MyWebView.dart';
import 'package:travelday/Views/ccavenue.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:travelday/Views/ordersuccess.dart';


class Estimation extends StatefulWidget {
  final String strating;
  final String ending;
  final List vehicleType;
  final double estimation;
  final double distance;
  final int post;
  final VehicleTypeModel vehicleTypeModel;
  final Datum datum;
  final DateTime startDate;
  final DateTime enddate;
  final bool isChecked;
  final int cartype;
  final int onewayData;
  final int rentalKm;
  final int rentalHrs;
  Estimation( {super.key, required this.strating, required this.ending, required this.vehicleType, required this.estimation, required this.post,  required this.vehicleTypeModel, required this.distance, required this.datum, required this.startDate, required this.enddate, required this.isChecked, required this.cartype, required this.onewayData, required this.rentalKm, required this.rentalHrs});



  @override
  _EstimationState createState() => _EstimationState();
}

class _EstimationState extends State<Estimation> {


  String startDate="";
  DateTime startTime=DateTime.now();
  DateTime endTime=DateTime.now();
  String endDate="";
  num totalKm=0;
  num baseKm=0;
  num addKm=0;
  num price=0;
  num baseFare=0;
  num addfare=0;
  int driverBeta=0;
  int driverBetaAbove=0;
  num tax=0;
  TimeOfDay selectedTime = TimeOfDay.now();
  TimeOfDay selectedReturnTime = TimeOfDay.now();
  List VehicleType = [];


  bool isNextDay=false;

  String selectedValue = '5 hrs / 50 Km';
  List<String> dropdownItems = ['5 hrs / 50 Km', '10 hrs / 100 Km', '15 hrs / 150 Km'];
  VehicleTypeTypeList vehicleTypeTypeList = VehicleTypeTypeList();
  VehicleTypeModel vehicleType = VehicleTypeModel();

  int oneWayData = 1;
  int noOfdays = 1;
  double distance = 1;




  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    oneWayData=widget.onewayData;
    if(oneWayData==2){
      distance=widget.distance*2;
    }else{
      distance=widget.distance;
    }
    if(widget.datum.name=="Rental"){
      distance=double.parse(widget.rentalKm.toString());
    }
    setDateAndTime();
    calculateKmAndPrice(false);

    // getTravelType();
    // getVehicleType('1');
  }
  void setDateAndTime() {

    String formattedDate = DateFormat('dd/MM/yyyy').format(widget.startDate);
    startDate=formattedDate;
    endDate= DateFormat('dd/MM/yyyy').format(widget.enddate);

    setState(() {

    });
  }


  // getTravelType() async {
  //   var responce = await http.get(Uri.parse(ApiService.baseUrl + "traveltype"));
  //   if (responce.statusCode == 200) {
  //     print(jsonDecode(responce.body));
  //     travelTypeList = TravelTypeList.fromJson(jsonDecode(responce.body));
  //     travelType = travelTypeList.data![1];
  //     setState(() {
  //       final data = jsonDecode(responce.body);
  //       TravelTypes = data['data'] as List;
  //       print(
  //           "fav test data---------------------------------------------------------------------------------------------------------------------------------> $TravelTypes");
  //     });
  //   }
  // }

  getVehicleType(travelID) async {
    print('------------------xx-------------------------pinged api');
    var response = await http.get(Uri.parse(
        ApiService.baseUrl + "vehicletype-travel/${travelID.toString()}"));
    print(response.statusCode);
    if (response.statusCode == 200) {
      vehicleTypeTypeList =
          VehicleTypeTypeList.fromJson(jsonDecode(response.body));
      vehicleType = vehicleTypeTypeList.data![widget.cartype];
      setState(() {
        final data = jsonDecode(response.body);
        VehicleType = data['data'] as List;
        calculateKmAndPrice(false);
        print(
            "Vehicle Type Data---------------------------------------------------------------------------------------------------------------------------------> $VehicleType");
      });
    }
  }



  void calculateKmAndPrice(bool isRecalculate ){
    if(vehicleType.id==null){
      baseKm=widget.vehicleTypeModel.basekm??0;
      int local=widget.vehicleTypeModel.baseRate??0;

      if(oneWayData==2){
        baseKm=baseKm*noOfdays;
      }

      if(widget.datum.name=="Rental"){
        baseKm=distance;
      }

      if(baseKm>400 && !widget.datum.name!.contains("Outstation") ){
        driverBetaAbove=200;
      }
      if(baseKm<distance){
        addKm=distance-baseKm;
        int itempice =widget.vehicleType[
        widget.post]
        ['baseRate'];
        addfare=addKm * itempice ;
      } else {
        addKm=0;
        int itempice =widget.vehicleType[
        widget.post]
        ['baseRate'];
        addfare=addKm * itempice ;
      }

      if(oneWayData==2){
        baseFare = baseKm *local;
      }


      if(isRecalculate){

      }else{
        driverBeta=widget.vehicleTypeModel.driverBetta??0;

        baseFare =baseKm * local;

      }
        if(widget.datum.name=="Airport/Railway"){
          baseFare=num.parse(widget.vehicleTypeModel.airportCharges.toString());
        }

      if(widget.datum.name=="Rental"){
        log(widget.vehicleType.toString());
        baseFare = widget.vehicleType[
        widget.post]
        ['baseFare'];
        if(widget.rentalKm==100){
          baseFare=baseFare*2;
        }
        if(widget.rentalKm==150){
          baseFare=baseFare*3;
        }
      }

      tax= (addfare.roundToDouble()+baseFare.roundToDouble())*0.05;
      price=tax.roundToDouble()+addfare.roundToDouble()+baseFare.roundToDouble()+driverBeta.roundToDouble()+driverBetaAbove.roundToDouble();
    } else {
      baseKm=vehicleType.basekm??0;
      int local=vehicleType.baseRate??0;

      if(oneWayData==2){
        baseKm=baseKm*noOfdays;
      }
      if(baseKm>400&& !widget.datum.name!.contains("Outstation") ){
        driverBetaAbove=200;
      }
      if(baseKm<distance){
        addKm=distance-baseKm;
        int itempice =vehicleType.baseRate??0;
        addfare=addKm * itempice ;
      }else {
        addKm=0;
        int itempice =widget.vehicleType[
        widget.post]
        ['baseRate'];
        addfare=addKm * itempice ;
      }
      if(oneWayData==2){
        baseFare = baseKm *local;
      }

      if(isRecalculate){

      }else{
        driverBeta=vehicleType.driverBetta??0;

        baseFare =baseKm * local;

      }
        if(widget.datum.name=="Airport/Railway"){
          baseFare=num.parse(vehicleType.airportCharges.toString());
        }

      tax= (addfare.roundToDouble()+baseFare.roundToDouble())*0.05;

      price=tax.roundToDouble()+addfare.roundToDouble()+baseFare.roundToDouble()+driverBeta.roundToDouble()+driverBetaAbove.roundToDouble();
    }


    setState(() {

    });
  }
  void calculateKmAndPriceRental(bool isRecalculate,int base ){
    baseKm=base??0;
    int local=widget.vehicleTypeModel.baseRate??0;

    if(baseKm>400 && !widget.datum.name!.contains("Outstation")){
      driverBetaAbove=200;
    }

    if(baseKm<distance){
      addKm=distance-baseKm;
      int itempice =widget.vehicleType[
      widget.post]
      ['baseRate'];
      addfare=addKm * itempice ;
    }else{
      addKm=0;
      int itempice =widget.vehicleType[
      widget.post]
      ['baseRate'];
      addfare=addKm * itempice ;
    }
    baseKm=base??0;
    if(isRecalculate){

    }else{
      driverBeta=widget.vehicleTypeModel.driverBetta??0;

      baseFare =baseKm * local;

    }

    tax= (addfare.roundToDouble()+baseFare.roundToDouble())*0.05;

    price=tax.roundToDouble()+addfare.roundToDouble()+baseFare.roundToDouble()+driverBeta.roundToDouble()+driverBetaAbove.roundToDouble();

    setState(() {

    });
  }

  Future<void> fetchEstimatedPrice() async {
    Dio dio=Dio();
    // final response = await dio.get(
    //   '',
    // );
    //
    // if (response.statusCode == 200) {
    //   final data = json.decode(response.body);
    //   setState(() {
    //     estimatedPrice = data['price'];
    //   });
    // } else {
    //   throw Exception('Failed to fetch estimated price');
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(' Price Estimation'),
      // ),
      persistentFooterButtons: [
        Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyWebView(amount: price,address: '',city: '',billingEmail: '', delAddress: '',delName: '',delPh: '',delState: '',name: '',redirectUrl: '',telph: '',)),);

                  // fetchEstimatedPrice();
                },
                child: Text('Make Payment'),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                onPressed: () {
                  // Navigator.of(context).pop();


                  Navigator.push(context, MaterialPageRoute(builder: (context) => OrderSuccess(widget.strating, widget.ending, startDate, selectedTime.toString(), widget.datum.name!, widget.vehicleTypeModel!.name.toString(), 1, driverBeta.toString(), price.toString(), 'unPaid', "${widget.datum.name=="Rental"?widget.rentalKm:distance.toStringAsFixed(0)}")),);

                  // fetchEstimatedPrice();
                },
                child: Text('Pay Later'),
              ),
            ),
          ],
        )
      ],
      body:
      SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [

                Image.asset("images/estimation.png"),
                Positioned(
                  top: 20,
                    child: Row(
                  children: [
                    IconButton(icon: Icon(Icons.arrow_back,color: Colors.white,size: 24,),onPressed: (){
                      Navigator.of(context).pop();
                    },),
                    Text('Estimated Summary',style: TextStyle(fontSize: 20.0, color:  Colors.white,fontWeight: FontWeight.w600),)

                  ],
                )),
              ],
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 16.0),
                    Text('Pickup Location',style: TextStyle(fontSize: 16.0, color:  Theme.of(context).primaryColor,fontWeight: FontWeight.w600),),
                    SizedBox(height: 16.0),
                    Row(
                      children: [
                        Icon(

                          Icons.location_on,
                          color: Colors.green,
                        ),
                        SizedBox(width: 10,),
                        Container(

                          width: MediaQuery.of(context).size.width-66,
                            child: Expanded(child: Text(widget.strating,style: TextStyle(fontSize: 16.0, color:  Theme.of(context).primaryColor,fontWeight: FontWeight.w600),)))
                      ],
                    ),
                    Divider(color: Colors.grey,thickness: 1,),
                    SizedBox(height: 16.0),
                    widget.datum.name=="Rental"?Container():Text('Drop Location',style: TextStyle(fontSize: 16.0, color:  Theme.of(context).primaryColor,fontWeight: FontWeight.w600),),
                    widget.datum.name=="Rental"?Container():SizedBox(height: 16.0),
                    widget.datum.name=="Rental"?Container(): Row(
                      children: [
                        Icon(

                          Icons.location_on,
                          color: Colors.red,
                        ),
                        SizedBox(width: 10,),
                        Container(
                            width: MediaQuery.of(context).size.width-66,

                            child: Container(
                                width: MediaQuery.of(context).size.width-66,

                                child: Text(widget.ending,overflow:TextOverflow.ellipsis,style: TextStyle(fontSize: 16.0, color:  Theme.of(context).primaryColor,fontWeight: FontWeight.w600),)))
                      ],
                    ),
                    widget.datum.name=="Rental"?Container():Divider(color: Colors.grey,thickness: 1,),




                    !widget.datum.name!.contains("Outstation") || vehicleType.id==null? Row(
                      children: [
                        Expanded(
                            flex: 1,
                            child: Container(
                              //height: 50,
                              // color: _selectedIndex != null && _selectedIndex == index
                              //     ? Color(0xFFD6D6D6)
                              //     : Colors.white,
                              child: Image(
                                image: AssetImage(
                                    "images/car.png"),
                                height: 50,
                                width: 50,
                              ),
                            )),
                        Expanded(
                            flex: 3,
                            child: Container(
                              padding: EdgeInsets.only(
                                  left: 20),
                              alignment:
                              Alignment.centerLeft,
                              //height: 50,
                              // color: _selectedIndex != null && _selectedIndex == index
                              //     ? Color(0xFFD6D6D6)
                              //     : Colors.white,
                              child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment
                                    .center,
                                crossAxisAlignment:
                                CrossAxisAlignment
                                    .stretch,
                                children: [
                                  Container(
                                    //color: Colors.blue,

                                      child: Text(
                                          widget.vehicleType[
                                          widget.post]
                                          ['name'],
                                          style: TextStyle(
                                              fontWeight:
                                              FontWeight
                                                  .bold))),
                                  Container(
                                      child: Text(
                                        "Base ${
                                            widget.datum.name=="Rental"?widget.rentalKm:widget.vehicleType[
                                            widget.post]
                                            ['basekm']} Km",
                                        style: TextStyle(
                                            color:
                                            Colors.grey,
                                            fontSize: 13),
                                      )),
                                ],
                              ),
                            )),
                        Expanded(
                            flex: 2,
                            child: Container(
                              //height: 50,
                              // color: _selectedIndex != null && _selectedIndex == index
                              //     ? Color(0xFFD6D6D6)
                              //     : Colors.white,
                              child: Row(
                                crossAxisAlignment:
                                CrossAxisAlignment
                                    .center,
                                children: [
                                  GestureDetector(
                                    onTap: (){
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('Info'),
                                            content: Text('The actual bill amount would differ based on the actual Kms traveled. The Toll, Parking, Hill Charges, and Interstate Permit (if any) are extra.'),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop(); // Close the dialog
                                                },
                                                child: Text('Close'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: Icon(
                                      Icons
                                          .info_outline_rounded,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                      child: Text(
                                        "\u{20B9}${widget.vehicleType[widget.post]['baseRate']} \u{2044} Km",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight:
                                            FontWeight
                                                .bold),
                                      )),
                                ],
                              ),
                            ))
                      ],
                    ): Row(
                      children: [
                        Expanded(
                            flex: 1,
                            child: Container(
                              //height: 50,
                              // color: _selectedIndex != null && _selectedIndex == index
                              //     ? Color(0xFFD6D6D6)
                              //     : Colors.white,
                              child: Image(
                                image: AssetImage(
                                    "images/car.png"),
                                height: 50,
                                width: 50,
                              ),
                            )),
                        Expanded(
                            flex: 3,
                            child: Container(
                              padding: EdgeInsets.only(
                                  left: 20),
                              alignment:
                              Alignment.centerLeft,
                              //height: 50,
                              // color: _selectedIndex != null && _selectedIndex == index
                              //     ? Color(0xFFD6D6D6)
                              //     : Colors.white,
                              child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment
                                    .center,
                                crossAxisAlignment:
                                CrossAxisAlignment
                                    .stretch,
                                children: [
                                  Container(
                                    //color: Colors.blue,

                                      child: Text(
vehicleType.name??'',
                                          style: TextStyle(
                                              fontWeight:
                                              FontWeight
                                                  .bold))),
                                  Container(
                                      child: Text(
                                        "Base ${
                                            vehicleType.basekm} Km",
                                        style: TextStyle(
                                            color:
                                            Colors.grey,
                                            fontSize: 13),
                                      )),
                                ],
                              ),
                            )),
                        Expanded(
                            flex: 2,
                            child: Container(
                              //height: 50,
                              // color: _selectedIndex != null && _selectedIndex == index
                              //     ? Color(0xFFD6D6D6)
                              //     : Colors.white,
                              child: Row(
                                crossAxisAlignment:
                                CrossAxisAlignment
                                    .center,
                                children: [
                                  Icon(
                                    Icons
                                        .info_outline_rounded,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                      child: Text(
                                        "\u{20B9}${vehicleType.baseRate} \u{2044} Km",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight:
                                            FontWeight
                                                .bold),
                                      )),
                                ],
                              ),
                            ))
                      ],
                    ),

                    SizedBox(height: 16.0),
                    !widget.datum.name!.contains("Outstation")?Container():SizedBox(height: 16.0),

                    !widget.datum.name!.contains("Outstation")?Container():Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.center,
                      children: [
                        Container(
                          // height: 84,
                          margin: EdgeInsets.all(4),

                          child: Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              InkWell(

                                child: Container(
                                    width: MediaQuery.of(context).size.width/2.5,

                                    padding: EdgeInsets.all(4),
                                    margin: EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: oneWayData==1                                    ? Theme.of(context)
                                            .primaryColorDark
                                            : Colors.transparent,
                                        width:
                                        oneWayData==1
                                            ? 1
                                            : 0,
                                      ), //Border.all
                                      borderRadius:
                                      BorderRadius.circular(10),
                                    ),
                                    child: Stack(
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'One-way ',
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(height: 2,),
                                            Text(
                                              'Get dropped off',
                                            ),
                                          ],
                                        ),
                                        oneWayData==1?Positioned(
                                            top: 0,
                                            right: 0,
                                            child: Icon(Icons.check_circle_outline,size: 20,)):Container()

                                      ],
                                    )),
                                onTap: (){
                                  setState(() {
                                    oneWayData=1;


                                    distance=widget.distance;
                                    DateTime? pickedDate=startTime;
                                    if (pickedDate != null) {
                                      String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
                                      endDate=formattedDate;


                                      setState(() {
                                        endTime = pickedDate;
                                      });
                                    }


                                    isNextDay=isSelectedDateNextDay(endTime);
                                    print(isNextDay);

                                    Duration difference = endTime.difference(startTime);
                                    int differenceInDays = difference.inDays+2;

                                    if(isNextDay){
                                      differenceInDays=1;
                                    }
                                    differenceInDays = isNextDay?2:endTime.difference(startTime).inDays==0?1:endTime.difference(startTime).inDays + 2;
                                    if(differenceInDays!=0){
                                      driverBeta=differenceInDays * widget.vehicleTypeModel.driverBetta!;
                                      baseFare=differenceInDays * (baseKm*num.parse(widget.vehicleTypeModel.baseRate.toString()));

                                    }else{
                                      driverBeta=widget.vehicleTypeModel.driverBetta??0;
                                    }
                                    noOfdays=differenceInDays;
                                    calculateKmAndPrice(true);

                                    getVehicleType(1);
                                  });
                                },
                              ),
                              InkWell(

                                child: Container(
                                    width: MediaQuery.of(context).size.width/2.5,

                                    padding: EdgeInsets.all(4),
                                    margin: EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: oneWayData==2                                    ? Theme.of(context)
                                            .primaryColorDark
                                            : Colors.transparent,
                                        width:
                                        oneWayData==2
                                            ? 1
                                            : 0,
                                      ), //Border.all
                                      borderRadius:
                                      BorderRadius.circular(10),
                                    ),
                                    child: Stack(
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Round Trip',
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(height: 2,),
                                            Text(
                                              'Keep the car till return',
                                            ),
                                          ],
                                        ),
                                        oneWayData==2?Positioned(
                                            top: 0,
                                            right: 0,
                                            child: Icon(Icons.check_circle_outline,size: 20,)):Container()
                                      ],
                                    )),
                                onTap: (){
                                  setState(() {
                                    distance=widget.distance*2;

                                    oneWayData=2;
                                    getVehicleType(2);
                                  });
                                },
                              ),

                              // SizedBox(width: 40,),

                            ],
                          ),
                        )
                      ],
                    ),
                    !widget.datum.name!.contains("Outstation")?Container():Divider(thickness: 1.5,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: ()async{
                                final DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2025),
                                );

                                if (pickedDate != null ) {
                                  String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
                                  startDate=formattedDate;
                                  setState(() {
                                    startTime = pickedDate;
                                  });
                                }

                              },
                              child: Column(

                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Travel Date ',style: TextStyle(fontSize: 16.0, color:  Theme.of(context).primaryColor,fontWeight: FontWeight.w600),),
                                  SizedBox(height: 16.0),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.calendar_month,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      SizedBox(width: 10,),
                                      Text(startDate,style: TextStyle(fontSize: 16.0, color:  Theme.of(context).primaryColor,fontWeight: FontWeight.w600),),

                                    ],
                                  ),
                                  Divider(thickness: 2,),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: ()async{
                              },
                              child: Column(

                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Travel Time',style: TextStyle(fontSize: 16.0, color:  Theme.of(context).primaryColor,fontWeight: FontWeight.w600),),
                                  SizedBox(height: 16.0),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.av_timer_sharp,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      SizedBox(width: 10,),
                                      CustomTimePicker(
                                        initialTime: selectedTime,
                                        onTimeSelected: (TimeOfDay time) {
                                          setState(() {
                                            selectedTime = time;
                                          });
                                        },
                                      ),

                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                         oneWayData==2 ? Divider(thickness: 1.5,):Container(),
                         oneWayData==2 ?Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,

                          children: [
                            GestureDetector(
                              onTap: () async{
                                final DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: endTime,
                                  firstDate: startTime,
                                  lastDate: DateTime(2025),
                                );

                                if (pickedDate != null) {
                                  String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
                                  endDate=formattedDate;


                                  setState(() {
                                    endTime = pickedDate;
                                  });
                                }


                                isNextDay=isSelectedDateNextDay(endTime);
                                print(isNextDay);

                                Duration difference = endTime.difference(startTime);
                                int differenceInDays = difference.inDays+2;

                                if(isNextDay){
                                  differenceInDays=1;
                                }
                                differenceInDays = isNextDay?2:endTime.difference(startTime).inDays==0?1:endTime.difference(startTime).inDays + 2;
                                if(differenceInDays!=0){
                                  driverBeta=differenceInDays * widget.vehicleTypeModel.driverBetta!;

                                }else{
                                  driverBeta=widget.vehicleTypeModel.driverBetta??0;
                                }
                                noOfdays=differenceInDays;
                                calculateKmAndPrice(true);

                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Return Date',style: TextStyle(fontSize: 16.0, color:  Theme.of(context).primaryColor,fontWeight: FontWeight.w600),),
                                  SizedBox(height: 16.0),

                                  Row(
                                    children: [
                                      Icon(

                                        Icons.calendar_month,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      SizedBox(width: 10,),
                                      Text(endDate,style: TextStyle(fontSize: 16.0, color:  Theme.of(context).primaryColor,fontWeight: FontWeight.w600),)
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: ()async{

                              },
                              child: Column(

                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Return Time',style: TextStyle(fontSize: 16.0, color:  Theme.of(context).primaryColor,fontWeight: FontWeight.w600),),
                                  SizedBox(height: 16.0),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Icon(
                                        Icons.av_timer_sharp,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      SizedBox(width: 10,),
                                      CustomTimePicker(
                                        initialTime: selectedReturnTime,
                                        onTimeSelected: (TimeOfDay time) {
                                          setState(() {
                                            selectedReturnTime = time;
                                          });
                                        },
                                      ),

                                    ],
                                  ),
                                ],
                              ),
                            ),

                          ],
                        ):
                        /* widget.datum.name=="Rental"?Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Rental Type',style: TextStyle(fontSize: 16.0, color:  Theme.of(context).primaryColor,fontWeight: FontWeight.w600),),
                            SizedBox(height: 16.0),

                            Container(
                              padding: EdgeInsets.only(left: 10.0),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Column(
                                children: [

                                  DropdownButton<String>(
                                    value: selectedValue,
                                    underline: Container(),
                                    onChanged: (newValue) {
                                      if(newValue=="5 hrs / 50 Km"){
                                        baseFare=num.parse(widget.vehicleTypeModel.baseRate.toString())*50;
                                        baseKm=50;
                                      }
                                      if(newValue=="10 hrs / 100 Km"){
                                        baseFare=num.parse(widget.vehicleTypeModel.baseRate.toString())*100;
                                        baseKm=100;

                                      }
                                      if(newValue=="15 hrs / 150 Km"){
                                        baseFare=num.parse(widget.vehicleTypeModel.baseRate.toString())*150;
                                        baseKm=150;

                                      }
                                      calculateKmAndPriceRental(true,int.parse(baseKm.toString()));
                                      setState(() {
                                        selectedValue = newValue!;
                                      });

                                    },
                                    items: dropdownItems.map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ):*/Container(),

                      ],
                    ),

                    Divider(thickness: 1.5,),

                    SizedBox(height: 16.0),

                    Column(
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              color: Theme.of(context).primaryColor,
                            ),
                            SizedBox(width: 10,),
                            Text("Total km : ${widget.datum.name=="Rental"?widget.rentalKm:distance.toStringAsFixed(0)} Km",style: TextStyle(fontSize: 16.0, color:  Theme.of(context).primaryColor,fontWeight: FontWeight.w600),)
                          ],
                        ),
                        SizedBox(height: 10,),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Icon(

                                    Icons.merge_type,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  SizedBox(width: 10,),
                                  Expanded(child: Text("Travel Type : ${widget.datum.name=="Outstation"?oneWayData==1?"Outstation - One-way":"Outstation - Round Trip":widget.datum.name!} ",style: TextStyle(fontSize: 16.0, color:  Theme.of(context).primaryColor,fontWeight: FontWeight.w600),))
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: (){
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Dialog(
                                      // Your custom dialog content
                                      child: Container(
                                        padding: EdgeInsets.all(16.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(height: 10,),

                                            Text('More Info',style: TextStyle(fontSize: 20.0, color:  Theme.of(context).primaryColor,fontWeight: FontWeight.w600), textAlign: TextAlign.start),
                                            SizedBox(height: 20,),
                                            Text('''
 -  Rentals can be used for local travel only. The package cannot be changed after booking is confirmed. \n
 -  For usage beyond the selected package, additional fares will be applicable as per the rates above.
                                                ''',style: TextStyle(fontSize: 16.0, color:  Theme.of(context).primaryColor)),

                                            SizedBox(height: 0,),

                                            Center(
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop(); // Close the dialog
                                                },
                                                child: Text('Close'),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                    return Container(
                                      child: Column(
                                        children: [
                                          Text('More Info'),
                                          Text('''
 -  Rentals can be used for local travel only. The package cannot be changed after booking is confirmed. \n
 -  For usage beyond the selected package, additional fares will be applicable as per the rates above.
                                                '''),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop(); // Close the dialog
                                            },
                                            child: Text('Close'),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },

                              child: Row(
                                children: [
                                  Icon(
                                    Icons
                                        .info_outline_rounded,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(width: 10,),
                                  Text("More Info",style: TextStyle(fontSize: 16.0, color:  Theme.of(context).primaryColor,fontWeight: FontWeight.w600))
                                ],
                              ),
                            ),
                          ],
                        ),

                      ],
                    ),

                    Divider(color: Colors.grey,thickness: 1,),

                    SizedBox(height: 16.0),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Total No of ${widget.datum.name=="Rental"? "Hours":"Days"}: ",style: TextStyle(fontSize: 16.0, color:  Theme.of(context).primaryColor,fontWeight: FontWeight.w600),),
                        widget.datum.name=="Rental"?Text(widget.rentalHrs.toString()+" Hrs",style: TextStyle(fontSize: 16.0, color:  Theme.of(context).primaryColor,fontWeight: FontWeight.w600)):Text("${isNextDay?2:endTime.difference(startTime).inDays==0?1:endTime.difference(startTime).inDays + 2} Days",style: TextStyle(fontSize: 16.0, color:  Theme.of(context).primaryColor,fontWeight: FontWeight.w600),)
                        // Text("${endTime.difference(startTime).inHours/24}")
                      ],
                    ),
                    SizedBox(height: 16.0),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Base Fare (${baseKm.toStringAsFixed(0)} Km)",style: TextStyle(fontSize: 16.0, color:  Theme.of(context).primaryColor,fontWeight: FontWeight.w600),),
                        Text("₹ ${baseFare.toStringAsFixed(0)}",style: TextStyle(fontSize: 16.0, color:  Theme.of(context).primaryColor,fontWeight: FontWeight.w600),)
                      ],
                    ),
                    SizedBox(height: 16.0),

                    widget.datum.name=="Rental"?Container(): Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Add Fare  (${addKm.toStringAsFixed(0)} Km) ",style: TextStyle(fontSize: 16.0, color:  Theme.of(context).primaryColor,fontWeight: FontWeight.w600),),
                        Text("₹ ${addfare.toStringAsFixed(0)}",style: TextStyle(fontSize: 16.0, color:  Theme.of(context).primaryColor,fontWeight: FontWeight.w600),)
                      ],
                    ),
                    driverBeta==0||widget.datum.name=="Rental"?Container(): SizedBox(height: 16.0),

                    driverBeta==0||widget.datum.name=="Rental"?Container(): Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Driver Batta ",style: TextStyle(fontSize: 16.0, color:  Theme.of(context).primaryColor,fontWeight: FontWeight.w600),),
                        Text("₹ ${driverBeta}",style: TextStyle(fontSize: 16.0, color:  Theme.of(context).primaryColor,fontWeight: FontWeight.w600),)
                      ],
                    ),
                    driverBetaAbove ==0 || widget.datum.name=="Rental"?Container(): SizedBox(height: 16.0),

                    driverBetaAbove ==0 || widget.datum.name=="Rental"?Container(): widget.datum.name!.contains("Outstation")?Container():Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Driver Batta (Above 400 Km)",style: TextStyle(fontSize: 16.0, color:  Theme.of(context).primaryColor,fontWeight: FontWeight.w600),),
                        Text("₹ ${driverBetaAbove}",style: TextStyle(fontSize: 16.0, color:  Theme.of(context).primaryColor,fontWeight: FontWeight.w600),)
                      ],
                    ),
                    (widget.datum.name!.contains("Outstation")||widget.datum.name=="Rental")?Container():SizedBox(height: 16.0),

                    SizedBox(height: 16.0),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Tax",style: TextStyle(fontSize: 16.0, color:  Theme.of(context).primaryColor,fontWeight: FontWeight.w600),),
                        Text("₹ ${tax.toStringAsFixed(0)}",style: TextStyle(fontSize: 16.0, color:  Theme.of(context).primaryColor,fontWeight: FontWeight.w600),)
                      ],
                    ),

                    SizedBox(height: 16.0),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Total",style: TextStyle(fontSize: 22.0, color:  Theme.of(context).primaryColor,fontWeight: FontWeight.w800),),
                        Text("₹ ${price.toStringAsFixed(0)}",style: TextStyle(fontSize: 22.0, color:  Theme.of(context).primaryColor,fontWeight: FontWeight.w800),)
                      ],
                    ),
                    SizedBox(height: 16.0),

                    
                    Text("The actual bill amount would differ based on the actual Kms traveled. The Toll, Parking, Hill Charges, and Interstate Permit (if any) are extra.",style: TextStyle(fontSize: 12.0, color:  Theme.of(context).primaryColor,fontWeight: FontWeight.w800))
                    // SizedBox(
                    //   width: double.infinity,
                    //   child:
                    //   ElevatedButton(
                    //     onPressed: () {
                    //       Navigator.push(context, MaterialPageRoute(builder: (context) => MyWebView()),);
                    //
                    //       // fetchEstimatedPrice();
                    //     },
                    //     child: Text('Make Payment'),
                    //   ),
                    // ),
                  ],
                ),
              ),
            )
          ],
        ),
      )


    );
  }
  void createEmergencyContacts(String? str_userid, String name, String mobile, String s) async {
    var connection= await CheckConnection.check();
    if(connection)
    {
      try {
        Dio dio = Dio();
        dio.options.headers['content-Type'] = 'application/json';
        //dio.options.headers["authorization"] = "Token ${token}";
        Response? response;

        response = await dio.post(ApiService.baseUrl+"/booking/create",
            data: {
              "user_id" : str_userid,
              "name":name,
              "emergency_mobile_number":mobile
            },
            options: Options(
              //headers: {"Token": "$token"},
            )
        );


        print("data coming");
        print(response.toString());

        var successresponse=jsonDecode(response.toString());





      } on DioError catch (e) {
        print(e.response!.data);
        print(e.response!.headers);
        //print(e.response!.request);
      }
    }else
    {
      //CheckConnection.showErrorSnackBar(_scafkey.currentState!.context,"No internet connection!");
      setState(() {
      });
    }
  }


  bool isSelectedDateNextDay(DateTime selectedDate) {
    DateTime today = DateTime.now();
    DateTime nextDay = today.add(Duration(days: 1));
    return selectedDate.year == nextDay.year &&
        selectedDate.month == nextDay.month &&
        selectedDate.day == nextDay.day;
  }

}

