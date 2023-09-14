import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../db/db.dart';
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