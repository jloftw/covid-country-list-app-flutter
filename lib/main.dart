import 'package:flutter/material.dart';
import 'list_view.dart';

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
        title: "Covid Countries List",
        theme: ThemeData(
          primaryColor: Colors.white,
        ),
        home: const ListaWidget());
  }
}