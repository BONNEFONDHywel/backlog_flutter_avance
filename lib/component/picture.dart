import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

Future<File> assetToFile(String assetPath) async {
  // Lire l'actif
  final byteData = await rootBundle.load(assetPath);

  // Obtenir un répertoire temporaire pour créer le fichier
  final file = File('${(await getTemporaryDirectory()).path}/$assetPath');

  // Écrire les octets de l'actif dans le fichier
  await file.writeAsBytes(byteData.buffer.asUint8List());

  return file;
}

/*Widget pictureForm(BuildContext context, _selectedImagePath) {
  return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
    return Stack(
    children: <Widget> [
      CircleAvatar(
        radius: 80.0,
        backgroundImage: _selectedImagePath != null
            ? FileImage(File(_selectedImagePath!.toString())) as ImageProvider
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
  );});
}*/

class PictureForm extends StatefulWidget {
  final String? _selectedImagePath;
  final Function onImageSelected;

  const PictureForm(
      {Key? key, required String? selectedImagePath, required this.onImageSelected})
      : _selectedImagePath = selectedImagePath,
        super(key: key);
  @override
  _PictureFormState createState() => _PictureFormState();
}

class _PictureFormState extends State<PictureForm> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        CircleAvatar(
            radius: 80.0,
            backgroundImage: widget._selectedImagePath != null
                ? FileImage(File(widget._selectedImagePath!)) as ImageProvider
                : const AssetImage('assets/myGentleMan.jpg')),
        Positioned(
          bottom: 20.0,
          right: 20.0,
          child: InkWell(
            onTap: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles(
                type: FileType.image,
              );

              if (result != null) {
                widget.onImageSelected(result.files.single.path!);
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
}

Future<String> compressAndSaveImage(String imagePath) async {
  print(imagePath);
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
