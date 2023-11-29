import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter_auth/network/api.dart';
import '../api/network.dart';
import 'dart:convert';
import 'login_page.dart';
import 'home_page.dart';
import 'package:mobile/components/room_card.dart';
import 'home_page.dart';
import 'home_guest.dart';
import 'page2.dart';
import 'searchDetail.dart';
import 'page3.dart';
import 'search.dart';
import 'profile_page.dart';

class Page4 extends StatefulWidget {
  final String start_date;
  final String end_date;
  final String adult;
  final String child;

  const Page4({
    super.key,
    required this.start_date,
    required this.end_date,
    required this.adult,
    required this.child,
  });
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Page4> {
  bool _isLoading = true;
  int _selectedIndex = 0;
  var list = [];

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

  _loadData() async {
    var data = {
      "start_date": widget.start_date,
      "end_date": widget.end_date,
      "adult": widget.adult,
      "child": widget.child,
    };
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var tokens = localStorage.getString('token');
    var lenght = tokens!.length;
    var token = tokens.substring(1, lenght - 1);
    var res = await Network().post(data, 'rooms/avail', token);
    var body = json.decode(res.body);
    if (body['OUT_STAT'] == "T") {
      _isLoading = false;
      list = body['OUT_DATA'];
      localStorage.setString('start_date', widget.start_date);
      localStorage.setString('end_date', widget.end_date);
      localStorage.setString('adult', widget.adult);
      localStorage.setString('child', widget.child);
      setState(() {});
      _showMsg("s");
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
                        child: ListView.builder(
                            itemCount: list.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => RoomDetail(
                                              id: list[index]['uuid'],
                                            )),
                                  );
                                },
                                child: HomeCard(
                                    image: "lib/images/superior.jpg",
                                    title: list[index]['type_name'],
                                    price: list[index]['price']),
                              );
                            }))
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
