import 'package:flutter/material.dart';
import 'db/db.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:ecurie/flux_dactivite.dart';

void main() async  {
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
      title: 'Ecurie',
      home: MyApp(),
    );
  }
}
