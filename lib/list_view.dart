import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'country.dart';
import 'country_view.dart';

class ListaWidget extends StatefulWidget {
  const ListaWidget({Key? key}) : super(key: key);

  @override
  _ListaWidgetState createState() => _ListaWidgetState();
}

class _ListaWidgetState extends State<ListaWidget> {
  late TextStyle _estilito;
  late Future<List<Country>> Countries;

  _ListaWidgetState() {
    _estilito = const TextStyle(fontSize: 15.0);
  }

  @override
  void initState() {
    super.initState();
    Countries = obtenerInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Covid Countries List")),
        body: Center(
            child: FutureBuilder<List<Country>>(
                future: Countries,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return _construyeLista(snapshot.data!);
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                  return CircularProgressIndicator();
                })));
  }

  Widget _construyeLista(List<Country> CountryList) {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: CountryList.length,
        itemBuilder: (context, i) {
          return _construyeRow(CountryList[i]);
        });
  }

  Widget _construyeRow(Country current) {
    return ListTile(
        title: _rowCard(current),
        onTap: () {
          Fluttertoast.showToast(
              msg: "presionaste" + current.countryName,
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1);

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => VistaRequest(current: current)));
        });
  }

  Widget _rowCard(Country current) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.network(current.flag.flagLink),
          Text(
            current.countryName,
            style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
          ),
          Text(
            current.cases.toString(),
            style: _estilito,
          )
        ],
      ),
    );
  }
}
