import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter_auth/network/api.dart';
import '../api/network.dart';
import 'dart:convert';
import 'login_page.dart';
import 'home_page.dart';
import 'package:mobile/components/home_carousel.dart';
import 'package:mobile/components/home_card.dart';
import '../components/detail.dart';
import '../components/summary.dart';

class DetailReservation extends StatefulWidget {
  const DetailReservation({super.key, required this.id});

  final String id;
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<DetailReservation> {
  var data;
  var summary = [];
  var addon = [];
  var total;
  var start_date;
  var end_date;
  var invoice;
  bool _isLoading = true;
  _showMsg(msg) {
    final snackBar = SnackBar(
      content: Text(msg),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  void initState() {
    super.initState();
    _loadReservation();
  }

  _loadReservation() async {
    _isLoading = true;
    var data = {
      "id": widget.id,
      "search": null,
      "is_group": false,
      "is_open": true,
      "is_paid": false
    };
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var tokens = localStorage.getString('token');
    var lenght = tokens!.length;
    var token = tokens.substring(1, lenght - 1);
    var res = await Network().post(data, 'reservation', token);
    var body = json.decode(res.body);

    if (body['OUT_STAT'] == "T") {
      var unpaids = body['OUT_DATA'][0];
      var summarys = body['OUT_DATA'][0]['summary'].toList();
      var addons = body['OUT_DATA'][0]['addon'].toList();
      var totals = json.encode(body['OUT_DATA'][0]['total_price']);
      var invoices = json.encode(body['OUT_DATA'][0]['invoice_number']);
      var startDate = json.encode(body['OUT_DATA'][0]['end_date']);
      var endDate = json.encode(body['OUT_DATA'][0]['start_date']);
      var lenght = totals.length;
      var lenght2 = invoices.length;
      var lenght3 = startDate.length;
      var lenght4 = endDate.length;
      setState(() {
        data = unpaids;
        summary = summarys;
        addon = addons;
        total = totals.substring(1, lenght - 1);
        invoice = invoices.substring(1, lenght2 - 1);
        start_date = startDate.substring(1, lenght2 - 1);
        end_date = endDate.substring(1, lenght2 - 1);
        _isLoading = false;
      });
    } else {
      _showMsg("Something Went Wrong!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text(
          'Your Reservation',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFF0C1738),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              logout();
            },
          )
        ],
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(15),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 25),
              _isLoading
                  ? Center(
                      child: Text("Loading..."),
                    )
                  : Text(invoice,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Align(
                          alignment: Alignment.topLeft,
                          // child: Text("("+total+") " + type+" " ),
                          child: Text(start_date),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Align(
                          alignment: Alignment.topRight,
                          // child: Text("("+total+") " + type+" " ),
                          child: Text(end_date),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 50),
              Container(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: summary.length,
                    itemBuilder: (context, index) {
                      return Detail(
                          type: summary[index]['type_name'],
                          price: summary[index]['price'].toString(),
                          total: summary[index]['total'].toString());
                    }),
              ),
              const SizedBox(height: 25),
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: addon.length,
                  itemBuilder: (context, index) {
                    return Detail(
                        type: addon[index]['add_on_name'],
                        price: addon[index]['price'].toString(),
                        total: addon[index]['total'].toString());
                  }),
              !_isLoading ? Summary(price: total.toString()) : Container()
            ],
          ),
        ),
      ),
    );
  }

  void logout() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.remove('user');
    localStorage.remove('token');
    localStorage.remove('role');
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }
}
