import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile/components/my_textfield.dart';
import 'package:mobile/components/my_textfield_number.dart';
import 'package:date_field/date_field.dart';
// import 'package:flutter_auth/network/api.dart';
import '../api/network.dart';
import 'dart:convert';
import 'login_page.dart';
import 'home.dart';
import 'Owner/home_owner.dart';
import 'GM/home_gm.dart';
import 'changePassword.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class LoyalPage extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<LoyalPage> {
  String name = '';
  int? selectedYear;
  int? selectedMonth;
  List<String> years = [];
  String? dropdownValue = "Please Select Year";

  bool _isLoading = false;
  bool _isSelected = false;

  _showMsg(msg) {
    final snackBar = SnackBar(
      content: Text(msg),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  _loadUserData() async {
    var data = {};
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var tokens = localStorage.getString('token');
    var lenght = tokens!.length;
    var token = tokens.substring(1, lenght - 1);
    var res = await Network().post(data, 'report/getYear/mobile', token);
    var body = json.decode(res.body);

    if (body['OUT_STAT'] == "T") {
      setState(() {
        years = List<String>.from(body['OUT_DATA'] as List);
        dropdownValue = years[0];
        selectedYear = int.parse(years[0]);
      });
    } else {
      _showMsg(body['OUT_MESS']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Container(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  margin: EdgeInsets.only(left: 25, bottom: 10, top: 10),
                  child: Text("Select Year"),
                ),
              ),
              DropdownButton<String>(
                value: dropdownValue,
                icon: const Icon(Icons.arrow_downward),
                elevation: 16,
                style: const TextStyle(color: Colors.deepPurple),
                underline: Container(
                  height: 2,
                  color: Colors.deepPurpleAccent,
                ),
                onChanged: (String? value) {
                  // This is called when the user selects an item.
                  setState(() {
                    dropdownValue = value!;
                  });
                },
                items: years.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 25),
              ElevatedButton.icon(
                  onPressed: _isLoading
                      ? null
                      : () async {
                          _launchUrl(selectedYear);
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo.shade900,
                  ),
                  icon: Text(""),
                  label: _isLoading
                      ? Container(
                          padding: const EdgeInsets.all(20),
                          // margin:
                          //     const EdgeInsets.symmetric(horizontal: 25),
                          width: 280,
                          decoration: BoxDecoration(
                            // color: Colors.indigo.shade900,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: SizedBox(
                            child: Center(child: CircularProgressIndicator()),
                            height: 21,
                            width: 10,
                          ),
                        )
                      : Container(
                          padding: const EdgeInsets.all(20),
                          margin: const EdgeInsets.symmetric(horizontal: 50),
                          width: 180,
                          decoration: BoxDecoration(
                            // color: Colors.indigo.shade900,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Center(
                            child: Text(
                              "Download",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                // fontFamily: font
                              ),
                            ),
                          ),
                        )),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchUrl(selectedYear) async {
    var _url = Uri.tryParse(
        'http://192.168.33.5:3000/report/p/loyal-customer/${selectedYear}');
    if (!await launchUrl(_url!)) {
      throw Exception('Could not launch $_url');
    }
  }
}
