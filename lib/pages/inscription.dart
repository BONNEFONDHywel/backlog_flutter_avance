import 'package:ecurie/component/appbar.dart';
import 'dart:io';
import 'dart:convert';

import 'package:ecurie/component/appbar.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

import 'package:ecurie/modeles/class_inscription.dart';
import 'package:ecurie/db/db.dart';

class Screen2 extends StatefulWidget {
  Screen2({super.key});

  @override
  _Screen2 createState() => _Screen2();
}

class _Screen2 extends State<Screen2> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController pictureController = TextEditingController();

  String? _selectedImagePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        String? picture = _selectedImagePath == null ? "assets/myGentleMan.jpg" : _selectedImagePath;

                        User personPerso = User(
                          name: name,
                          password: password,
                          email: email,
                          picture: picture,
                        );

                        String jsonUser = jsonEncode(personPerso);
                        print(jsonUser);

                        // DbMongo.insertInDb(jsonUser, 'Inscription');
                      }
                    },
                  ),
                  TextButton(
                    child: const Text('Annuler'),
                    onPressed: () {
                      print('pas réussi');
                      // Navigator.of(context).pop();
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
                type: FileType.image, // Vous pouvez spécifier le type de fichier que vous voulez (image, vidéo, etc.)
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