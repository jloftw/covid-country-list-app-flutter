import 'package:flutter/material.dart';

import 'country.dart';

class VistaRequest extends StatelessWidget {
  final Country current;
  const VistaRequest({Key? key, required this.current}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(current.countryName),
      ),
      body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
        Image.network(current.flag.flagLink),
        Text("Country Name: " + current.countryName, style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),),
        Text("Cases: " + current.cases.toString()),
          Text("Recovered: " + current.recovered.toString()),
          Text("Deaths: " + current.deaths.toString())
      ],
    )));
  }
}