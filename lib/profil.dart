import 'package:activites_management/liste_activites.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late User? _user;
  late TextEditingController _anniversaireController;
  late TextEditingController _adresseController;
  late TextEditingController _codePostalController;
  late TextEditingController _villeController;

  @override
  void initState() {
    super.initState();
    _anniversaireController = TextEditingController();
    _adresseController = TextEditingController();
    _codePostalController = TextEditingController();
    _villeController = TextEditingController();
    _fetchUserData();
  }

  void _fetchUserData() {
    _user = FirebaseAuth.instance.currentUser;

    if (_user != null) {
      String userId = _user!.uid;

      FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          Map<String, dynamic> data =
              documentSnapshot.data() as Map<String, dynamic>;
          setState(() {
            _anniversaireController.text = data['anniversaire'] ?? '';
            _adresseController.text = data['adresse'] ?? '';
            _codePostalController.text = data['codePostal'] ?? '';
            _villeController.text = data['ville'] ?? '';
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Mon Profil'),
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
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildDataField(Icons.email, 'Email', _user?.email ?? 'Unknown'),
              _buildDataField(Icons.lock, 'Password', '*****'),
              _buildDataInput(Icons.cake, 'Anniversaire',
                  _anniversaireController, 'Enter your birthday'),
              _buildDataInput(Icons.home, 'Adresse', _adresseController,
                  'Enter your address'),
              _buildDataInput(Icons.location_on, 'Code postale',
                  _codePostalController, 'Enter your postal code'),
              _buildDataInput(Icons.location_city, 'Ville', _villeController,
                  'Enter your city'),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _updateUserData,
        child: Icon(Icons.check),
        backgroundColor: Colors.blue,
      ),
    );
  }

  Widget _buildDataField(IconData icon, String label, String value) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon),
                SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataInput(IconData icon, String label,
      TextEditingController controller, String placeholder) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon),
                SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            TextFormField(
              controller: controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: placeholder,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _updateUserData() {
    if (_user != null) {
      String userId = _user!.uid;

      FirebaseFirestore.instance.collection('users').doc(userId).set({
        'anniversaire': _anniversaireController.text,
        'adresse': _adresseController.text,
        'codePostal': _codePostalController.text,
        'ville': _villeController.text,
      }).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profil modifié')),
        );
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de la modification du profil')),
        );
      });
    }
  }
}
