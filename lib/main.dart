import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

// GUI se estructura en widgets
// widgets pueden ser stateless o stateful
// - stateful: widget cuyo contenido puede cambiar
// - stateless: widget cuyo contenido no cambia
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "ejemplito",
        theme: ThemeData(
          primaryColor: Colors.white,
        ),
        home: const ListaWidget());
  }
}

class ListaWidget extends StatefulWidget {
  const ListaWidget({Key? key}) : super(key: key);

  @override
  _ListaWidgetState createState() => _ListaWidgetState();
}

class _ListaWidgetState extends State<ListaWidget> {
  late List<String> _contenido;
  late TextStyle _estilito;

  _ListaWidgetState() {
    _contenido = ["a", "b", "c", "d", "e"];
    _estilito = const TextStyle(fontSize: 15.0);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("APLICACION CON LISTITA"),
        ),
        body: _construyeLista());
  }

  Widget _construyeLista() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _contenido.length,
        itemBuilder: (context, i) {
          return _construyeRow(_contenido[i]);
        });
  }

  Widget _construyeRow(String valor) {
    return ListTile(
        title: Text(
          valor,
          style: _estilito,
        ),
        onTap: () {
          Fluttertoast.showToast(
              msg: "presionaste: " + valor,
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1);

          Navigator.push(
              context, MaterialPageRoute(builder: (context) => VistaRequest()));
        });
  }
}

class VistaDetalle extends StatelessWidget {
  const VistaDetalle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Aqui va el detalle del pais"),
      ),
      body: const Center(child: Text("AQUI IRIA LA INFO!!")),
    );
  }
}

class VistaRequest extends StatefulWidget {
  const VistaRequest({Key? key}) : super(key: key);

  @override
  _VistaRequestState createState() => _VistaRequestState();
}

class _VistaRequestState extends State<VistaRequest> {
  late Future<List<Country>> Countrys;

  @override
  void initState() {
    super.initState();
    Countrys = obtenerInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("AQUI VA EL RESULTADO DEL REQUEST!")),
        body: Center(
            child: FutureBuilder<List<Country>>(
                future: Countrys,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(snapshot.data![0].countryName);
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                  // aquí dejamos lo que muestra en lo que se decide si tiene datos o error
                  return CircularProgressIndicator();
                })));
  }
}

class CountryInfo {
  final String flagLink;

  CountryInfo({required this.flagLink});

  factory CountryInfo.fromJson(Map<String, dynamic> json) {
    return CountryInfo(flagLink: json['flag']);
  }
}

// creamos una clase o una serie de clases para mapear contenido de JSON
class Country {
  final String countryName;
  final int cases;
  final int deaths;
  final int recovered;
  final CountryInfo flag;

  Country(
      {required this.countryName,
      required this.cases,
      required this.deaths,
      required this.recovered,
      required this.flag});

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
        countryName: json['country'],
        cases: json['cases'],
        deaths: json['deaths'],
        recovered: json['recovered'],
        flag: CountryInfo.fromJson(json['countryInfo']));
  }
}

// declarar la funcion que va a obtener datos remotamente
Future<List<Country>> obtenerInfo() async {
  final response =
      await http.get(Uri.parse('https://disease.sh/v3/covid-19/countries'));

  if (response.statusCode == 200) {
    List<dynamic> list = jsonDecode(response.body);
    List<Country> result = [];

    for (var actual in list) {
      Country CountryActual = Country.fromJson(actual);
      result.add(CountryActual);
    }

    print(result);
    return result;
  } else {
    // algún error por algún motivo
    throw Exception("HUBO ERROR EN REQUEST");
  }
}
