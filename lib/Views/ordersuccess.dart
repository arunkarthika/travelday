import 'dart:convert';
import 'dart:core';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:travelday/Modal/TravelTypeList.dart';
import 'package:travelday/Modal/VehicleTypeTypeList.dart';
import 'package:travelday/Services/ApiServices.dart';
import 'package:travelday/Utils/CustomTimePicker.dart';
import 'package:travelday/Views/MyWebView.dart';
import 'package:travelday/Views/ccavenue.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

class OrderSuccess extends StatefulWidget {
  final String pickup_location;
  final String drop_location;
  final String travel_date;
  final String travel_time;
  final String travel_type;
  final String vehicle_type;
  final int user_id;
  final String driver_beta;
  final String total_amount;
  final String payment_stauts;
  final String total_km;

  OrderSuccess(
      this.pickup_location,
      this.drop_location,
      this.travel_date,
      this.travel_time,
      this.travel_type,
      this.vehicle_type,
      this.user_id,
      this.driver_beta,
      this.total_amount,
      this.payment_stauts,
      this.total_km);

  @override
  _OrderSuccessState createState() => _OrderSuccessState();
}

class _OrderSuccessState extends State<OrderSuccess>
    with TickerProviderStateMixin {
  String startDate = "";
  DateTime startTime = DateTime.now();
  DateTime endTime = DateTime.now();
  String endDate = "";
  num totalKm = 0;
  num baseKm = 0;
  num addKm = 0;
  num price = 0;
  num baseFare = 0;
  num addfare = 0;
  int driverBeta = 0;
  int driverBetaAbove = 0;
  num tax = 0;
  TimeOfDay selectedTime = TimeOfDay.now();
  TimeOfDay selectedReturnTime = TimeOfDay.now();
  List VehicleType = [];

  bool isNextDay = false;

  String selectedValue = '5 hrs / 50 Km';
  List<String> dropdownItems = [
    '5 hrs / 50 Km',
    '10 hrs / 100 Km',
    '15 hrs / 150 Km'
  ];
  VehicleTypeTypeList vehicleTypeTypeList = VehicleTypeTypeList();
  VehicleTypeModel vehicleType = VehicleTypeModel();

  int oneWayData = 1;
  int noOfdays = 1;
  double distance = 1;

  late final AnimationController _controller;

  @override
  void initState() {
    // TODO: implement initState
    _controller = AnimationController(vsync: this);

    // getTravelType();
    // getVehicleType('1');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   title: Text(' Price Estimation'),
        // ),
        // persistentFooterButtons: [
        //   Column(
        //     children: [
        //       SizedBox(
        //         width: MediaQuery.of(context).size.width,
        //         child: ElevatedButton(
        //           onPressed: () {
        //             Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyWebView(amount: price,address: '',city: '',billingEmail: '', delAddress: '',delName: '',delPh: '',delState: '',name: '',redirectUrl: '',telph: '',)),);
        //
        //             // fetchEstimatedPrice();
        //           },
        //           child: Text('Make Payment'),
        //         ),
        //       ),
        //       SizedBox(
        //         width: MediaQuery.of(context).size.width,
        //         child: ElevatedButton(
        //           onPressed: () {
        //             Navigator.of(context).pop();
        //
        //             // Navigator.push(context, MaterialPageRoute(builder: (context) => MyWebView(amount: price,address: '',city: '',billingEmail: '', delAddress: '',delName: '',delPh: '',delState: '',name: '',redirectUrl: '',telph: '',)),);
        //
        //             // fetchEstimatedPrice();
        //           },
        //           child: Text('Pay Later'),
        //         ),
        //       ),
        //     ],
        //   )
        // ],
        body: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(0, 80, 0, 0),
                child: Center(
                  child: Lottie.asset(
                    height: 200,
                    repeat: true,
                    'images/code_invite_success.json',
                    controller: _controller,
                    onLoaded: (composition) {
                      // Configure the AnimationController with the duration of the
                      // Lottie file and start the animation.
                      _controller
                        ..duration = composition.duration
                        ..forward();
                    },
                  ),
                ),
              ),
              SizedBox(height: 40,),

              // Image.asset("images/img_1.png",height: 300,),
              Positioned(
                  top: 20,
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: Theme.of(context).primaryColor,
                          size: 24,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      Text(
                        'Order Details',
                        style: TextStyle(
                            fontSize: 20.0,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w600),
                      )
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
                  Text(
                    'Pickup Location',
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Colors.green,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width - 66,
                          child: Expanded(
                              child: Text(
                            widget.pickup_location,
                            style: TextStyle(
                                fontSize: 16.0,
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w600),
                          )))
                    ],
                  ),
                  Divider(
                    color: Colors.grey,
                    thickness: 1,
                  ),
                  SizedBox(height: 16.0),
                  widget.travel_type == "Rental"
                      ? Container()
                      : Text(
                          'Drop Location',
                          style: TextStyle(
                              fontSize: 16.0,
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w600),
                        ),
                  widget.travel_type == "Rental"
                      ? Container()
                      : SizedBox(height: 16.0),
                  widget.travel_type == "Rental"
                      ? Container()
                      : Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: Colors.red,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                                width: MediaQuery.of(context).size.width - 66,
                                child: Container(
                                    width:
                                        MediaQuery.of(context).size.width - 66,
                                    child: Text(
                                      widget.drop_location,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.w600),
                                    )))
                          ],
                        ),
                  widget.travel_type == "Rental"
                      ? Container()
                      : Divider(
                          color: Colors.grey,
                          thickness: 1,
                        ),

                  SizedBox(height: 16.0),
                  // !widget.travel_type!.contains("Outstation")
                  //     ? Container()
                  //     : SizedBox(height: 16.0),

                  // !widget.travel_type!.contains("Outstation")
                  //     ? Container()
                  //     : Divider(
                  //         thickness: 1.5,
                  //       ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              final DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2025),
                              );

                              if (pickedDate != null) {
                                String formattedDate =
                                    DateFormat('dd/MM/yyyy').format(pickedDate);
                                startDate = formattedDate;
                                setState(() {
                                  startTime = pickedDate;
                                });
                              }
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Travel Date ',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(height: 16.0),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_month,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      widget.travel_date,
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                                Divider(
                                  thickness: 2,
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {},
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Travel Time',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(height: 16.0),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.av_timer_sharp,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
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
                      oneWayData == 2
                          ? Divider(
                              thickness: 1.5,
                            )
                          : Container(),
                      oneWayData == 2
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    final DateTime? pickedDate =
                                        await showDatePicker(
                                      context: context,
                                      initialDate: endTime,
                                      firstDate: startTime,
                                      lastDate: DateTime(2025),
                                    );

                                    if (pickedDate != null) {
                                      String formattedDate =
                                          DateFormat('dd/MM/yyyy')
                                              .format(pickedDate);
                                      endDate = formattedDate;

                                      setState(() {
                                        endTime = pickedDate;
                                      });
                                    }

                                    isNextDay = isSelectedDateNextDay(endTime);
                                    print(isNextDay);

                                    Duration difference =
                                        endTime.difference(startTime);
                                    int differenceInDays =
                                        difference.inDays + 2;

                                    if (isNextDay) {
                                      differenceInDays = 1;
                                    }
                                    differenceInDays = isNextDay
                                        ? 2
                                        : endTime
                                                    .difference(startTime)
                                                    .inDays ==
                                                0
                                            ? 1
                                            : endTime
                                                    .difference(startTime)
                                                    .inDays +
                                                2;
                                    noOfdays = differenceInDays;
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Return Date',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      SizedBox(height: 16.0),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.calendar_month,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            endDate,
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontWeight: FontWeight.w600),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () async {},
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Return Time',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      SizedBox(height: 16.0),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(
                                            Icons.av_timer_sharp,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
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
                            )
                          :
                          /* widget.travel_type=="Rental"?Column(
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
                        ):*/
                          Container(),
                    ],
                  ),

                  Divider(
                    thickness: 1.5,
                  ),

                  SizedBox(height: 16.0),

                  Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            color: Theme.of(context).primaryColor,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Total km : ${widget.total_km} Km",
                            style: TextStyle(
                                fontSize: 16.0,
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
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
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                    child: Text(
                                  "Travel Type : ${widget.travel_type} ",
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.w600),
                                ))
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
 //                      Row(
 //                        mainAxisAlignment: MainAxisAlignment.end,
 //                        children: [
 //                          GestureDetector(
 //                            onTap: () {
 //                              showDialog(
 //                                context: context,
 //                                builder: (BuildContext context) {
 //                                  return Dialog(
 //                                    // Your custom dialog content
 //                                    child: Container(
 //                                      padding: EdgeInsets.all(16.0),
 //                                      child: Column(
 //                                        mainAxisSize: MainAxisSize.min,
 //                                        crossAxisAlignment:
 //                                            CrossAxisAlignment.start,
 //                                        children: [
 //                                          SizedBox(
 //                                            height: 10,
 //                                          ),
 //                                          Text('More Info',
 //                                              style: TextStyle(
 //                                                  fontSize: 20.0,
 //                                                  color: Theme.of(context)
 //                                                      .primaryColor,
 //                                                  fontWeight: FontWeight.w600),
 //                                              textAlign: TextAlign.start),
 //                                          SizedBox(
 //                                            height: 20,
 //                                          ),
 //                                          Text('''
 // -  Rentals can be used for local travel only. The package cannot be changed after booking is confirmed. \n
 // -  For usage beyond the selected package, additional fares will be applicable as per the rates above.
 //                                                ''',
 //                                              style: TextStyle(
 //                                                  fontSize: 16.0,
 //                                                  color: Theme.of(context)
 //                                                      .primaryColor)),
 //                                          SizedBox(
 //                                            height: 0,
 //                                          ),
 //                                          Center(
 //                                            child: ElevatedButton(
 //                                              onPressed: () {
 //                                                Navigator.of(context)
 //                                                    .pop(); // Close the dialog
 //                                              },
 //                                              child: Text('Close'),
 //                                            ),
 //                                          ),
 //                                        ],
 //                                      ),
 //                                    ),
 //                                  );
 //                                  return Container(
 //                                    child: Column(
 //                                      children: [
 //                                        Text('More Info'),
 //                                        Text('''
 // -  Rentals can be used for local travel only. The package cannot be changed after booking is confirmed. \n
 // -  For usage beyond the selected package, additional fares will be applicable as per the rates above.
 //                                                '''),
 //                                        TextButton(
 //                                          onPressed: () {
 //                                            Navigator.of(context)
 //                                                .pop(); // Close the dialog
 //                                          },
 //                                          child: Text('Close'),
 //                                        ),
 //                                      ],
 //                                    ),
 //                                  );
 //                                },
 //                              );
 //                            },
 //                            child: Row(
 //                              children: [
 //                                Icon(
 //                                  Icons.info_outline_rounded,
 //                                  color: Colors.grey,
 //                                ),
 //                                SizedBox(
 //                                  width: 10,
 //                                ),
 //                                Text("More Info",
 //                                    style: TextStyle(
 //                                        fontSize: 16.0,
 //                                        color: Theme.of(context).primaryColor,
 //                                        fontWeight: FontWeight.w600))
 //                              ],
 //                            ),
 //                          ),
 //                        ],
 //                      ),
                    ],
                  ),

                  Divider(
                    color: Colors.grey,
                    thickness: 1,
                  ),

                  SizedBox(height: 16.0),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total No of ${widget.travel_type == "Rental" ? "Hours" : "Days"}: ",
                        style: TextStyle(
                            fontSize: 16.0,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w600),
                      ),
                      widget.travel_type == "Rental"
                          ? Text(widget.travel_time.toString() + " Hrs",
                              style: TextStyle(
                                  fontSize: 16.0,
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w600))
                          : Text(
                              "${widget.travel_date} Days",
                              style: TextStyle(
                                  fontSize: 16.0,
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w600),
                            )
                      // Text("${endTime.difference(startTime).inHours/24}")
                    ],
                  ),
                  SizedBox(height: 16.0),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Base Fare (${baseKm.toStringAsFixed(0)} Km)",
                        style: TextStyle(
                            fontSize: 16.0,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "₹ ${widget.total_amount}",
                        style: TextStyle(
                            fontSize: 16.0,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                  SizedBox(height: 16.0),

                  widget.travel_type == "Rental"
                      ? Container()
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Add Fare  (${addKm.toStringAsFixed(0)} Km) ",
                              style: TextStyle(
                                  fontSize: 16.0,
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w600),
                            ),
                            Text(
                              "₹ ${addfare.toStringAsFixed(0)}",
                              style: TextStyle(
                                  fontSize: 16.0,
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w600),
                            )
                          ],
                        ),
                  driverBeta == 0 || widget.travel_type == "Rental"
                      ? Container()
                      : SizedBox(height: 16.0),

                  driverBeta == 0 || widget.travel_type == "Rental"
                      ? Container()
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Driver Batta ",
                              style: TextStyle(
                                  fontSize: 16.0,
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w600),
                            ),
                            Text(
                              "₹ ${driverBeta}",
                              style: TextStyle(
                                  fontSize: 16.0,
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w600),
                            )
                          ],
                        ),
                  driverBetaAbove == 0 || widget.travel_type == "Rental"
                      ? Container()
                      : SizedBox(height: 16.0),

                  driverBetaAbove == 0 || widget.travel_type == "Rental"
                      ? Container()
                      : widget.travel_type!.contains("Outstation")
                          ? Container()
                          : Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Driver Batta (Above 400 Km)",
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  "₹ ${driverBetaAbove}",
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.w600),
                                )
                              ],
                            ),
                  (widget.travel_type!.contains("Outstation") ||
                          widget.travel_type == "Rental")
                      ? Container()
                      : SizedBox(height: 16.0),

                  SizedBox(height: 16.0),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Tax",
                        style: TextStyle(
                            fontSize: 16.0,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "₹ ${tax.toStringAsFixed(0)}",
                        style: TextStyle(
                            fontSize: 16.0,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w600),
                      )
                    ],
                  ),

                  SizedBox(height: 16.0),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total",
                        style: TextStyle(
                            fontSize: 22.0,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w800),
                      ),
                      Text(
                        "₹ ${widget.total_amount}",
                        style: TextStyle(
                            fontSize: 22.0,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w800),
                      )
                    ],
                  ),
                  SizedBox(height: 16.0),

                  Text(
                      "The actual bill amount would differ based on the actual Kms traveled. The Toll, Parking, Hill Charges, and Interstate Permit (if any) are extra.",
                      style: TextStyle(
                          fontSize: 12.0,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w800))
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
    ));
  }

  bool isSelectedDateNextDay(DateTime selectedDate) {
    DateTime today = DateTime.now();
    DateTime nextDay = today.add(Duration(days: 1));
    return selectedDate.year == nextDay.year &&
        selectedDate.month == nextDay.month &&
        selectedDate.day == nextDay.day;
  }
}
