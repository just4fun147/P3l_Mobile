import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Network {
  final String _url = 'http://192.168.33.5:8000/api/';
  var token;

  _getToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    token = jsonDecode(localStorage.getString('token')!);
  }

  post(data, apiURL, bearer) async {
    var fullUrl = _url + apiURL;
    var tok = 'Bearer ' + bearer;
    var head = {
      'Content-Type': 'application/json',
      'Authorization': tok,
      'apikey': '1234567890'
    };
    return await http.post(Uri.parse(fullUrl),
        body: jsonEncode(data), headers: head);
  }

  auth(data, apiURL) async {
    var fullUrl = _url + apiURL;
    return await http.post(Uri.parse(fullUrl),
        body: jsonEncode(data), headers: _setHeaders());
  }

  getData(apiURL) async {
    var fullUrl = _url + apiURL;
    await _getToken();
    return await http.get(
      Uri.parse(fullUrl),
      headers: _setHeaders(),
    );
  }

  _setHeaders() => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'apikey': '1234567890'
      };
}
