import 'dart:typed_data';

import 'package:ecurie/component/appbar.dart';
import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:convert';

import 'package:ecurie/modeles/class_inscription.dart';
import 'package:ecurie/db/db.dart';

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
                        String? picture = "assets/myGentleMan.jpg";

                        if (_selectedImagePath != null)  {
                          compressAndSaveImage(_selectedImagePath!).then((compressedImageBase64) async {
                            User personPerso = User(
                              name: name,
                              password: password,
                              email: email,
                              picture: compressedImageBase64,
                            );

                            Map<String, dynamic> jsonUser = personPerso.toMap();
                            await DbMongo.insertInDb(jsonUser, 'Inscription');

                            Navigator.of(context).pop();
                          });
                        } else {
                          User personPerso = User(
                            name: name,
                            password: password,
                            email: email,
                            picture: picture,
                          );

                          Map<String, dynamic> jsonUser = personPerso.toMap();
                          DbMongo.insertInDb(jsonUser, 'Inscription');

                          Navigator.of(context).pop();
                        }
                      }
                    },
                  ),

                  TextButton(
                    child: const Text('Annuler'),
                    onPressed: () {
                      Navigator.of(context).pop();
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
      quality: 70, // Ajustez la qualité de compression selon vos besoins
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