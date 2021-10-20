import 'package:http/http.dart' as http;
import 'dart:convert';

class CountryInfo {
  final String flagLink;

  CountryInfo({required this.flagLink});

  factory CountryInfo.fromJson(Map<String, dynamic> json) {
    return CountryInfo(flagLink: json['flag']);
  }
}

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

Future<List<Country>> obtenerInfo() async {
  final response = await http
      .get(Uri.parse('https://disease.sh/v3/covid-19/countries?sort=cases'));

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
    throw Exception("HUBO ERROR EN REQUEST");
  }
}
