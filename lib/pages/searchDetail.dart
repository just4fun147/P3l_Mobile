import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter_auth/network/api.dart';
import '../api/network.dart';
import 'dart:convert';
import 'login_page.dart';
import 'home_page.dart';
import 'package:mobile/components/home_card.dart';
import 'home_page.dart';
import 'home_guest.dart';
import 'book_confirm.dart';
import 'page2.dart';
import 'page3.dart';
import 'search.dart';
import 'profile_page.dart';
import 'package:mobile/components/my_textfield_number2.dart';

class RoomDetail extends StatefulWidget {
  final String id;
  const RoomDetail({
    super.key,
    required this.id,
  });
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<RoomDetail> {
  bool _isLoading = true;
  int _selectedIndex = 0;
  final totalController = TextEditingController();
  var name;
  var price;
  var normal_price;
  var qty;

  static List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    Page2(),
    Page3(),
    ProfilePage(),
  ];
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  _book() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.setString("totalRoom", totalController.text);
    localStorage.setString("name", name);
    localStorage.setString("price", price.toString());
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ConfirmBook()),
    );
  }

  _loadData() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var start = localStorage.getString('start_date');
    var end = localStorage.getString('end_date');
    var adult = localStorage.getString('adult');
    var child = localStorage.getString('child');
    var data = {
      "id": widget.id,
      "start_date": start,
      "end_date": end,
      "adult": adult,
      "child": child
    };
    var tokens = localStorage.getString('token');
    var lenght = tokens!.length;
    var token = tokens.substring(1, lenght - 1);
    var res = await Network().post(data, 'rooms/avail', token);
    var body = json.decode(res.body);

    if (body['OUT_STAT'] == "T") {
      _isLoading = false;
      name = body['OUT_DATA'][0]['type_name'];
      price = body['OUT_DATA'][0]['price'];
      normal_price = body['OUT_DATA'][0]['normal_price'];
      _showMsg("s");
      setState(() {});
    } else {
      _showMsg(body['OUT_MESS']);
    }
  }

  _showMsg(msg) {
    final snackBar = SnackBar(
      content: Text(msg),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          title: Text(
            'Grand Atma Hotel',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            onPressed: () => {setState(() => _selectedIndex = 0)},
            icon: Image.asset("lib/images/logo.png"),
          ),
          backgroundColor: Color(0xFF0C1738),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                // logout();
              },
            )
          ],
        ),
        body: _isLoading == true
            ? Center(child: Text("Loading"))
            : Container(
                padding: EdgeInsets.all(15),
                child: Column(
                  children: [
                    Expanded(
                        child: Container(
                      width: 400,
                      margin: EdgeInsets.only(top: 20),
                      child:
                          Card(child: Builder(builder: (BuildContext context) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: <Widget>[
                                    Image.asset(
                                      "lib/images/superior.jpg",
                                      width: MediaQuery.of(context).size.width -
                                          60,
                                    ),
                                  ],
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 20),
                                  child: Center(
                                      child: Text(name,
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold))),
                                ),
                                Row(
                                  children: [Text("Room Detail")],
                                ),
                                Row(
                                  children: [Text("22 m")],
                                ),
                                Row(
                                  children: [Text("2 Guest")],
                                ),
                                Divider(
                                  color: Colors.black,
                                ),
                                Row(
                                  children: [Text("About Room")],
                                ),
                                Row(
                                  children: [
                                    Text("Kamar terjangkau namun tetap nyaman")
                                  ],
                                ),
                                Divider(
                                  color: Colors.black,
                                ),
                                Row(
                                  children: [Text("Total Room")],
                                ),
                                Expanded(
                                  child: MyTextFieldNumber(
                                    controller: totalController,
                                    hintText: 'How Many Room',
                                    obscureText: false,
                                  ),
                                ),
                                ElevatedButton.icon(
                                    onPressed: _isLoading
                                        ? null
                                        : () async {
                                            _book();
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
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: SizedBox(
                                              child: Center(
                                                  child:
                                                      CircularProgressIndicator()),
                                              height: 21,
                                              width: 10,
                                            ),
                                          )
                                        : Container(
                                            padding: const EdgeInsets.all(25),
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 50),
                                            width: 180,
                                            decoration: BoxDecoration(
                                              // color: Colors.indigo.shade900,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: const Center(
                                              child: Text(
                                                "Book Now",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                  // fontFamily: font
                                                ),
                                              ),
                                            ),
                                          )),
                              ]),
                        );
                      })),
                    ))
                  ],
                ),
              ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          onTap: (i) => setState(() => _selectedIndex = i),
          selectedFontSize: 12.0,
          unselectedFontSize: 10.0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.explore_outlined),
              activeIcon: Icon(Icons.explore),
              label: 'Explore',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline),
              activeIcon: Icon(Icons.add_circle),
              label: 'My Reservation',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person_sharp),
              label: 'Profile',
            ),
          ],
        ));
  }
}
