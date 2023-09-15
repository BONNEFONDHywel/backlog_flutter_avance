import 'package:ecurie/component/appbar.dart';
import 'package:ecurie/component/drawerApp.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../db/db.dart';
import 'package:ecurie/modeles/session.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ecurie/modeles/user_class.dart';

class ProfilePage extends StatefulWidget {
   VoidCallback onClicked = ()=>{};
   String imagePath = '';
 /* ProfilePage({
    Key? key,
    required this.imagePath,
    required this.onClicked,
  }) : super(key: key);*/
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class User {
  String picture;
  String name;
  String email;
  String phone;
  int age;
  String ffe;
  String password;

  User({
    required this.picture,
    required this.name,
    required this.email,
    required this.phone,
    required this.age,
    required this.ffe,
    required this.password,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      picture: json['picture'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      age: json['age'],
      ffe: json['ffe'],
      password: json['password'],
    );
  }
}

class _ProfilePageState extends State<ProfilePage> {
  User? myUser;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final session = Session();
    final userData = await session.getSession("user_data");
    if (userData != null) {
      setState(() {
        myUser = User.fromJson(userData);
        if (kDebugMode) {
          print("Données de l'utilisateur chargées avec succès : $myUser");
        }
      });
    } else {
      if (kDebugMode) {
        print("Aucune donnée utilisateur trouvée");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: buildDrawer(context),
      appBar: buildApp(context, 'Profil'),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          buildImage(),
          const SizedBox(height: 24),
          if (myUser != null) buildName(myUser!),
        ],
      ),
    );
  }
  Widget buildImage() {
    final imageUrl = myUser?.picture ?? 'assets/myGentleMan.jpg';
    if (imageUrl.startsWith('http') || imageUrl.startsWith('https')) {
      return Padding(
        padding: const EdgeInsets.only(top: 40),
        child: ClipOval(
          child: Material(
            color: Colors.transparent,
            child: Ink.image(
              image: NetworkImage(imageUrl),
              fit: BoxFit.cover,
              width: 128,
              height: 128,
              child: InkWell(onTap: widget.onClicked),
            ),
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(top: 40),
        child: ClipOval(
          child: Material(
            color: Colors.transparent,
            child: Ink.image(
              image: AssetImage(imageUrl),
              fit: BoxFit.cover,
              width: 128,
              height: 128,
              child: InkWell(onTap: widget.onClicked),
            ),
          ),
        ),
      );
    }
  }

  Widget buildName(User user) => Column(
    children: [
      Text(
        "Nom: ${user.name}",
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
      ),
      const SizedBox(height: 4),
      Text(
        "Email: ${user.email}",
        style: const TextStyle(color: Colors.grey, fontSize: 20),
      ),
      const SizedBox(height: 4),
      Text(
        "Âge: ${user.age}",
        style: const TextStyle(color: Colors.grey, fontSize: 20),
      ),
      const SizedBox(height: 4),
      Text(
        "Numéro de téléphone: ${user.phone}",
        style: const TextStyle(color: Colors.grey, fontSize: 20),
      ),
      const SizedBox(height: 4),
      Text(
        "Lien FFE: ${user.ffe}",
        style: const TextStyle(color: Colors.grey, fontSize: 20),
      ),
    ],
  );
}