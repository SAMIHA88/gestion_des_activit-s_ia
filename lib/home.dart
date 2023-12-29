import 'dart:convert';
import 'dart:io';

import 'package:activites_management/liste_activites.dart';
import 'package:activites_management/login.dart';
import 'package:activites_management/profil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_v2/tflite_v2.dart';

void main() {
  runApp(MaterialApp(
    home: HomePage(),
  ));
}

class ImageClassifier {
  static List<Map<String, dynamic>> _recognitions = [];

  static Future<void> loadModel() async {
    await Tflite.loadModel(
      model: "assets/model_unquant.tflite",
      labels: "assets/labels.txt",
    );
  }

  static Future<List<Map<String, dynamic>>> classifyImage(File image) async {
    List<dynamic>? recognitions = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 6,
      threshold: 0.05,
      imageMean: 127.5,
      imageStd: 127.5,
    );

    if (recognitions != null) {
      _recognitions = List<Map<String, dynamic>>.from(
        recognitions.map((dynamic item) => Map<String, dynamic>.from(item)),
      );
    } else {
      _recognitions = [];
    }

    return _recognitions;
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  TextEditingController titleController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController adresseController = TextEditingController();
  TextEditingController minParticipantsController = TextEditingController();
  TextEditingController categoryController = TextEditingController();

  String base64Image = "";
  bool shouldUpdateCategory = false;

  void _addActivityToFirebase() {
    FirebaseFirestore.instance.collection('activities').add({
      'titre': titleController.text,
      'prix': double.tryParse(priceController.text) ?? 0.0,
      'imageUrl': base64Image,
      'adresse': adresseController.text,
      'nbr_min': int.tryParse(minParticipantsController.text) ?? 0,
      'categorie': categoryController.text,
    }).then((value) {
      titleController.clear();
      priceController.clear();
      adresseController.clear();
      minParticipantsController.clear();
      categoryController.clear();
      base64Image = "";
      shouldUpdateCategory = false;
    }).catchError((error) {
      print("Erreur d'ajout: $error");
    });
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      print("Déconnexion avec succès");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Déconnexion avec succès')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginEcran(),
        ),
      );
      print("Déconnexion avec succès");
    } catch (e) {
      print('Erreur de déconnexion: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur de déconnexion')),
      );
    }
  }

  Future<void> _pickAndConvertImage() async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        List<int> imageBytes = File(pickedFile.path).readAsBytesSync();
        base64Image = base64Encode(imageBytes);

        await ImageClassifier.loadModel();
        List<Map<String, dynamic>> recognitions =
            await ImageClassifier.classifyImage(File(pickedFile.path));

        if (recognitions.isNotEmpty) {
          setState(() {
            shouldUpdateCategory = true;
            categoryController.text = recognitions[0]['label'];
          });
        }
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  void _onNavBarItemTapped(int index) {
    if (index == 0) {
      // Logique pour naviguer vers la page "Accueil"
      // ...
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
    } else if (index == 1) {
      // Logique pour naviguer vers la page "Profil"
      // ...
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ProfilePage(),
        ),
      );
    } else if (index == 2) {
      // Logique pour naviguer vers la page "Activités"
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ListeActivites(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Toutes les activités'),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ListeActivites()),
              );
            },
          ),
           IconButton(
            onPressed: () async {
              try {
                await _signOut(context);
                print('Déconnexion réussie...');
              } catch (e) {
                print('Erreur lors de la déconnexion : $e');
              }
            },
            icon: Icon(Icons.exit_to_app),
          ), 
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Titre',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12.0),
              TextField(
                controller: priceController,
                decoration: InputDecoration(
                  labelText: 'Prix',
                  border: OutlineInputBorder(),
                ),
                keyboardType:
                    TextInputType.numberWithOptions(decimal: true),
              ),
              SizedBox(height: 12.0),
              TextField(
                controller: adresseController,
                decoration: InputDecoration(
                  labelText: 'Lieu',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12.0),
              TextField(
                controller: minParticipantsController,
                decoration: InputDecoration(
                  labelText: 'Nombre minimum de participants',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20.0),
              TextField(
                controller: categoryController,
                decoration: InputDecoration(
                  labelText: 'Catégorie',
                  enabled: !shouldUpdateCategory,
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () async {
                  await _pickAndConvertImage();
                },
                child: Text('Choisir une image'),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  _addActivityToFirebase();
                },
                child: Text('Ajouter'),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onNavBarItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Ajout',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Activités',
          ),
        ],
      ),
    );
  }
}
