import 'package:flutter/material.dart';
import 'package:passeport_nautique_estrie/view/pages/home.dart';
import 'package:passeport_nautique_estrie/db.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
class AccountPage extends StatefulWidget {
  const AccountPage(
      {Key? key})
      : super(key: key);

  @override
  _AccountPageState createState() =>
      _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  _AccountPageState();

  List<List<dynamic>> accountDetails = [];

  @override
  void initState() {
   super.initState();
    _fetchAccountDetails();
  }

  Future<void> _fetchAccountDetails() async {
    try {
      final connection = await DB.getConnection();
      final prefs = await SharedPreferences.getInstance();
      final sub = prefs.getString('sub');
      var results = await connection.query(
        "select * from utilisateur where sub = @sub;",
        substitutionValues: {"sub": sub},
      );
      setState(() {
        accountDetails = results;
      });
      await connection.close();
    } catch (e) {
      
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomePage().appBar(context, 'Mes infos'),
      body: body(),
    );
  }

  Widget body() {
    return Container(
      margin: const EdgeInsets.only(top: 50.0),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Mes infos',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Nom', style: TextStyle(fontSize: 18)),
                          Text(accountDetails[0][1], style: TextStyle(fontSize: 16)),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Date de creation', style: TextStyle(fontSize: 18)),
                          Text(DateFormat('yyyy-MM-dd').format(accountDetails[0][2]), style: TextStyle(fontSize: 16)),
                        ],
                      ),
                      // Add more Rows for more fields
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 340),
              const Text('Questions?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const Text(
                'If you have any questions about your account, please contact us.', 
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}