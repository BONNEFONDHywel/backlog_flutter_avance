import 'package:flutter/material.dart';
import 'db/db.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'pages/cours.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async  {
  await dotenv.load(fileName: "assets/.env");
   DbMongo.connectToDb();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  const MaterialApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('fr', ''),
        ],
        debugShowCheckedModeBanner: false,
      home: HomePage()
    );
  }
}
class  HomePage extends StatefulWidget {
  const HomePage ({super.key});

  @override
  State<HomePage> createState() => _State();
}

class _State extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container( child:Center(
        child: Column(crossAxisAlignment: CrossAxisAlignment.center ,children: [Text('Hello World!'),
          TextButton(
              child:  const Text(
                'ADD',
                style: TextStyle(backgroundColor: Color.fromARGB(255, 241, 0, 241),color: Color.fromARGB(255, 255, 255, 255)),
              ),
              onPressed: () =>{
                Navigator.push(context,MaterialPageRoute(builder: (context) => const Cours()),
                )
              })
               ]),
      ),
      ),
    );
  }
}

