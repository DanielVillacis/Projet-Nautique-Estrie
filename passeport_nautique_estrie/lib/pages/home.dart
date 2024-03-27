import 'package:flutter/material.dart';
import 'package:passeport_nautique_estrie/db.dart';
import 'package:passeport_nautique_estrie/pages/embarcation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'custom_drawer.dart';
import 'add_boat.dart';

class HomePage extends StatefulWidget {
  final Future<void> Function() logoutAction;

  const HomePage({Key? key, required this.logoutAction}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState(logoutAction);

  PreferredSizeWidget appBar(context) {
    return AppBar(
      title: const Text(
        'Accueil',
        style: TextStyle(
          color: Colors.white,
          fontSize: 26,
          fontWeight: FontWeight.w200,
          fontFamily: 'Poppins-Light',
        ),
      ),
      backgroundColor: const Color(0xFF3A7667),
      centerTitle: false,
    );
  }
}

class _HomePageState extends State<HomePage> {
  final Future<void> Function() logoutAction;

  _HomePageState(this.logoutAction, {Key? key});

  List<List<dynamic>> embarcations = [];

  @override
  void initState() {
    super.initState();
    _fetchEmbarcations();
  }

  Future<void> _fetchEmbarcations() async {
    try {
      final connection = await DB.getConnection();
      final prefs = await SharedPreferences.getInstance();
      final sub = prefs.getString('sub');
      var results = await connection.query(
          "SELECT * from voir_embarcation_utilisateur(@sub)",
          substitutionValues: {"sub": sub});
      setState(() {
        embarcations = results;
      });
      await connection.close();
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: HomePage(logoutAction: logoutAction).appBar(context),
      drawer: CustomDrawer(
        onEmbarcationsTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    HomePage(logoutAction: logoutAction).appBar(context)),
          );
        },
        logoutAction: logoutAction,
      ),
      body: body(context),
      bottomNavigationBar: footer(context),
    );
  }

  Center body(BuildContext context) {
    return Center(
      child: Container(
        width: 400,
        margin: const EdgeInsets.only(top: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(
              'Mes Embarcations',
              style: TextStyle(
                color: Colors.black,
                fontSize: 28,
                fontWeight: FontWeight.w900,
                fontFamily: 'Poppins-Bold',
              ),
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Display two items per row
                  mainAxisSpacing: 10.0, // Spacing between rows
                  crossAxisSpacing: 10.0, // Spacing between columns
                ),
                itemCount: embarcations.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    // add a loop to display the embarcations
                    title: Image.network(
                      embarcations[index][0],
                      height: double.infinity,
                    ),
                    subtitle: Text(embarcations[index][1]),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DetailsEmbarcation(
                                  logoutAction: logoutAction,
                                  embarcationUtilisateur: embarcations[index][3],
                                )),
                      );
                    },
                  );
                },
              ),
            ),
            // Image.asset(
            //   'Assets/CREE_Logo - vert.png',
            //   width: 140,
            // ),
            // const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Container footer(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
              width: 1.0,
              color:
                  Colors.grey), // Adjust the border color and width as needed
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            onPressed: () {
              // Navigate to the addBoat.dart page
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddBoatPage(
                          logoutAction: logoutAction,
                        )),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF18848C),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text(
              'Ajouter une embarcation',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins-Bold',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Handle 'Prêter une embarcation' button tap
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF18848C),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text(
              'Prêter une embarcation',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins-Bold',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
