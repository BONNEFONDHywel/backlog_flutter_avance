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

// Permet un retour sur la page d'accueil (aka routes Alex)
AppBar buildAppBar(BuildContext context) {
  return AppBar(
    leading: const BackButton(),
    backgroundColor: Colors.blueAccent,
    elevation: 0,
  );
}

class User {
  final String imagePath;
  final String username;
  final String email;
  final int phoneNumber;
  final int age;
  final String linkToFFE;

  const User({
    required this.imagePath,
    required this.username,
    required this.email,
    required this.phoneNumber,
    required this.age,
    required this.linkToFFE,
  });
}

class userPreferences {
  static const myUser = User(
      imagePath: 'https://www.la-spa.fr/app/assets-spa/uploads/2023/07/prendre-soin_duree-vie-chat.jpg',
      username: 'Jean',
      email: 'a@a',
      phoneNumber: 0000000000,
      age: 20,
      linkToFFE: 'https://www.google.fr/',
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: ProfilePage(),
      ),
    );
  }
}

class ProfileWidget extends StatelessWidget {
  final String imagePath;
  final VoidCallback onClicked;

  const ProfileWidget({
    Key? key,
    required this.imagePath,
    required this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return Center(
      child: BuildImage(),
    );
  }

  Widget BuildImage() {
    final image = NetworkImage(imagePath);

    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: ClipOval(
        child: Material(
          color: Colors.transparent,
          child: Ink.image(
            image: image,
            fit: BoxFit.cover,
            width: 128,
            height: 128,
            child: InkWell(onTap: onClicked),
          ),
        ),
      ),
    );
  }

}

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final user = userPreferences.myUser;

    return Scaffold(
      appBar: buildAppBar(context),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          ProfileWidget(
            imagePath: user.imagePath,
            onClicked: () async {},
          ),
          const SizedBox(height: 24),
          buildName(user),
        ],
      ),
    );
  }

  Widget buildName(User user) => Column(
    children: [
      Text(
        user.username,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
      ),
      const SizedBox(height: 4),
      Text(
        user.email,
        style: TextStyle(color: Colors.grey),
      ),
    ],
  );
}

