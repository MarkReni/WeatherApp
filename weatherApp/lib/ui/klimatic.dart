import 'dart:convert';
import 'package:flutter/material.dart';
import '../util/utils.dart' as util;
import 'package:http/http.dart' as http;
import './changeMap.dart';

class Klimatic extends StatefulWidget {
  @override
  _KlimaticState createState() => _KlimaticState();
}

class _KlimaticState extends State<Klimatic> {
  String _cityEntered;
  //
  Future _goToNextScreen(BuildContext context) async {
    Map results = await Navigator.of(context).push(
        MaterialPageRoute<Map<dynamic, dynamic>>(
            builder: (BuildContext context) {
      return ChangeCity();
    }));
    if (results != null && results.containsKey('enter')) {
      // debugPrint("From first screen " + results['enter'].toString());
      _cityEntered = results['enter'];
      setState(() {
        updateTempWidget(_cityEntered);
      });
    }
  }

  //
  void showStuff() async {
    Map data = await getWeather(util.appId, util.defaultCity);
    print(data.toString());
  }

  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 15.0,
        centerTitle: true,
        title: Text('Weather'),
        backgroundColor: Colors.transparent,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () => _goToNextScreen(context),
          )
        ],
      ),
      body: Stack(children: <Widget>[
        Center(
          child: Image.asset('images/clouds.jpg',
              fit: BoxFit.fill, width: 490.0, height: 1200),
        ),
        Container(
          alignment: Alignment.topRight,
          margin: const EdgeInsets.fromLTRB(0.0, 110.0, 15.0, 0.0),
          child: Text(
            _cityEntered == null ? util.defaultCity : _cityEntered,
            style: cityStyle(),
          ),
        ),
        Container(
          alignment: Alignment.center,
          child: Image.asset('images/sun.png'),
        ),
        // Container which will have our weather data
        Container(
          margin: const EdgeInsets.fromLTRB(30, 600.0, 0.0, 0.0),
          alignment: Alignment.center,
          child: updateTempWidget(
              _cityEntered == null ? util.defaultCity : _cityEntered),
        )
      ]),
    );
  }

  Future<Map> getWeather(String appId, String city) async {
    String apiUrl =
        "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$appId&units=metric";
    http.Response response = await http.get(apiUrl);
    return json.decode(response.body);
  }

  Widget updateTempWidget(String city) {
    Map content;
    return FutureBuilder(
        future: getWeather(util.appId, city),
        builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
          // where we get all of the json data, we setup widgets etc.
          if (snapshot.hasData && snapshot.data['main'] != null) {
            content = snapshot.data;
            return Container(
              child: Column(children: <Widget>[
                Card(
                  color: Colors.transparent,
                  elevation: 50.0,
                  child: Text(content['main']['temp'].toString() + " °C",
                      style: tempStyle(content)),
                )
              ]),
            );
          } else {
            content = snapshot.data;
            return Container(
              child: Column(children: <Widget>[
                Card(
                  color: Colors.transparent,
                  elevation: 50.0,
                  child: Text(content['message'].toString(),
                      style: tempStyle(content)),
                )
              ]),
            );
          }
        });
  }
}

TextStyle cityStyle() {
  return TextStyle(
    color: Colors.white70,
    fontSize: 22.9,
    fontStyle: FontStyle.italic,
  );
}

TextStyle tempStyle(Map content) {
  return TextStyle(
    color: Colors.white70,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
    fontSize: content['main'] != null ? 30.9 : 25.0,
  );
}
