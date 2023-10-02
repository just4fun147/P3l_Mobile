import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile/components/my_textfield.dart';
import 'package:mobile/components/my_textfield_number.dart';
import 'package:date_field/date_field.dart';
// import 'package:flutter_auth/network/api.dart';
import '../api/network.dart';
import 'dart:convert';
import 'login_page.dart';
import 'home_page.dart';

class ProfilePage extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<ProfilePage> {
  String name = '';
  final usernameController = TextEditingController();
  final nameController = TextEditingController();
  final noController = TextEditingController();
  final tglLahirController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  _loadUserData() async {
    var data = {};
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var tokens = jsonDecode(localStorage.getString('token')!);

    //   var res = await Network().post(data, 'authUser', tokens);

    //   var body = json.decode(res.body);

    //   if (body['OUT_STAT'] == "T") {
    //     usernameController.text = body['OUT_DATA'][0]['email'];
    //     nameController.text = body['OUT_DATA'][0]['name'];
    //     noController.text = body['OUT_DATA'][0]['no_handphone'];
    //     tglLahirController.text = body['OUT_DATA'][0]['tgl_lahir'];
    //   } else {
    //     SharedPreferences localStorage = await SharedPreferences.getInstance();
    //     localStorage.remove('user');
    //     localStorage.remove('token');
    //     Navigator.pushReplacement(
    //         context, MaterialPageRoute(builder: (context) => LoginPage()));
    //   }
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
                  child: Text("Email"),
                ),
              ),
              MyTextField(
                controller: usernameController,
                hintText: 'Email',
                obscureText: false,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  margin: EdgeInsets.only(left: 25, bottom: 10, top: 10),
                  child: Text("Password"),
                ),
              ),
              MyTextField(
                controller: usernameController,
                hintText: 'Password',
                obscureText: true,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  margin: EdgeInsets.only(left: 25, bottom: 10, top: 10),
                  child: Text("Identity"),
                ),
              ),
              MyTextFieldNumber(
                controller: nameController,
                hintText: '33022xxxxxx',
                obscureText: false,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  margin: EdgeInsets.only(left: 25, bottom: 10, top: 10),
                  child: Text("Full Name"),
                ),
              ),
              MyTextField(
                controller: nameController,
                hintText: 'Full Name',
                obscureText: false,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  margin: EdgeInsets.only(left: 25, bottom: 10, top: 10),
                  child: Text("Phone Number"),
                ),
              ),
              MyTextFieldNumber(
                controller: noController,
                hintText: 'Phone Number',
                obscureText: false,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  margin: EdgeInsets.only(left: 25, bottom: 10, top: 10),
                  child: Text("Tgl Lahir"),
                ),
              ),
              Container(
                margin:
                    EdgeInsets.only(left: 25, right: 25, bottom: 10, top: 10),
                child: DateTimeFormField(
                  decoration: const InputDecoration(
                      hintStyle: TextStyle(color: Colors.black45),
                      errorStyle: TextStyle(color: Colors.redAccent),
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.event_note),
                      labelText: 'Select your birthday',
                      fillColor: Colors.white),
                  mode: DateTimeFieldPickerMode.date,
                  autovalidateMode: AutovalidateMode.always,
                  validator: (e) =>
                      (e?.day ?? 0) == 1 ? 'Please not the first day' : null,
                  onDateSelected: (DateTime value) {
                    print(value);
                  },
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  margin: EdgeInsets.only(left: 25, bottom: 10, top: 10),
                  child: Text("Address"),
                ),
              ),
              MyTextField(
                controller: nameController,
                hintText: 'Jalan Kaliurang 36',
                obscureText: false,
              ),
              const SizedBox(height: 25),
              ElevatedButton.icon(
                  onPressed: _isLoading
                      ? null
                      : () async {
                          _update();
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
                              "Save",
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

  void _update() async {
    setState(() {
      _isLoading = true;
      // });
      // var data = {
      //   'email': usernameController.text,
      //   'password': passwordController.text
      // };

      // var res = await Network().auth(data, 'logins');
      // var body = json.decode(res.body);
      // if (body['OUT_STAT'] == "T") {
      //   SharedPreferences localStorage = await SharedPreferences.getInstance();
      //   localStorage.setString('token', json.encode(body['OUT_DATA']['token']));
      //   localStorage.setString('user', json.encode(body['OUT_DATA']['name']));
      //   Navigator.pushReplacement(
      //     context,
      //     new MaterialPageRoute(builder: (context) => Home()),
      //   );
      // } else {
      //   _showMsg(body['OUT_MESS']);
      // }

      // setState(() {
      //   _isLoading = false;
      // });
    });
  }
}
