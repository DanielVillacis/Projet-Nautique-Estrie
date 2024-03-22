import 'package:flutter/material.dart';
import 'add_boat.dart';
import 'package:postgres/postgres.dart';
import 'package:passeport_nautique_estrie/env_config.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required Map<String, dynamic> boatData})
      : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();

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
  final connection = PostgreSQLConnection(
    EnvironmentConfig().host ?? '',
    EnvironmentConfig().port ?? 0000,
    EnvironmentConfig().database ?? '',
    username: EnvironmentConfig().username ?? '',
    password: EnvironmentConfig().password ?? '',
  );

  List<Map<String, dynamic>> embarcations = [];
  List<Map<String, dynamic>> embarcationsMoq = [
    {
      "id_embarcation": "1",
      "description": "Bateau à moteur",
      "marque": "Sea-Doo",
      "longueur": "12",
      "photo": "Assets/sea-doo.jpg",
    },
    {
      "id_embarcation": "2",
      "description": "Voilier",
      "marque": "Hobie Cat",
      "longueur": "16",
      "photo": "Assets/hobie-cat.jpg",
    },
    {
      "id_embarcation": "3",
      "description": "Kayak",
      "marque": "Pelican",
      "longueur": "10",
      "photo": "Assets/pelican.jpg",
    },
    {
      "id_embarcation": "4",
      "description": "Paddle",
      "marque": "Sea-Doo",
      "longueur": "12",
      "photo": "Assets/sea-doo.jpg",
    },
    {
      "id_embarcation": "5",
      "description": "Canoe",
      "marque": "Hobie Cat",
      "longueur": "16",
      "photo": "Assets/hobie-cat.jpg",
    },
    {
      "id_embarcation": "6",
      "description": "Kayak",
      "marque": "Pelican",
      "longueur": "10",
      "photo": "Assets/pelican.jpg",
    },
  ];

  @override
  void initState() {
    super.initState();
    _fetchEmbarcations();
  }

  Future<void> _fetchEmbarcations() async {
    try {
      await connection.open();
      var results = await connection.query('SELECT * FROM Embarcation');
      print(results); // Debugging
      setState(() {
        embarcations = results
            .map((row) => {
                  "id_embarcation": row[0],
                  "description": row[1],
                  "marque": row[2],
                  "longueur": row[3],
                  "photo": row[4],
                  // Add other fields here
                })
            .toList();
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
      appBar: const HomePage(
        boatData: {},
      ).appBar(context),
      drawer: drawer(context),
      body: body(context),
      bottomNavigationBar: footer(context),
    );
  }

  Center body(BuildContext context) {
    return Center(
      child: Container(
        width: 240,
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
              child: ListView.builder(
                itemCount: embarcationsMoq.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    // add a loop to display the embarcations
                    title: Text(embarcationsMoq[index]["description"]),
                    subtitle: Text(embarcationsMoq[index]["marque"]),
                    onTap: () {
                      // Navigate to the boat details page
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

  Drawer drawer(context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFF3A7667),
            ),
            child: Text(
              'Mon Passeport Nautique',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Poppins-Bold',
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            title: const Text('Mes embarcations'),
            onTap: () {
              // navigate to the home page
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const HomePage(
                          boatData: {},
                        )),
              );
            },
          ),
          ListTile(
            title: const Text('Mes infos'),
            onTap: () {
              // Update navigation to handle drawer item tap
            },
          ),
          ListTile(
            title: const Text('A propos'),
            onTap: () {
              // Update navigation to handle drawer item tap
            },
          ),
          ListTile(
            title: const Text('Aide'),
            onTap: () {
              // Update navigation to handle drawer item tap
            },
          ),
          ListTile(
            title: const Text('Me déconnecter'),
            onTap: () {
              // Update navigation to handle drawer item tap
            },
          ),
        ],
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
                MaterialPageRoute(builder: (context) => const AddBoatPage()),
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
