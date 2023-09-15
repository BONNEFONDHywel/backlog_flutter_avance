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

class User {
  final String imagePath;
  final String username;
  final String email;
  final String phoneNumber;
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

Future _editProfile(BuildContext context) {
  String _username = '';
  String _email = '';
  String _password = '';
  String _age = '';
  String _phoneNumber = '';
  String _linkToFFE = '';

  return showDialog(
    context: context,
    builder: (context) {
      submit() {
        Navigator.of(context).pop();
      }
      return AlertDialog(
        title: const Text('Modifier le profil'),
        content: Form(
          child: Column(
            children: [
              TextFormField(
                onChanged: (value) => _username = value,
              ),
            ],
          ),
        )
      );
    },
  );
}

// Permet un retour sur la page d'accueil (aka routes Alex)
AppBar buildAppBar(BuildContext context) {
  return AppBar(
    leading: const BackButton(),
    title: const Text('Profil'),
    actions: [
      IconButton(
        icon: const Icon(Icons.edit),
        onPressed: () => _editProfile(context),
      )
    ],
    backgroundColor: Colors.blueAccent,
    elevation: 0,
  );
}

class UserPreferences {
  static const myUser = User(
    imagePath: 'https://www.la-spa.fr/app/assets-spa/uploads/2023/07/prendre-soin_duree-vie-chat.jpg',
    username: 'Jean',
    email: 'a@a',
    phoneNumber: '0000000000',
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

    return Center(
      child: buildImage(),
    );
  }



  Widget buildImage() {
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
    const user = UserPreferences.myUser;

    return Scaffold(
      appBar: buildAppBar(context),
      body: ListView(
        physics: const BouncingScrollPhysics(),
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
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
      ),
      const SizedBox(height: 4),
      Text(
        user.email,
        style: const TextStyle(color: Colors.grey, fontSize: 20),
      ),
      const SizedBox(height: 40),
      Text(
        "Mon âge : ${user.age}\nMon numéro de téléphone : ${user.phoneNumber}\nLien de mon profil FFE",
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
      ),
    ],
  );
}

