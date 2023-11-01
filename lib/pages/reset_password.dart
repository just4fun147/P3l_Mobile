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

class ResetPassPage extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<ResetPassPage> {
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
  final phoneController = TextEditingController();
  final nameController = TextEditingController();

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
                    'Authenticated Yourself',
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
                    hintText: 'a@gmail.com',
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
                    hintText: 'Your Name',
                    obscureText: false,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      margin: EdgeInsets.only(left: 25, bottom: 10, top: 10),
                      child: Text("Phone Number"),
                    ),
                  ),
                  MyTextField(
                    controller: phoneController,
                    hintText: '081xxx',
                    obscureText: false,
                  ),

                  const SizedBox(height: 25),
                  ElevatedButton.icon(
                      onPressed: _isLoading
                          ? null
                          : () {
                              showAlertDialog(context);
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

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text("Confirm"),
      onPressed: () async {
        _register();
        Navigator.of(context).pop();
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Confirmation"),
      content: Text("Are You Sure Want To Reset Password?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _register() async {
    setState(() {
      _isLoading = true;
    });
    var data = {
      'email': emailController.text,
      'full_name': nameController.text,
      'phone_number': phoneController.text,
    };
    var res = await Network().auth(data, 'users/reset');
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
