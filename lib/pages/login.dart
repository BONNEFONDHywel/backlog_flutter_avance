import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../db/db.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Activation de la page avec base de données
void main() async {
  await dotenv.load(fileName: "assets/.env");
  DbMongo.connectToDb();
  runApp(const MainApp());
}

// Permet un retour sur la page d'accueil (aka routes Alex)
AppBar buildAppBar(BuildContext context) {

  return AppBar(
    leading: const BackButton(),
    backgroundColor: Colors.blueAccent,
    elevation: 0,
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: buildAppBar(context),
        body: const MyStatefulWidget(),
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

//Permet de sauvegarder les données entrées (nom et mdp) dans ces variables
class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: ListView(
        children: <Widget>[
          // Le titre de la page
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(
                left: 10,
                bottom: 30,
                right: 10,
                top: 30
            ),
            child: const Text(
              'Connexion',
              style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w500,
                  fontSize: 30
              ),
            )
          ),
          // Entrer son nom d'utilisateur
          Container(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Nom d'utilisateur",
              ),
            ),
          ),
          // Entrer son mdp
          Container(
            padding: const EdgeInsets.all(10),
            child: TextField(
              obscureText: true,
              controller: passwordController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Mot de passe',
              ),
            ),
          ),
          // Redirige sur un pop-up pour réinitialiser son mdp par email (renseigner email et nom d'utilisateur)
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton(
                child: const Text(
                  "J'ai oublié mon mot de passe",
                  style: TextStyle(fontSize: 15),
                ),
                onPressed: () {
                },
              )
            ]
          ),
          // Si on valide, on récupère les infos de la BDD et on se retrouve sur le profil (à finir)
          Container(
            height: 70,
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(
                top: 5,
                bottom: 20
            ),
            child: ElevatedButton(
              child: const Text('Valider'),
              onPressed: () async {
                var test = await DbMongo.userAccount(nameController, passwordController);
                if (test.isEmpty ) {
                  if (kDebugMode) {
                    print("Erreur");
                  }
                } else if (passwordController.text != test[0]['password']) {
                  if (kDebugMode) {
                    print("Erreur 2");
                  }
                } else {
                  Navigator.pushNamed(context, '/');
                }
                if (kDebugMode) {
                  print(nameController.text);
                  print(passwordController.text);
                }
              },
            )
          ),
          // En cliquant sur le bouton s'inscrire, cela redirige vers la page d'inscription (aka routes Alex)
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('Pas encore de compte ?'),
              TextButton(
                child: const Text(
                  "S'inscrire",
                  style: TextStyle(fontSize: 20),
                ),
                onPressed: () {
                },
              )
            ],
          ),
        ],
      )
    );
  }
}