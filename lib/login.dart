import 'package:activites_management/home.dart';
import 'package:activites_management/liste_activites.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:fluttertoast/fluttertoast.dart';
import 'register.dart'; // Import the RegisterPage file

class LoginEcran extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> _signInWithEmailAndPassword(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
     // _showSuccessToast("Authentification réussie");
       ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Authentification réussie')),
        );
    } catch (e) {
      print('Erreur de connexion: $e');
     // _showErrorToast("Erreur de connexion", context);
       ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur de connexion')),
        );
    }
  }

  /*void _showSuccessToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  void _showErrorToast(String message, context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Erreur de connexion'),
        backgroundColor: Colors.red,
      ),
    );
  }
*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF87CEEB),
              Color(0xFFADD8E6),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              20,
              MediaQuery.of(context).size.height * 0.1,
              20,
              0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Bienvenue dans EventFlow",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  width: 200.0,
                  height: 200.0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(35.0),
                    child: Image(
                      image: AssetImage('assets/images/loisirs.jpg'),
                      fit: BoxFit.cover,
                      width: 200.0,
                      height: 200.0,
                    ),
                  ),
                ),
                SizedBox(height: 30),
                _buildTextField(
                  "Entrer votre login",
                  Icons.person_outline,
                  false,
                  emailController,
                ),
                SizedBox(height: 20),
                _buildTextField(
                  "Entrer votre Mot de passe",
                  Icons.lock_outline,
                  true,
                  passwordController,
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () async {
                    await _signInWithEmailAndPassword(context);
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                    elevation: MaterialStateProperty.all<double>(4.0),
                    textStyle: MaterialStateProperty.all<TextStyle>(
                      TextStyle(fontSize: 18.0),
                    ),
                  ),
                  child: Text('Se connecter'),
                ),
                SizedBox(height: 30),
                _buildSignUpOption(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String labelText,
    IconData icon,
    bool isPassword,
    TextEditingController controller,
  ) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
      ),
      obscureText: isPassword,
    );
  }

  Widget _buildSignUpOption(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Vous n'avez pas de compte?",
            style: TextStyle(color: Colors.white70)),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RegisterPage()),
            );
          },
          child: const Text(
            "S'inscrire",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
