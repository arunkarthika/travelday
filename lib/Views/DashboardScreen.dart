import 'dart:async';
// import 'dart:html' as html;
import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:travelday/Utils/Validation.dart';
import 'package:travelday/Views/FavirouteAddressScreen.dart';
import 'package:travelday/Views/SampleSearchPlaces.dart';
import 'package:travelday/Views/ccavenue.dart';
import 'package:travelday/Widgets/navigationdrawer.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

import 'OtpVerification.dart';
import 'ProfileDetailsScreen.dart';

import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:travelday/Services/ApiServices.dart';
import 'package:travelday/Utils/UserStore.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({Key? key}) : super(key: key);

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  final GlobalKey<ScaffoldState> _scafkey = GlobalKey<ScaffoldState>();
  final controller = Completer<GoogleMapController>();

  String? str_selectaddress = "Enter address",
      user_id,
      str_pickup = "Pickup point",
      str_pickupadd = "chennai",
      str_drop = "Drop point",
      str_endlocationname = "endloc",
      str_startlocname = "locname",
      str_dropadd = "chennai";
  late CameraPosition? currentLocationCamera;
  //CameraPosition? _kGooglePlex;
  GoogleMapController? mapController;
  Mode _mode = Mode.overlay;
  TextEditingController emailController = TextEditingController();
  List TravelTypes = [];
  List VehicleType = [];
  List<String> ll_images = [
    "outstation.png",
    "outstation.png",
    "rental.png",
    "railwaystation.png",
    "traveller.png"
  ];
  List<String> ll_names = [
    "Outstation_Oneway",
    "Outstation_Round_Trip",
    "Rental",
    "Airport\$Railway",
    "Tourist Traveller bus"
  ];
  List<String> ll_title = [
    "Outstation",
    "Outstation",
    "Rental",
    "Airport/Railway",
    "Tourist Traveller bus"
  ];
  List<String> ll_subtitle = [
    "Get nearest sedan cars",
    "Get nearest sedan cars",
    "Get nearest sedan cars",
    "Get nearest vehicle",
    "Get nearest vehicle"
  ];
  final RoundedLoadingButtonController _btnController1 =
      RoundedLoadingButtonController();
  int _selectedIndex = 0;
  Set<Marker> _markers = {};
  Uint8List? dropmarkerIcon, pointicon, empicon, pickupmarkerIcon, caricon;
  PolylinePoints polylinePoints = PolylinePoints();
  Map<PolylineId, Polyline> polylines = {};
  final Set<Polyline> _polyline = {};
  double? lat = 0.00,
      lng = 0.00,
      startlat = 00.00,
      startlng = 0.00,
      pickuplat = 0.00,
      pickuplng = 0.00,
      endlat = 0.0,
      endlng = 0.0,
      vechlivelat = 0.0,
      vechlivelng = 0.0;
  var _userAuth = UserStore();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getLoginToken();
    getTravelType();
    getVehicleType('1');
    currentLocationCamera = CameraPosition(
      target: LatLng(13.0302555, 80.2381978),
      zoom: 15,
    );
    setCustomMarker();
  }

  Future<void> getLoginToken() async {
    user_id = await _userAuth.getUserid();
    getTravelType();
  }

  getTravelType() async {
    var responce = await http.get(Uri.parse(ApiService.baseUrl + "traveltype"));
    if (responce.statusCode == 200) {
      setState(() {
        final data = jsonDecode(responce.body);
        TravelTypes = data['data'] as List;
        print(
            "fav test data---------------------------------------------------------------------------------------------------------------------------------> $TravelTypes");
      });
    }
  }

  getVehicleType(travelID) async {
    print('------------------xx-------------------------pinged api');
    var response = await http.get(Uri.parse(
        ApiService.baseUrl + "vehicletype-travel/${travelID.toString()}"));
    print(response.statusCode);
    if (response.statusCode == 200) {
      setState(() {
        final data = jsonDecode(response.body);
        VehicleType = data['data'] as List;
        print(
            "Vehicle Type Data---------------------------------------------------------------------------------------------------------------------------------> $VehicleType");
      });
    }
  }

  void setCustomMarker() async {
    dropmarkerIcon = await getBytesFromAsset('images/destlocation.png', 130);
    pickupmarkerIcon = await getBytesFromAsset('images/startpoint.png', 130);
    //empicon= await getBytesFromAsset('images/emplocation.png', 130);
    //caricon = await getBytesFromAsset('images/taxilocation.png', 130);
    //pointicon= await getBytesFromAsset('images/downarrow.png', 70);
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData? data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  void onError(PlacesAutocompleteResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(response.errorMessage.toString())),
    );
  }

  Future<void> _handlePressButton(String type) async {
    // show input autocomplete with selected mode
    // then get the Prediction selected
    Prediction? p = await PlacesAutocomplete.show(
      context: context,
      apiKey: "AIzaSyAdVwCkz9ebBfq2V-epP3iHVFQ8Zf7SZj8",
      onError: onError,
      offset: 0,
      logo: Text(""),
      radius: 1000,
      strictbounds: false,
      mode: _mode,
      language: "en",
      region: "in",
      types: [""],
      decoration: InputDecoration(
        hintText: 'Search Places',
        focusColor: Colors.grey,
        hintStyle: TextStyle(color: Colors.grey),
        /*focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(0),

          borderSide: BorderSide(

            color: Colors.white,
          ),
        ),*/
      ),
      components: [Component(Component.country, "in")],
    );

    displayPrediction(p!, _scafkey.currentState!, type);
  }

  Future<void> displayPrediction(
      Prediction p, ScaffoldState scaffold, String type) async {
    if (p != null) {
      // get detail (lat/lng)
      GoogleMapsPlaces _places = GoogleMapsPlaces(
        apiKey: "AIzaSyAdVwCkz9ebBfq2V-epP3iHVFQ8Zf7SZj8",
        apiHeaders: await GoogleApiHeaders().getHeaders(),
      );
      PlacesDetailsResponse detail =
          await _places.getDetailsByPlaceId(p.placeId.toString());
      lat = detail.result.geometry!.location.lat;
      lng = detail.result.geometry!.location.lng;

      /*userAuth.setemplat(lat);
      userAuth.setemplng(lng);
      userAuth.setempAddress(p.description.toString());
      */

      /*if(str_select=="boading")
      {
        userAuth.setBoardingAddress(p.description.toString());
        userAuth.addBoardinglat(lat);
        userAuth.addBoardinglng(lng);
        userAuth.setclickboarding(true);
        CheckConnection.showDialog(_scaffoldkey.currentState!.context, SimpleFontelicoProgressDialogType.phoenix, 'Phoenix');
        createBoardingAndDeboarding(str_token!,lat,lng,"boarding",str_branchid!);

      }else if(str_select=="deboading")
      {
        userAuth.setDeBoardingAddress(p.description.toString());
        userAuth.adddeBoardinglat(lat);
        userAuth.adddeBoardinglng(lng);
        userAuth.setclickdeboarding(true);
        createBoardingAndDeboarding(str_token!,lat,lng,"deboarding",str_branchid!);
      }*/

      setState(() {
        //getemployeeData();
        str_selectaddress = p.description.toString();
        if (type == "pickup") {
          if (p.description.toString().length >= 40) {
            str_pickup = p.description.toString().substring(0, 40) + "....";
          } else {
            str_pickup = p.description.toString();
          }
          startlat = lat;
          startlng = lng;
        } else if (type == "drop") {
          if (p.description.toString().length >= 40) {
            str_drop = p.description.toString().substring(0, 40) + "....";
          } else {
            str_drop = p.description.toString();
          }
          endlat = lat;
          endlng = lng;
        }
      });

      /*scaffold.showSnackBar(
        SnackBar(content: Text("${p.description} - $lat/$lng")),
      );*/
    }
  }

  _onSelected(int index) {
    setState(() => _selectedIndex = index);
  }

  Set<Marker> getmarkers() {
    //markers to place on map
    //setState(() {
    // latlng.clear();
    setState(() {
      //latlng.add(LatLng(13.0109, 80.2354));
      //latlng.add(LatLng(13.0067, 80.2206));
      //latlng.add(LatLng(13.0213, 80.2231));
      //latlng.add(LatLng(13.9815,80.2180));
      //print("latlng---->>>>>$latlng");

      _markers.add(Marker(
        //add first marker
        markerId: const MarkerId('pickup'),
        //position:  LatLng(pickuplat!, pickuplng!),
        position: LatLng(startlat!, startlng!), //position of marker
        /*infoWindow:  InfoWindow( //popup info
          title: str_endlocationname,
          snippet: str_pickupadd!,
        ),*/
        icon: pickupmarkerIcon == null
            ? BitmapDescriptor.defaultMarker
            : BitmapDescriptor.fromBytes(pickupmarkerIcon!), //Icon for Marker
      ));

      /*_markers.add(Marker( //add first marker
        markerId: const MarkerId('vechloc'),
        //position:  LatLng(pickuplat!, pickuplng!),
        position:  LatLng(vechlivelat!, vechlivelng!), //position of marker
        infoWindow:  InfoWindow( //popup info
          //title: str_endlocationname,
          //snippet: str_pickupadd!,
        ),
        icon: caricon==null?BitmapDescriptor.defaultMarker:BitmapDescriptor.fromBytes(caricon!), //Icon for Marker
      ));*/
      _markers.add(Marker(
        //add second marker
        markerId: const MarkerId('drop'),
        position: LatLng(endlat!, endlng!), //position of marker
        /*infoWindow:  InfoWindow( //popup info
          title: str_startlocname,
          snippet: str_dropadd!,
        ),*/
        icon: dropmarkerIcon == null
            ? BitmapDescriptor.defaultMarker
            : BitmapDescriptor.fromBytes(dropmarkerIcon!), //Icon for Marker
      ));

      currentLocationCamera =
          CameraPosition(target: LatLng(startlat!, startlng!), zoom: 13.0);
      if (mapController != null)
        mapController!.animateCamera(
            CameraUpdate.newCameraPosition(currentLocationCamera!));

      if (startlat != null && endlat != null) {
        _getPolyline();
      }

      /*_markers.add( Marker( //add second marker
        markerId: const MarkerId('employee'),
        position:  LatLng(pickuplat!, pickuplng!), //position of marker
        infoWindow:  InfoWindow( //popup info
          title: str_pickupadd,
          //snippet: str_dropadd!,
        ),
        icon: empicon==null?BitmapDescriptor.defaultMarker:BitmapDescriptor.fromBytes(empicon!), //Icon for Marker
      ));*/

      //ll_list.add(latlng);
      //convertToLatLng(ll_list);
      /*_polyline.add(Polyline(
        polylineId: PolylineId("pop"),
        visible: true,
        //latlng is List<LatLng>
        //startCap: Cap.customCapFromBitmap(BitmapDescriptor.defaultMarker),
        //endCap: Cap.customCapFromBitmap(BitmapDescriptor.defaultMarkerWithHue(90)),
        points: latlng,
        width: 3,
        //jointType: JointType.mitered,
        color: Colors.black45,
      ));*/

      /*for(int i=0;i<latlng.length;i++)
      {
        _markers.add( Marker( //add second marker
          markerId:  MarkerId(i.toString()),
          position:  latlng[i], //position of marker
          infoWindow:  InfoWindow( //popup info
            title: 'Start Location',
            snippet: str_dropadd!,
          ),

          icon:pointicon==null?BitmapDescriptor.defaultMarker:BitmapDescriptor.fromBytes(pointicon!),
          //Icon for Marker
          //icon:BitmapDescriptor.defaultMarker
        ));
      }*/

      /*latlng1.add(LatLng(13.0067, 80.2206));
      latlng1.add(LatLng(13.0213, 80.2231));

      _polyline.add(Polyline(
        polylineId: PolylineId("pop1"),
        visible: true,
        //latlng is List<LatLng>
        //startCap: Cap.customCapFromBitmap(BitmapDescriptor.defaultMarker),
        //endCap: Cap.customCapFromBitmap(BitmapDescriptor.defaultMarkerWithHue(90)),
        points: latlng1,
        width: 3,
        color: Colors.red,
      ));*/
    });
    /* Future.delayed(const Duration(milliseconds: 0), () {
        // Here you can write your code
          setState(() {
            */ /*_markers.add(Marker( //add first marker
              markerId: const MarkerId('pickup'),
              position:  LatLng(pickuplat!, pickuplng!), //position of marker
              infoWindow:  InfoWindow( //popup info
                title: 'Pickup Location ',
                snippet: str_pickupadd!,
              ),
              icon: BitmapDescriptor.fromBytes(dropmarkerIcon!), //Icon for Marker
            ));

            _markers.add( Marker( //add second marker
              markerId: const MarkerId('drop'),
              position:  LatLng(startlat!, startlng!), //position of marker
              infoWindow:  InfoWindow( //popup info
                title: 'Start Location',
                snippet: str_dropadd!,
              ),
              icon: BitmapDescriptor.fromBytes(pickupmarkerIcon!), //Icon for Marker
            ));*/ /*
          });
          latlng.add(LatLng(13.0109, 80.2354));
          latlng.add(LatLng(13.0067, 80.2206));
          //latlng.add(LatLng(13.0213, 80.2231));
          //latlng.add(LatLng(13.9815,80.2180));
          print("latlng---->>>>>$latlng");
          for(int i=0;i<latlng.length;i++)
            {
              _markers.add( Marker( //add second marker
                markerId:  MarkerId(i.toString()),
                position:  latlng[i], //position of marker
                infoWindow:  InfoWindow( //popup info
                  title: 'Start Location',
                  snippet: str_dropadd!,
                ),
                icon: BitmapDescriptor.fromBytes(pickupmarkerIcon!), //Icon for Marker
              ));
            }


          //ll_list.add(latlng);
          //convertToLatLng(ll_list);
          _polyline.add(Polyline(
            polylineId: PolylineId("pop"),
            visible: true,
            //latlng is List<LatLng>
            //startCap: Cap.customCapFromBitmap(BitmapDescriptor.defaultMarker),
            //endCap: Cap.customCapFromBitmap(BitmapDescriptor.defaultMarkerWithHue(90)),
            points: latlng,
            width: 3,
            color: Colors.blue,
          ));
          latlng1.add(LatLng(13.0067, 80.2206));
          latlng1.add(LatLng(13.0213, 80.2231));

          _polyline.add(Polyline(
            polylineId: PolylineId("pop1"),
            visible: true,
            //latlng is List<LatLng>
            //startCap: Cap.customCapFromBitmap(BitmapDescriptor.defaultMarker),
            //endCap: Cap.customCapFromBitmap(BitmapDescriptor.defaultMarkerWithHue(90)),
            points: latlng1,
            width: 3,
            color: Colors.red,
          ));
          _getPolyline();

        //add more markers here
      });*/

    // });

    return _markers;
  }

  _addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      points: polylineCoordinates,
      width: 3,
    );
    polylines[id] = polyline;
    setState(() {});
  }

  void _getPolyline() async {
    List<LatLng> polylineCoordinates = [];
    //AIzaSyCkYlzM2U_bwP8qXlGuwzPN14UxiH_gNZM
    // print("StartLoc====${startlat},${startlng}");
    // print("EndtartLoc====${endlat},${endlng}");

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyAdVwCkz9ebBfq2V-epP3iHVFQ8Zf7SZj8",
      PointLatLng(startlat!, startlng!),
      PointLatLng(endlat!, endlng!),
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result.errorMessage);
    }
    _addPolyLine(polylineCoordinates);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scafkey,
      drawer: NavigationDrawerNew(_scafkey,''),
      appBar: AppBar(
        backgroundColor: Color(0xFF013B46),
        //leadingWidth: 35,
        titleSpacing: -5,
        title: Container(
            //color:Colors.red,
            child: Image.asset(
          'images/logo.png',
          height: 40,
          width: 110,
        )),
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileDetailScreen()),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(
                Icons.person_outline,
                color: Colors.white,
                size: 25,
              ),
            ),
          )
        ],
      ),
      body: Stack(
        alignment: AlignmentDirectional.topEnd,
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: currentLocationCamera!,
            rotateGesturesEnabled: false,
            tiltGesturesEnabled: false,
            trafficEnabled: false,

            //buildingsEnabled: true,
            //indoorViewEnabled: true,
            //liteModeEnabled: true,

            mapToolbarEnabled: false,
            myLocationEnabled: false,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            onMapCreated: (GoogleMapController gcontroller) {
              //_controller1 = controller;
              controller.complete(gcontroller);

              // controller.complete(controller);
            },
            //markers: Set<Marker>.of(snapshot.data ?? []),
            polylines: Set<Polyline>.of(polylines.values),
            markers: getmarkers(),
            padding: EdgeInsets.all(8),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              //color: Colors.red,
              padding: EdgeInsets.all(20),
              height: 140,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    //color: Colors.greyckup,
                    //margin: EdgeInsets.all(8),
                    height: 40,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: Row(
                      children: [
                        Expanded(
                            flex: 1,
                            child: Container(
                              padding: EdgeInsets.only(left: 10),
                              //color: Colors.red,
                              child: Icon(
                                Icons.location_on,
                                size: 25,
                                color: Colors.green,
                              ),
                            )),
                        Expanded(
                            flex: 9,
                            child: InkWell(
                              onTap: () {
                                _handlePressButton("pickup");
                                //Navigator.push(context, MaterialPageRoute(builder: (context) => RoutesWidget()),);
                              },
                              child: Container(
                                //color: Colors.blue,
                                padding: EdgeInsets.only(left: 10),
                                child: Text(str_pickup!,
                                    style: TextStyle(
                                        color: Color(0xFF013B46),
                                        fontWeight: FontWeight.bold)),
                              ),
                            )),
                        Expanded(
                            flex: 1,
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            FavirouteAddressScreen(
                                              str_place: str_selectaddress!,
                                              pickuplat: lat!,
                                              pickuplng: lng!,
                                            )));
                              },
                              child: Container(
                                  //color: Colors.red,
                                  padding: EdgeInsets.only(right: 10),
                                  //color: Colors.yellow,
                                  child: Icon(
                                    Icons.favorite_border,
                                    size: 20,
                                    color: Color(0xFF013B46),
                                  )),
                            )),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    //color: Colors.grey,
                    //margin: EdgeInsets.all(8),
                    height: 40,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: Row(
                      children: [
                        Expanded(
                            flex: 1,
                            child: Container(
                              padding: EdgeInsets.only(left: 10),
                              //color: Colors.red,
                              child: Icon(
                                Icons.location_on,
                                size: 25,
                                color: Colors.red,
                              ),
                            )),
                        Expanded(
                            flex: 9,
                            child: InkWell(
                              onTap: () {
                                _handlePressButton("drop");
                              },
                              child: Container(
                                //color: Colors.blue,
                                padding: EdgeInsets.only(left: 10),
                                child: Text(
                                  str_drop!,
                                  style: TextStyle(
                                      color: Color(0xFF013B46),
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )),
                        Expanded(
                            flex: 1,
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            FavirouteAddressScreen(
                                              str_place: str_selectaddress!,
                                              pickuplat: lat!,
                                              pickuplng: lng!,
                                            )));
                              },
                              child: Container(
                                  padding: EdgeInsets.only(right: 10),
                                  //color: Colors.yellow,
                                  child: Icon(
                                    Icons.favorite_border,
                                    size: 20,
                                    color: Color(0xFF013B46),
                                  )),
                            )),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  /*side: BorderSide(
                    //color: Colors.greenAccent,
                  ),*/
                  borderRadius: BorderRadius.circular(10.0), //<-- SEE HERE
                ),
                elevation: 10,
                child: Container(
                  margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  height: 320,
                  //color: Colors.red,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(
                            10.0) //                 <--- border radius here
                        ),
                  ),
                  child: Column(
                    //crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        //color: Colors.red,
                        height: 250,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 3,
                              child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: TravelTypes.length,
                                itemBuilder: (BuildContext context, index) =>
                                    Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      child: InkWell(
                                        onTap: () {
                                          print(
                                              "---------------------------------------------------------------------------------->>>>>>  tapped on " +
                                                  TravelTypes[index]['name']);
                                          getVehicleType(
                                              TravelTypes[index]['id']);
                                        },
                                        //color: Colors.green,
                                        //height: 40,
                                        //width: 90,
                                        child: Column(
                                          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                                //color: Colors.red,
                                                height: 50,
                                                child: Image(
                                                  image: AssetImage(
                                                      "images/${ll_images[index]}"),
                                                  height: 70,
                                                  width: 70,
                                                )),
                                            //SizedBox(width: 40,),
                                            Container(
                                                //height:40,
                                                alignment: Alignment.center,
                                                width: 100,
                                                child: Text(
                                                  TravelTypes[index]['name'],
                                                  textAlign: TextAlign.center,
                                                )),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: ListView.builder(
                                  itemCount: VehicleType.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return InkWell(
                                      onTap: () {
                                        _onSelected(index);
                                      },
                                      child: Column(
                                        children: [
                                          Container(
                                            color: _selectedIndex != null &&
                                                    _selectedIndex == index
                                                ? Color(0xFFD6D6D6)
                                                : Colors.white,
                                            child: Row(
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
                                                                  VehicleType[
                                                                          index]
                                                                      ['name'],
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold))),
                                                          Container(
                                                              child: Text(
                                                            "Base ${VehicleType[
                                                                        index]
                                                                    ['basekm']} km",
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
                                                            "\u{20B9}${VehicleType[index]['baseRate']} \u{2044} km",
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
                                          ),
                                          Divider(
                                            color: Colors.grey,
                                          )
                                        ],
                                      ),
                                    );
                                  }),
                            ),
                          ],
                        ),
                      ),
                      //SizedBox(height: 10,),
                      Container(
                        height: 60,
                        //color: Colors.red,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: RoundedLoadingButton(
                              successIcon: Icons.check_circle,
                              height: 40,
                              width: 350,
                              successColor: Colors.green,
                              failedIcon: Icons.error,
                              borderRadius: 5,
                              color: Color(0xFF013B46),
                              child: Text(
                                "Book Now",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                              controller: _btnController1,
                              onPressed: () async {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => CCAVENE()),);
                                var connection = await CheckConnection.check();

                                if (connection) {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  print("email:" + emailController.text);
                                  // print("password:"+passwordController.text);
                                  _btnController1.stop();
                                } else {
                                  _btnController1.stop();
                                  //CheckConnection.showErrorSnackBar(_scafkey.currentState!.context,"No Internet Connection!");
                                  Validation.showNointernetErrormessage(
                                      _scafkey, 'No internet connection.');
                                }

                                //CheckConnection.showDialog(_scaffoldkey.currentState!.context, SimpleFontelicoProgressDialogType.phoenix, 'Phoenix');
                              }
                              // => _doSomething(_btnController1),
                              ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 120,
            right: 20,
            child: InkWell(
              onTap: () {
                Validation.ValidationAlert(context, "Are you in an Emergency?");
              },
              child: Container(
                height: 40,
                width: 110,
                alignment: Alignment.center,
                //color: Colors.redAccent,
                decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(30)),
                child: Text(
                  "Emergency",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
      // drawer: NavigationDrawer(_scafkey, "Name"),
    );
  }
}
