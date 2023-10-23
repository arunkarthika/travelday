import 'dart:async';

// import 'dart:html' as html;
import 'dart:io';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:travelday/Modal/TravelTypeList.dart';
import 'package:travelday/Modal/VehicleTypeTypeList.dart';
import 'package:travelday/Utils/Validation.dart';
import 'package:travelday/Views/FavirouteAddressScreen.dart';
import 'package:travelday/Views/SampleSearchPlaces.dart';
import 'package:travelday/Views/ccavenue.dart';
import 'package:travelday/Views/estimation.dart';
import 'package:travelday/Widgets/navigationdrawer.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';
import 'package:flutter_polyline_points/flutter_polyline_points.dart' as poly;

import 'OtpVerification.dart';
import 'ProfileDetailsScreen.dart';

import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:travelday/Services/ApiServices.dart';
import 'package:travelday/Utils/UserStore.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart' as perm;
import 'package:intl/intl.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';

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
  int _selectedTravelType = 0;
  Set<Marker> _markers = {};
  Uint8List? dropmarkerIcon, pointicon, empicon, pickupmarkerIcon, caricon;
  poly.PolylinePoints polylinePoints = poly.PolylinePoints();
  Map<PolylineId, Polyline> polylines = {};
  final Set<Polyline> _polyline = {};
  TravelTypeList travelTypeList = TravelTypeList();
  Datum travelType = Datum();

  String startDate = "";
  DateTime startTime = DateTime.now().copyWith(hour: 0, minute: 0, second: 0);
  DateTime endTime = DateTime.now().copyWith(hour: 0, minute: 0, second: 0);
  String endDate = "";
  bool _isChecked = false;
  int oneWayData = 1;


  VehicleTypeTypeList vehicleTypeTypeList = VehicleTypeTypeList();

  VehicleTypeModel vehicleType = VehicleTypeModel();
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

  String googleAPiKey = "AIzaSyDZyerp9IDsBagJGw7zlqr9jRFJB_j9UYc";

  Set<Marker> markers = Set(); //markers for google map

  LatLng startLocation = LatLng(27.6683619, 85.3101895);
  LatLng endLocation = LatLng(27.6875436, 85.2751138);

  double distance = 0.0;
  SharedPreferences? sharedPreferences;

  int rentalSelectionIndex=0;
  int rentalKm=50;
  int rentalHrs=5;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setDateAndTime();
    getLocation();
    getLoginToken();
    getTravelType();
    getVehicleType('1');
    currentLocationCamera = CameraPosition(
      target: LatLng(13.0302555, 80.2381978),
      zoom: 12,
    );
    setCustomMarker();
    // setLocation();
  }



  void setLocation()async{
   Position position=await _determinePosition();

    if(position!=null){
     str_pickup = position.floor.toString();
     startlat = position.latitude;
     startlng = position.longitude;
     convertToAddress(startlat!!, startlng!!, googleAPiKey);
   }

  }

  convertToAddress(double lat, double long, String apikey) async {
    Dio dio = Dio();  //initilize dio package
    String apiurl = "https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$long&key=$apikey";

    Response response = await dio.get(apiurl); //send get request to API URL

    if(response.statusCode == 200){ //if connection is successful
      Map data = response.data; //get response data
      if(data["status"] == "OK"){ //if status is "OK" returned from REST API
        if(data["results"].length > 0){ //if there is atleast one address
          Map firstresult = data["results"][0]; //select the first address

         String address = firstresult["formatted_address"]; //get the address

          //you can use the JSON data to get address in your own format

          setState(() {
            //refresh UI
          });
        }
      }else{
        print(data["error_message"]);
      }
    }else{
      print("error while fetching geoconding data");
    }
  }



  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  void setDateAndTime() async {
    sharedPreferences = await SharedPreferences.getInstance();

    str_pickup = sharedPreferences!.getString("desc") ?? str_pickup;
    startlat = sharedPreferences!.getDouble("startlat") ?? startlat;
    startlng = sharedPreferences!.getDouble("startlng") ?? startlng;
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd/MM/yyyy').format(now);
    startDate = formattedDate;
    endDate = formattedDate;

    setState(() {});
  }

  Future<void> getLoginToken() async {
    user_id = await _userAuth.getUserid();
    getTravelType();
  }

  getLocation() async {
    perm.Location location = new perm.Location();
    bool ison = await location.serviceEnabled();
    if (!ison) {
      //if defvice is off
      bool isturnedon = await location.requestService();
      if (isturnedon) {
        print("GPS device is turned ON");
      } else {
        const snackBar = SnackBar(
          content: Text('Please enable Gps'),
        );

// Find the ScaffoldMessenger in the widget tree
// and use it to show a SnackBar.
        ScaffoldMessenger.of(context).showSnackBar(snackBar);

        print("GPS Device is still OFF");
      }
    }
  }

  getTravelType() async {
    var responce = await http.get(Uri.parse(ApiService.baseUrl + "traveltype"));
    if (responce.statusCode == 200) {
      print(jsonDecode(responce.body));
      travelTypeList = TravelTypeList.fromJson(jsonDecode(responce.body));
      travelType = travelTypeList.data![1];
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
      vehicleTypeTypeList =
          VehicleTypeTypeList.fromJson(jsonDecode(response.body));
      vehicleType = vehicleTypeTypeList.data![0];
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

  getDirections() async {
    List<LatLng> polylineCoordinates = [];

    poly.PolylineResult result =
        await polylinePoints.getRouteBetweenCoordinates(
            googleAPiKey,
            poly.PointLatLng(startlat ?? 0.0, startlng ?? 0.0),
            poly.PointLatLng(endlat ?? 0.0, endlng ?? 0.0),
            travelMode: poly.TravelMode.driving);

    if (result.points.isNotEmpty) {
      result.points.forEach((poly.PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result.errorMessage);
    }

    //polulineCoordinates is the List of longitute and latidtude.
    double totalDistance = 0;
    for (var i = 0; i < polylineCoordinates.length - 1; i++) {
      totalDistance += calculateDistance(
          polylineCoordinates[i].latitude,
          polylineCoordinates[i].longitude,
          polylineCoordinates[i + 1].latitude,
          polylineCoordinates[i + 1].longitude);
    }
    print(totalDistance);

    setState(() {
      distance = totalDistance;
      vehicleType=vehicleTypeTypeList.data![_selectedIndex];
    });

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Estimation(
                strating: str_pickup!,
                ending: str_drop!,
                vehicleType: VehicleType,
                estimation: 0.0,
                post: _selectedIndex,
                distance: distance.roundToDouble(),
                vehicleTypeModel: vehicleType,
                datum: travelType,
                startDate: startTime,
                enddate: endTime,
            isChecked: (oneWayData!=1 && travelType.name == "Tourist Traveller Bus")?true:false,
            cartype:_selectedIndex,
            onewayData:  travelType.name == "Tourist Traveller Bus"?2:oneWayData, rentalKm: rentalKm, rentalHrs: rentalHrs,
              )),
    );

    //add to the list of poly line coordinates
    addPolyLine(polylineCoordinates);
  }

  addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.deepPurpleAccent,
      points: polylineCoordinates,
      width: 8,
    );
    polylines[id] = polyline;
    setState(() {});
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  Future<void> _handlePressButton(String type) async {
    // show input autocomplete with selected mode
    // then get the Prediction selected
    Prediction? p = await PlacesAutocomplete.show(
      context: context,
      apiKey: "AIzaSyDZyerp9IDsBagJGw7zlqr9jRFJB_j9UYc",
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
        apiKey: "AIzaSyDZyerp9IDsBagJGw7zlqr9jRFJB_j9UYc",
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
          sharedPreferences!.setString('desc', str_pickup.toString());
          sharedPreferences!.setDouble('startlat', startlat!);
          sharedPreferences!.setDouble('startlng', startlng!);
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

    if (startlat != 0.0 && endlat != 0.0) {
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
            CameraPosition(target: LatLng(startlat!, startlng!), zoom: 8.0);
        if (mapController != null)
          mapController!.animateCamera(
            CameraUpdate.newCameraPosition(currentLocationCamera!),
          );

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
    }
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

    poly.PolylineResult result =
        await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyDZyerp9IDsBagJGw7zlqr9jRFJB_j9UYc",
      poly.PointLatLng(startlat!, startlng!),
      poly.PointLatLng(endlat!, endlng!),
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((poly.PointLatLng point) {
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
      drawer: NavigationDrawerNew(_scafkey, ''),
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
          SizedBox(
            height: MediaQuery.of(context).size.height / 2,
            child: GoogleMap(
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
                // controller.complete(gcontroller);

                mapController = gcontroller;
                setState(() {});
                // controller.complete(controller);
              },
              //markers: Set<Marker>.of(snapshot.data ?? []),
              polylines: Set<Polyline>.of(polylines.values),
              markers: getmarkers(),
              padding: EdgeInsets.all(8),
            ),
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
                  TravelTypes.length != 0 &&TravelTypes[_selectedTravelType]['name'] != "Rental"?Container(
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
                  ):Container()
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 0.0),
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
                  height:  TravelTypes.length != 0 && (TravelTypes[_selectedTravelType]['name'] == "Outstation"||TravelTypes[_selectedTravelType]['name'] == "Rental")?400:380,
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
                      SizedBox(
                        height: 0,
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     GestureDetector(
                      //       onTap: ()async{
                      //          DateTime? pickedDate = await showDatePicker(
                      //           context: context,
                      //           initialDate: DateTime.now(),
                      //           firstDate: DateTime.now(),
                      //           lastDate: DateTime(2025),
                      //         );
                      //
                      //         if (pickedDate != null ) {
                      //           pickedDate=pickedDate.copyWith(hour: 12,minute: 0,second: 0);
                      //           String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
                      //           startDate=formattedDate;
                      //           setState(() {
                      //             startTime = pickedDate!;
                      //           });
                      //         }
                      //
                      //       },
                      //       child: Row(
                      //         children: [
                      //           Text('Booking For ',style: TextStyle(fontSize: 16.0, color:  Theme.of(context).primaryColor,fontWeight: FontWeight.w400),),
                      //           Text('${startDate}',style: TextStyle(fontSize: 16.0, color:  Colors.green,fontWeight: FontWeight.w900),),
                      //
                      //         ],
                      //       ),
                      //
                      //     ),
                      //     (travelTypeList.data !=null && travelTypeList.data![_selectedTravelType].id ==2) ?GestureDetector(
                      //       onTap: () async{
                      //          DateTime? pickedDate = await showDatePicker(
                      //           context: context,
                      //           initialDate: startTime,
                      //           firstDate: startTime,
                      //           lastDate: DateTime(2025),
                      //         );
                      //
                      //         if (pickedDate != null) {
                      //           pickedDate=pickedDate.copyWith(hour: 12,minute: 0,second: 0);
                      //
                      //           String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
                      //           endDate=formattedDate;
                      //           Duration difference = pickedDate.difference(startTime);
                      //           int differenceInDays = difference.inDays;
                      //           // if(differenceInDays!=0){
                      //           //   driverBeta=differenceInDays * driverBeta;
                      //           // }else{
                      //           //   driverBeta=widget.vehicleTypeModel.driverBetta??0;
                      //           // }
                      //           setState(() {
                      //             endTime = pickedDate!;
                      //           });
                      //         }
                      //
                      //       },
                      //       child: Row(
                      //         children: [
                      //           Text('Return Date ',style: TextStyle(fontSize: 16.0, color:  Theme.of(context).primaryColor,fontWeight: FontWeight.w400),),
                      //           Text('${endDate}',style: TextStyle(fontSize: 16.0, color:  Colors.green,fontWeight: FontWeight.w900),),
                      //
                      //           // SizedBox(height: 16.0),
                      //
                      //           // Row(
                      //           //   children: [
                      //           //     Icon(
                      //           //
                      //           //       Icons.calendar_month,
                      //           //       color: Theme.of(context).primaryColor,
                      //           //     ),
                      //           //     SizedBox(width: 10,),
                      //           //     Text(endDate,style: TextStyle(fontSize: 16.0, color:  Theme.of(context).primaryColor,fontWeight: FontWeight.w600),)
                      //           //   ],
                      //           // ),
                      //         ],
                      //       ),
                      //     ):Container(),
                      //   ],
                      // ),
                      SizedBox(height: 10.0),

                      TravelTypes.length != 0 && TravelTypes[_selectedTravelType]['name'] == "Outstation" ?




                      Column(
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
                                      travelType = travelTypeList
                                          .data![0];
                                      getVehicleType(
                                          TravelTypes[0]
                                          ['id']);
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
                                      oneWayData=2;
                                      travelType = travelTypeList
                                          .data![1];
                                      getVehicleType(
                                          TravelTypes[1]
                                          ['id']);
                                    });
                                   },
                                ),

                                // SizedBox(width: 40,),

                              ],
                            ),
                          )
                        ],
                      )


        : (TravelTypes.length != 0 &&TravelTypes[_selectedTravelType]['name'] == "Rental")?Expanded(
          child: ListView(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,

                          children: [
                            Row(
                              crossAxisAlignment:
                              CrossAxisAlignment.center,
                              children: [
                                Container(
                                  // height: 84,
                                  margin: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: rentalSelectionIndex==0
                                          ? Theme.of(context)
                                          .primaryColorDark
                                          : Colors.grey,
                                      width:
                                      rentalSelectionIndex==0
                                          ? 1.5
                                          : 0,
                                    ), //Border.all
                                    borderRadius:
                                    BorderRadius.circular(15),
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      rentalSelectionIndex=0;
                                      rentalKm=50;
                                      rentalHrs=5;
                                      setState(() {

                                      });
                                    },
                                    //color: Colors.green,
                                    //height: 40,
                                    //width: 90,
                                    child: Container(
                                      child: Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Stack(
                                          children: [
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                SizedBox(height: 2,),
                                                Container(
                                                  // height:30,
                                                    alignment:
                                                    Alignment.center,
                                                    width: 100,
                                                    child: Text('5 Hr',
                                                      textAlign: TextAlign
                                                          .center,
                                                      style: TextStyle(fontWeight: FontWeight.bold),
                                                    )),
                                                SizedBox(height: 6,),
                                                Container(
                                                  // height:30,
                                                    alignment:
                                                    Alignment.center,
                                                    width: 100,
                                                    child: Text( '50 Km',
                                                      textAlign: TextAlign
                                                          .center,
                                                    )),
                                              ],
                                            ),
                                            rentalSelectionIndex==0?Positioned(
                                                top: 0,
                                                right: 0,
                                                child: Icon(Icons.check_circle_outline,size: 20,)):Container()

                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  // height: 84,
                                  margin: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: rentalSelectionIndex==1
                                          ? Theme.of(context)
                                          .primaryColorDark
                                          : Colors.grey,
                                      width:
                                      rentalSelectionIndex==1
                                          ? 1.5
                                          : 0,
                                    ), //Border.all
                                    borderRadius:
                                    BorderRadius.circular(15),
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      rentalSelectionIndex=1;
                                      rentalKm=100;
                                      rentalHrs=10;
                                      setState(() {

                                      });
                                    },
                                    //color: Colors.green,
                                    //height: 40,
                                    //width: 90,
                                    child: Container(

                                      child: Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Stack(
                                          children: [
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                SizedBox(height: 2,),
                                                Container(
                                                  // height:30,
                                                    alignment:
                                                    Alignment.center,
                                                    width: 100,
                                                    child: Text('10 Hr',
                                                      textAlign: TextAlign
                                                          .center,
                                                      style: TextStyle(fontWeight: FontWeight.bold),

                                                    )),
                                                SizedBox(height: 6,),
                                                Container(
                                                  // height:30,
                                                    alignment:
                                                    Alignment.center,
                                                    width: 100,
                                                    child: Text( '100 Km',
                                                      textAlign: TextAlign
                                                          .center,
                                                    )),
                                              ],
                                            ),
                                            rentalSelectionIndex==1?Positioned(
                                                top: 0,
                                                right: 0,
                                                child: Icon(Icons.check_circle_outline,size: 20,)):Container()

                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  // height: 84,
                                  margin: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: rentalSelectionIndex==2
                                          ? Theme.of(context)
                                          .primaryColorDark
                                          : Colors.grey,
                                      width:
                                      rentalSelectionIndex==2
                                          ? 1.5
                                          : 0,
                                    ), //Border.all
                                    borderRadius:
                                    BorderRadius.circular(15),
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      rentalSelectionIndex=2;
                                      rentalKm=150;
                                      rentalHrs=15;
                                      setState(() {

                                      });
                                    },
                                    //color: Colors.green,
                                    //height: 40,
                                    //width: 90,
                                    child: Container(

                                      child: Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Stack(
                                          children: [
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                SizedBox(height: 2,),
                                                Container(
                                                  // height:30,
                                                    alignment:
                                                    Alignment.center,
                                                    width: 100,
                                                    child: Text('15 Hr',
                                                      textAlign: TextAlign
                                                          .center,
                                                      style: TextStyle(fontWeight: FontWeight.bold),

                                                    )),
                                                SizedBox(height: 6,),
                                                Container(
                                                  // height:30,
                                                    alignment:
                                                    Alignment.center,
                                                    width: 100,
                                                    child: Text( '150 Km',
                                                      textAlign: TextAlign
                                                          .center,
                                                    )),
                                              ],
                                            ),
                                            rentalSelectionIndex==2?Positioned(
                                                top: 0,
                                                right: 0,
                                                child: Icon(Icons.check_circle_outline,size: 20,)):Container()

                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                          ],
                        ),
        ):Container(height: 8,),
                      SizedBox(height: 4.0),

                      Container(
                        //color: Colors.red,
                        height: 260,
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
                                    TravelTypes[index]['roundTripStatus']
                                        ? Container()
                                        :
                                    Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                // height: 84,
                                                margin: EdgeInsets.all(4),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: _selectedTravelType ==
                                                            index
                                                        ? Theme.of(context)
                                                            .primaryColorDark
                                                        : Colors.transparent,
                                                    width:
                                                        _selectedTravelType ==
                                                                index
                                                            ? 1
                                                            : 0,
                                                  ), //Border.all
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                                child: InkWell(
                                                  onTap: () {
                                                    _selectedTravelType = index;
                                                    oneWayData=1;
                                                    print(
                                                        "---------------------------------------------------------------------------------->>>>>>  tapped on " +
                                                            TravelTypes[index]
                                                                ['name']);

                                                    travelType = travelTypeList
                                                        .data![index];
                                                    getVehicleType(
                                                        TravelTypes[index]
                                                            ['id']);
                                                  },
                                                  //color: Colors.green,
                                                  //height: 40,
                                                  //width: 90,
                                                  child: Column(
                                                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Container(
                                                          // color: Colors.red,
                                                          height: 50,
                                                          child: Image(
                                                            image: AssetImage(
                                                                "images/${ll_images[index]}"),
                                                            height: 70,
                                                            width: 70,
                                                          )),
                                                      //SizedBox(width: 40,),
                                                      Container(
                                                          // height:30,
                                                          alignment:
                                                              Alignment.center,
                                                          width: 100,
                                                          child: Text(
                                                            TravelTypes[index]
                                                                ['name'],
                                                            textAlign: TextAlign
                                                                .center,
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                              ),
                            ),
                            SizedBox(height: 5.0),
                            Expanded(
                              flex: 5,
                              child: ListView.builder(
                                  itemCount: VehicleType.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return InkWell(
                                      onTap: () {
                                        vehicleType =
                                            vehicleTypeTypeList.data![index];
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
                                                            "Base ${(TravelTypes.length != 0 &&TravelTypes[_selectedTravelType]['name'] == "Rental")?rentalKm==0?50:rentalKm:VehicleType[index]['basekm']} Km",
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
                                                          IconButton(

                                                            icon: Icon(
                                                              Icons
                                                                  .info_outline_rounded,
                                                              color: Colors.grey,
                                                            ),
                                                            onPressed: (){
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
                                                          ),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          Expanded(
                                                              child: Text(
                                                            "\u{20B9}${VehicleType[index]['baseRate']} \u{2044} Km",
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
                      // Row(
                      //   children: [
                      //     Container(
                      //       height: 60,
                      //       padding: EdgeInsets.all(5),
                      //
                      //       width: MediaQuery.of(context).size.width/2.4,
                      //       //color: Colors.red,
                      //       child: Padding(
                      //         padding: const EdgeInsets.only(top: 8.0),
                      //         child: RoundedLoadingButton(
                      //             successIcon: Icons.check_circle,
                      //             height: 40,
                      //             width: 350,
                      //             successColor: Colors.green,
                      //             failedIcon: Icons.error,
                      //             borderRadius: 5,
                      //             color: Color(0xFF013B46),
                      //             child: Text(
                      //               "Book Now",
                      //               style: TextStyle(
                      //                   color: Colors.white, fontSize: 18),
                      //             ),
                      //             controller: _btnController1,
                      //             onPressed: () async {
                      //               Navigator.push(context, MaterialPageRoute(builder: (context) => CCAVENE()),);
                      //               var connection = await CheckConnection.check();
                      //
                      //               if (connection) {
                      //                 FocusManager.instance.primaryFocus?.unfocus();
                      //                 print("email:" + emailController.text);
                      //                 // print("password:"+passwordController.text);
                      //                 _btnController1.stop();
                      //               } else {
                      //                 _btnController1.stop();
                      //                 //CheckConnection.showErrorSnackBar(_scafkey.currentState!.context,"No Internet Connection!");
                      //                 Validation.showNointernetErrormessage(
                      //                     _scafkey, 'No internet connection.');
                      //               }
                      //
                      //               //CheckConnection.showDialog(_scaffoldkey.currentState!.context, SimpleFontelicoProgressDialogType.phoenix, 'Phoenix');
                      //             }
                      //             // => _doSomething(_btnController1),
                      //             ),
                      //       ),
                      //     ),
                      //     Container(
                      //       height: 60,
                      //       padding: EdgeInsets.all(5),
                      //       width: MediaQuery.of(context).size.width/2,
                      //       //color: Colors.red,
                      //       child: Padding(
                      //         padding: const EdgeInsets.only(top: 8.0),
                      //         child: RoundedLoadingButton(
                      //             successIcon: Icons.check_circle,
                      //             height: 40,
                      //             width: 350,
                      //             successColor: Colors.green,
                      //             failedIcon: Icons.error,
                      //             borderRadius: 5,
                      //             color: Color(0xFF013B46),
                      //             child: Text(
                      //               "Estimate",
                      //               style: TextStyle(
                      //                   color: Colors.white, fontSize: 18),
                      //             ),
                      //             controller: _btnController1,
                      //             onPressed: () async {
                      //
                      //
                      //               if(startlng ==0.0  && endlat == 0.0){
                      //                 const snackBar = SnackBar(
                      //                   content: Text('Please select start and end point'),
                      //                 );
                      //
                      //                 ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      //                 _btnController1.stop();
                      //
                      //               }else{
                      //                 getDirections();
                      //                 var connection = await CheckConnection.check();
                      //
                      //                 if (connection) {
                      //                   FocusManager.instance.primaryFocus?.unfocus();
                      //                   print("email:" + emailController.text);
                      //                   // print("password:"+passwordController.text);
                      //                   _btnController1.stop();
                      //                 } else {
                      //                   _btnController1.stop();
                      //                   //CheckConnection.showErrorSnackBar(_scafkey.currentState!.context,"No Internet Connection!");
                      //                   Validation.showNointernetErrormessage(
                      //                       _scafkey, 'No internet connection.');
                      //                 }
                      //
                      //                 //CheckConnection.showDialog(_scaffoldkey.currentState!.context, SimpleFontelicoProgressDialogType.phoenix, 'Phoenix');
                      //               }
                      //               }
                      //
                      //             // => _doSomething(_btnController1),
                      //             ),
                      //       ),
                      //     ),
                      //   ],
                      // )
                      Container(
                        height: 60,
                        padding: EdgeInsets.all(5),
                        width: MediaQuery.of(context).size.width,
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
                                "Review Booking",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                              controller: _btnController1,
                              onPressed: () async {
                                if (startlng == 0.0 || endlat == 0.0) {
                                  if( TravelTypes[_selectedTravelType]['name'] == "Rental" && startlng != 0.0){
                                    redirectEstimate();
                                    return;
                                  }else{
                                    const snackBar = SnackBar(
                                      content: Text(
                                          'Please select start and end point'),
                                    );

                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                    _btnController1.stop();
                                  }

                                } else {
                                 redirectEstimate();

                                  //CheckConnection.showDialog(_scaffoldkey.currentState!.context, SimpleFontelicoProgressDialogType.phoenix, 'Phoenix');
                                }
                              }

                              // => _doSomething(_btnController1),
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Positioned(
          //   top: 120,
          //   right: 20,
          //   child: InkWell(
          //     onTap: () {
          //       Validation.ValidationAlert(context, "Are you in an Emergency?");
          //     },
          //     child: Container(
          //       height: 40,
          //       width: 110,
          //       alignment: Alignment.center,
          //       //color: Colors.redAccent,
          //       decoration: BoxDecoration(
          //           color: Colors.redAccent,
          //           borderRadius: BorderRadius.circular(30)),
          //       child: Text(
          //         "Emergency",
          //         style: TextStyle(fontSize: 16, color: Colors.white),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
      // drawer: NavigationDrawer(_scafkey, "Name"),
    );
  }

  void redirectEstimate()async   {
    getDirections();
    var connection =
        await CheckConnection.check();

    if (connection) {
      FocusManager.instance.primaryFocus
          ?.unfocus();
      print("email:" + emailController.text);
      // print("password:"+passwordController.text);
      _btnController1.stop();
    } else {
      _btnController1.stop();
      //CheckConnection.showErrorSnackBar(_scafkey.currentState!.context,"No Internet Connection!");
      Validation.showNointernetErrormessage(
          _scafkey, 'No internet connection.');
    }
  }
}
