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

class ProfilePage extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<ProfilePage> {
  String name = '';
  final emailController = TextEditingController();
  final identityController = TextEditingController();
  final nameController = TextEditingController();
  final noController = TextEditingController();
  final adressController = TextEditingController();
  bool _isLoading = false;

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
    var res = await Network().post(data, 'authUser', token);
    var body = json.decode(res.body);

    if (body['OUT_STAT'] == "T") {
      var emails = json.encode(body['OUT_DATA'][0]['email']);
      var identitys = json.encode(body['OUT_DATA'][0]['identity']);
      var fullNames = json.encode(body['OUT_DATA'][0]['full_name']);
      var phoneNumbers = json.encode(body['OUT_DATA'][0]['phone_number']);
      var addresss = json.encode(body['OUT_DATA'][0]['address']);

      var lenght = emails.length;
      var email = emails.substring(1, lenght - 1);
      lenght = identitys.length;
      var identity = identitys.substring(1, lenght - 1);
      lenght = fullNames.length;
      var fullName = fullNames.substring(1, lenght - 1);
      lenght = phoneNumbers.length;
      var phoneNumber = phoneNumbers.substring(1, lenght - 1);
      lenght = addresss.length;
      var address = addresss.substring(1, lenght - 1);

      emailController.text = email;
      identityController.text = identity;
      nameController.text = fullName;
      noController.text = phoneNumber;
      adressController.text = address;
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
                  child: Text("Email"),
                ),
              ),
              MyTextField(
                controller: emailController,
                hintText: 'Email',
                obscureText: false,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  margin: EdgeInsets.only(left: 25, bottom: 10, top: 10),
                  child: Text("Identity"),
                ),
              ),
              MyTextFieldNumber(
                controller: identityController,
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
              // Align(
              //   alignment: Alignment.topLeft,
              //   child: Container(
              //     margin: EdgeInsets.only(left: 25, bottom: 10, top: 10),
              //     child: Text("Tgl Lahir"),
              //   ),
              // ),
              // Container(
              //   margin:
              //       EdgeInsets.only(left: 25, right: 25, bottom: 10, top: 10),
              //   child: DateTimeFormField(
              //     decoration: const InputDecoration(
              //         hintStyle: TextStyle(color: Colors.black45),
              //         errorStyle: TextStyle(color: Colors.redAccent),
              //         border: OutlineInputBorder(),
              //         suffixIcon: Icon(Icons.event_note),
              //         labelText: 'Select your birthday',
              //         fillColor: Colors.white),
              //     mode: DateTimeFieldPickerMode.date,
              //     autovalidateMode: AutovalidateMode.always,
              //     validator: (e) =>
              //         (e?.day ?? 0) == 1 ? 'Please not the first day' : null,
              //     onDateSelected: (DateTime value) {
              //       print(value);
              //     },
              //   ),
              // ),
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  margin: EdgeInsets.only(left: 25, bottom: 10, top: 10),
                  child: Text("Address"),
                ),
              ),
              MyTextField(
                controller: adressController,
                hintText: 'Jalan Kaliurang 36',
                obscureText: false,
              ),
              ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChangePasswordPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo.shade900,
                  ),
                  icon: Text("Change Password"),
                  label: Text("Change Password")),
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
    });
    var data = {
      'email': emailController.text,
      'full_name': nameController.text,
      'phone_number': noController.text,
      'address': adressController.text,
      'image': '',
      'identity': identityController.text
    };
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var tokens = localStorage.getString('token');
    var lenght = tokens!.length;
    var token = tokens.substring(1, lenght - 1);
    var res = await Network().post(data, 'editProfile', token);
    var body = json.decode(res.body);
    if (body['OUT_STAT'] == "T") {
      _showMsg(body['OUT_MESS']);
      await Future.delayed(Duration(seconds: 3));
      var roles = localStorage.getString('role');
      if (nameController.text != null &&
          nameController.text != "" &&
          nameController.text.isNotEmpty) {
        localStorage.remove('user');
        localStorage.setString('user', nameController.text);
      }
      var lenght = roles!.length;
      var role = roles.substring(1, lenght - 1);

      var cust = "865fd661-ca01-44f6-866d-b44773740791";
      var owner = "4c8ad9bf-3168-4c16-ad64-dc0cfab73dc7";
      var gm = "5616fc68-f5a3-4ce2-bfc5-a6d4f3cc6526";
      if (role == cust) {
        Navigator.pushReplacement(
          context,
          new MaterialPageRoute(builder: (context) => Home()),
        );
      } else if (role == owner) {
        Navigator.pushReplacement(
          context,
          new MaterialPageRoute(builder: (context) => HomeOwner()),
        );
      } else if (role == gm) {
        Navigator.pushReplacement(
          context,
          new MaterialPageRoute(builder: (context) => HomeGM()),
        );
      }
    } else {
      _showMsg(body['OUT_MESS']);
    }
    setState(() {
      _isLoading = false;
    });
  }
}
