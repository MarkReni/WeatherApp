import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ChangeCity extends StatelessWidget {
  var _cityFieldController = TextEditingController();
  var _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 15.0,
          title: Text('Change City', style: TextStyle(color: Colors.grey[800])),
          centerTitle: true,
          backgroundColor: Colors.transparent,
        ),
        body: Stack(children: <Widget>[
          Center(
            child: Image.asset(
              "images/snowing.jpg",
              width: 490.0,
              height: 1200.0,
              fit: BoxFit.fill,
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: Image.asset('images/snow.png'),
          ),
          ListView(children: <Widget>[
            Form(
              key: _formKey,
              child: ListTile(
                  title: TextFormField(
                validator: (String value) {
                  if (value.isEmpty || double.tryParse(value) != null) {
                    return 'Please enter valid input';
                  } else
                    return null;
                },
                decoration: InputDecoration(hintText: 'Enter City'),
                controller: _cityFieldController,
                keyboardType: TextInputType.text,
              )),
            ),
            SizedBox(
              height: 20.0,
            ),
            ListTile(
                title: FlatButton(
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  Navigator.pop(context, {'enter': _cityFieldController.text});
                }
              },
              child: Text('Get Weather',
                  textScaleFactor: 1.5,
                  style: TextStyle(fontWeight: FontWeight.bold)),
              textColor: Colors.black87,
              color: Colors.transparent,
            ))
          ])
        ]));
  }
}
