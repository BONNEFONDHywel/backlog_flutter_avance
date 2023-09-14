import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'db/db.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Activation de la page avec base de données
void main() async {
  await dotenv.load(fileName: "assets/.env");
  var db = DbMongo();
  db.connectToDb();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: MyStatefulWidget(),
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: ListView(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(
                left: 10,
                bottom: 50,
                right: 10,
                top: 50
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
          Container(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email',
              ),
            ),
          ),
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
          Container(
            height: 70,
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(
                top: 20,
                bottom: 20
            ),
            child: ElevatedButton(
              child: const Text('Valider'),
              onPressed: () {
                if (kDebugMode) {
                  print(nameController.text);
                  print(passwordController.text);
                }
              },
            )
          ),
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