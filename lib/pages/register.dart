import 'package:flutter/material.dart';
import 'package:mobile/components/my_button.dart';
import 'package:mobile/components/my_textfield.dart';
import 'package:mobile/components/square_tile.dart';
import 'package:mobile/components/my_textfield_number.dart';
import 'package:mobile/pages/login_page.dart';
import '../api/network.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'home.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<RegisterPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _secureText = true;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  _showMsg(msg) {
    final snackBar = SnackBar(
      content: Text(msg),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // text editing controllers
  final emailController = TextEditingController();
  final identityController = TextEditingController();
  final nameController = TextEditingController();
  final noController = TextEditingController();
  final adressController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        body: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),

                  // text
                  Text(
                    'Input Your Data',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 25),

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
                      child: Text("Password"),
                    ),
                  ),
                  MyTextField(
                    controller: passwordController,
                    hintText: 'Pasword Atleast 8 Character',
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

                  const SizedBox(height: 25),
                  ElevatedButton.icon(
                      onPressed: _isLoading
                          ? null
                          : () async {
                              _register();
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
                                child:
                                    Center(child: CircularProgressIndicator()),
                                height: 21,
                                width: 10,
                              ),
                            )
                          : Container(
                              padding: const EdgeInsets.all(20),
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 50),
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

                  const SizedBox(height: 25),

                  // register
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already Have Account?',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => LoginPage()),
                          );
                        },
                        child: new Text(
                          'Sign In',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }

  void _register() async {
    setState(() {
      _isLoading = true;
    });
    var data = {
      'email': emailController.text,
      'password': passwordController.text,
      'full_name': nameController.text,
      'phone_number': noController.text,
      'identity': identityController.text,
      'address': adressController.text,
      'is_group': false,
      'role': 6,
      'image': "",
    };
    var res = await Network().auth(data, 'register');
    var body = json.decode(res.body);
    if (body['OUT_STAT'] == "T") {
      _showMsg(body['OUT_MESS']);
      await Future.delayed(Duration(seconds: 3));
      Navigator.pushReplacement(
        context,
        new MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } else {
      _showMsg(body['OUT_MESS']);
    }

    setState(() {
      _isLoading = false;
    });
  }
}
