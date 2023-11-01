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

class ChangePasswordPage extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<ChangePasswordPage> {
  final oldController = TextEditingController();
  final newController = TextEditingController();
  final confirmController = TextEditingController();
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text(
          'Change Your Password',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          onPressed: () => {},
          icon: Image.asset("lib/images/logo.png"),
        ),
        backgroundColor: Color(0xFF0C1738),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                margin: EdgeInsets.only(left: 25, bottom: 10, top: 10),
                child: Text("Old Password"),
              ),
            ),
            MyTextField(
              controller: oldController,
              hintText: 'Old Password',
              obscureText: true,
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                margin: EdgeInsets.only(left: 25, bottom: 10, top: 10),
                child: Text("New Password"),
              ),
            ),
            MyTextField(
              controller: newController,
              hintText: 'Pasword Atleast 8 Character',
              obscureText: true,
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                margin: EdgeInsets.only(left: 25, bottom: 10, top: 10),
                child: Text("Confirm New Password"),
              ),
            ),
            MyTextField(
              controller: confirmController,
              hintText: 'Type Your New Password Again',
              obscureText: true,
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
    );
  }

  void _update() async {
    setState(() {
      _isLoading = true;
    });
    var data = {
      'old_password': oldController.text,
      'new_password': newController.text,
      'confirm_new_password': confirmController.text,
    };
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var tokens = localStorage.getString('token');
    var lenght = tokens!.length;
    var token = tokens.substring(1, lenght - 1);
    var res = await Network().post(data, 'changePassword', token);
    var body = json.decode(res.body);
    if (body['OUT_STAT'] == "T") {
      _showMsg(body['OUT_MESS']);
      await Future.delayed(Duration(seconds: 3));
      var roles = localStorage.getString('role');
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
