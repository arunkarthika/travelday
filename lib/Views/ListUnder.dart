import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:uuid/uuid.dart';


void main() {
  runApp(ListMyApp());
}

class ListMyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _controller = TextEditingController();
  var uuid = new Uuid();
  String? _sessionToken;
  List<dynamic> _placeList = [];
  bool? show;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      _onChanged(

      );
    });
  }

  _onChanged() {
    if (_sessionToken == null) {
      setState(() {

        _sessionToken = uuid.v4();
      });
    }
    if(_controller.text.length>10)
      {
        setState(() {
          show=false;
        });
      }else{
      setState(() {
        if(_controller.text.length==0)
          {
            setState(() {
              show=false;
            });
          }else{
          setState(() {
            show=true;
          });
        }

      });
    }
    print("call onchange");
    getSuggestion(_controller.text);
    _controller.selection=TextSelection.fromPosition(TextPosition(offset: _controller.text.length));
  }

  void getSuggestion(String input) async {
    String kPLACES_API_KEY = "AIzaSyAdVwCkz9ebBfq2V-epP3iHVFQ8Zf7SZj8";
    String type = '(regions)';
    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    final request = Uri.parse('$baseURL?input=$input&key=$kPLACES_API_KEY&sessiontoken=$_sessionToken');
    var response = await http.get(request);
    if (response.statusCode == 200) {
      setState(() {
        _placeList = json.decode(response.body)['predictions'];
      });
    } else {
      throw Exception('Failed to load predictions');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Align(
              alignment: Alignment.topCenter,
              child:
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  //padding: EdgeInsets.all(10),
                  height: 50,
                  child: TextField(
                    textAlign: TextAlign.start,
                    controller: _controller,
                    keyboardType: TextInputType.name,
                    onTap: (){

                    },
                    //autocorrect: true,
                    decoration:  InputDecoration(
                      hintText: "Seek your location here",
                      hintStyle: TextStyle(color: Colors.grey),
                      focusColor: Colors.white,
                      filled: true,
                      isDense: true,
                      fillColor: Colors.white54,
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      prefixIcon: Icon(Icons.location_on),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        borderSide: BorderSide(color: Colors.white54, width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(color: Colors.white54),
                      ),
                      suffixIcon: IconButton(
                          onPressed:(){
                            print("click heart");
                          },
                          icon: Icon(Icons.favorite_border)
                      ),
                    ),
                  ),
                ),
              ),
            ),
            show==true?ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: _placeList.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: (){
                    //_controller.text=_placeList[index]["description"];
                    String select= _placeList[index]["description"];
                    print("Select value====="+select);
                    if(select.length>=40)
                    {
                      _controller.text=select.substring(0,40)+"....";
                    }else{
                      _controller.text=select.toString();
                    }
                    if(_controller.text.length>10)
                    {
                      setState(() {
                        show=false;
                      });
                    }else{
                      setState(() {
                        show=true;
                      });
                    }
                  },
                  child: ListTile(
                    title: Text(_placeList[index]["description"]),
                  ),
                );
              },
            ):Text("")
          ],
        ),
      ),
    );
  }
}