import 'package:ecurie/component/appbar.dart';
import 'package:ecurie/component/drawerApp.dart';
import 'dart:typed_data';
import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:convert';
import 'package:flutter_session_manager/flutter_session_manager.dart';

import 'package:ecurie/component/appbar.dart';
import 'package:ecurie/modeles/user_class.dart';
import 'package:ecurie/db/db.dart';
import 'package:ecurie/modeles/session.dart';

class Inscription extends StatefulWidget {
  const Inscription({super.key});

  @override
  _Inscription createState() => _Inscription();

}

class _Inscription extends State<Inscription> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController pictureController = TextEditingController();

  var sessionManager = SessionManager();

  String? _selectedImagePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: buildDrawer(context),
      appBar: buildApp(context, 'Inscription'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              pictureForm(context),
              const SizedBox(
                height: 20,
              ),
              nameForm(),
              const SizedBox(
                height: 20,
              ),
              passwordForm(),
              const SizedBox(
                height: 20,
              ),
              emailForm(),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  TextButton(

                    child: const Text('Valider'),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        String name = nameController.text;
                        String password = passwordController.text;
                        String email = emailController.text;
                        String? picture = "assets/myGentleMan.jpg";
                        DateTime now = DateTime.now();

                        if (_selectedImagePath != null)  {
                          compressAndSaveImage(_selectedImagePath!).then((compressedImageBase64) async {
                            User personPerso = User(
                              name: name,
                              password: password,
                              email: email,
                              picture: compressedImageBase64,
                              datetime: now,
                            );

                            Map<String, dynamic> jsonUser = personPerso.toMap();
                            await DbMongo.insertInDb(jsonUser, 'Inscription');

                            await Session().setSession("name",name);
                            await Session().setSession("email", email);
                            await Session().setSession("picture", compressedImageBase64);

                            Navigator.pushNamed(context, '/');
                          });
                        } else {
                          User personPerso = User(
                            name: name,
                            password: password,
                            email: email,
                            picture: picture,
                            datetime: now,
                          );

                          Map<String, dynamic> jsonUser = personPerso.toMap();
                          DbMongo.insertInDb(jsonUser, 'Inscription');

                          Session().setSession("name",name);
                          Session().setSession("email", email);
                          Session().setSession("picture", picture);

                          Navigator.pushNamed(context, '/');
                        }
                      }
                    },
                  ),

                  TextButton(
                    child: const Text('Annuler'),
                    onPressed: () {
                      Navigator.pushNamed(context, '/');
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> compressAndSaveImage(String imagePath) async {
    Uint8List? imageBytes = await FlutterImageCompress.compressWithFile(
      imagePath,
      quality: 70,
    );

    if (imageBytes != null) {
      String compressedImageBase64 = base64Encode(imageBytes);
      return compressedImageBase64;
    } else {
      throw Exception('Failed to compress image');
    }
  }

  Widget pictureForm(BuildContext context) {
    return Stack(
      children: <Widget> [
        CircleAvatar(
          radius: 80.0,
          backgroundImage: _selectedImagePath != null
            ? FileImage(File(_selectedImagePath!)) as ImageProvider
            : AssetImage("assets/myGentleMan.jpg"),
        ),
        Positioned(
          bottom: 20.0,
          right: 20.0,
          child: InkWell(
            onTap: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles(
                type: FileType.image,
              );

              if (result != null) {
                setState(() {
                  _selectedImagePath = result.files.single.path!;
                });
              }
            },
            child: const Icon(
              Icons.camera_alt,
              color: Colors.teal,
              size: 28.0,
            ),
          ),
        ),
      ],
    );
  }

  Widget nameForm() {
    return TextFormField(
      decoration: const InputDecoration(hintText: 'Nom'),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Veuillez renseigner un nom';
        }
        return null;
      },
      controller: nameController,
    );
  }

  Widget passwordForm() {
    return  TextFormField(
      decoration: const InputDecoration(hintText: 'Mot de passe'),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Veuillez renseigner un mot de passe';
        }
        return null;
      },
      controller: passwordController,
    );
  }

  Widget emailForm() {
    return TextFormField(
      decoration: const InputDecoration(hintText: 'Email'),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Veuillez renseigner un email';
        }
        return null;
      },
      controller: emailController,
    );
  }
}