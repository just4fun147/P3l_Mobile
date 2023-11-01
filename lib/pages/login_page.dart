import 'package:flutter/material.dart';
import 'package:mobile/components/my_button.dart';
import 'package:mobile/components/my_textfield.dart';
import 'package:mobile/components/square_tile.dart';
import '../api/network.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'home.dart';
import 'register.dart';
import 'Owner/home_owner.dart';
import 'GM/home_gm.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
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
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        body: SingleChildScrollView(
          child: SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),

                  // logo
                  const Icon(
                    Icons.lock,
                    size: 100,
                  ),

                  const SizedBox(height: 50),

                  // text
                  Text(
                    'Welcome back you\'ve been missed!',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 25),

                  // username textfield
                  MyTextField(
                    controller: usernameController,
                    hintText: 'Email',
                    obscureText: false,
                  ),

                  const SizedBox(height: 10),

                  // password textfield
                  MyTextField(
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: true,
                  ),

                  const SizedBox(height: 10),

                  // forgot password?
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Forgot Password?',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  // sign in button
                  ElevatedButton.icon(
                      onPressed: _isLoading
                          ? null
                          : () async {
                              _login();
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo.shade900,
                      ),
                      icon: Text(""),
                      label: _isLoading
                          ? Container(
                              padding: const EdgeInsets.all(25),
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
                              padding: const EdgeInsets.all(25),
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 50),
                              width: 180,
                              decoration: BoxDecoration(
                                // color: Colors.indigo.shade900,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Center(
                                child: Text(
                                  "Sign In",
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
                        'Not a member?',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => RegisterPage()),
                          );
                        },
                        child: new Text(
                          'Register now',
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

  void _login() async {
    setState(() {
      _isLoading = true;
    });
    var data = {
      'email': usernameController.text,
      'password': passwordController.text
    };

    var res = await Network().auth(data, 'logins');
    var body = json.decode(res.body);
    var role = '';
    if (body['OUT_STAT'] == "T") {
      var lenght = json.encode(body['OUT_DATA']['role']).length;
      role = json.encode(body['OUT_DATA']['role']).substring(1, lenght - 1);
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('token', json.encode(body['OUT_DATA']['token']));
      localStorage.setString('user', json.encode(body['OUT_DATA']['name']));
      localStorage.setString('role', json.encode(body['OUT_DATA']['role']));
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
      } else {
        _showMsg(body['OUT_MESS']);
      }
    } else {
      _showMsg(body['OUT_MESS']);
    }

    setState(() {
      _isLoading = false;
    });
  }
}
