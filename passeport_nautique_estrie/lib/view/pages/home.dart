import 'dart:core';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:passeport_nautique_estrie/services/firebase_storage_service.dart';
import 'package:passeport_nautique_estrie/view/pages/embarcation.dart';
import 'package:passeport_nautique_estrie/view/popup.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'custom_drawer.dart';
import 'add_boat.dart';
import 'package:passeport_nautique_estrie/controller/home_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

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
  _HomePageState({Key? key});

  List<List<dynamic>> embarcations = [];
  final controller = HomeController();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  fetchData() async {
    final prefs = await SharedPreferences.getInstance();
    final sub = prefs.getString('sub');
    var results = await controller.getEmbarcations(sub);
    setState(() {
      embarcations = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:
          true, // set a true pour eviter que le clavier chevauche
      appBar: widget.appBar(context),
      drawer: CustomDrawer(
        onEmbarcationsTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => widget.appBar(context)),
          );
        },
      ),
      body: body(context),
      bottomNavigationBar: footer(context),
    );
  }

  Center body(BuildContext context) {
    return Center(
      child: Container(
        width: 350,
        margin: const EdgeInsets.only(top: 60),
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
            const SizedBox(
              height: 30,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: embarcations.length,
                itemBuilder: (context, index) {
                  return FutureBuilder<String?>(
                    future: Get.put(FirebaseStorageService())
                        .getImage(embarcations[index][0]),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        // While waiting for the future to complete, return a loading indicator
                        return Container(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Color.fromARGB(
                                    255, 87, 87, 87), // Light gray color
                                width: 0.2, // Adjust the width as needed
                              ),
                            ),
                          ),
                          child: const CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        // If an error occurs while fetching the image, display an error message
                        return Container(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Color.fromARGB(
                                    255, 87, 87, 87), // Light gray color
                                width: 0.2, // Adjust the width as needed
                              ),
                            ),
                          ),
                          child: const Text('Error loading image'),
                        );
                      } else {
                        // If the future completes successfully, display the image
                        final imgUrl = snapshot.data;
                        return Container(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Color.fromARGB(255, 87, 87, 87),
                                width: 0.2,
                              ),
                            ),
                          ),
                          child: GestureDetector(
                            onLongPress: () {
                              PopupMenuUtil.showPopupMenu(context, embarcations[index][3], index);
                            },
                            child: ListTile(
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Nom:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(embarcations[index][1]),
                                ],
                              ),
                              trailing: Image.network(
                                imgUrl!,
                                height: double.infinity,
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailsEmbarcation(
                                      embarcationUtilisateur:
                                          embarcations[index][3],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      }
                    },
                  );
                },
              ),
            ),
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
        ],
      ),
    );
  }
}

