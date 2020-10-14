import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final void Function(File pickedImage) imagePickFn;

  UserImagePicker(this.imagePickFn);

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File _pickedImage; // kur saugom
  final picker = ImagePicker();

  void _pickImage() async {
    final pickedImageFile = await picker.getImage(
      source: ImageSource.camera,
      imageQuality:
          50, // galima pasirinktis tarp 0 ir 100. imam 50 kad image'as svertu maziau
      maxWidth: 150,
    ); // isrinktas image'as

    setState(() {
      if (pickedImageFile != null) {
        _pickedImage = File(pickedImageFile.path);
      } else {
        print('no image selected');
      }
    });
    widget.imagePickFn(
        _pickedImage); // paduodam issaugota image 'a i auth screen'a
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: Colors.purple,
          backgroundImage:
              _pickedImage != null ? FileImage(_pickedImage) : null,
          // tokiu budu yra backgroundImage'as nustatomas kaip NULL... ne pickedImage'as
          //t.y, kol nera image'o - bus, purple spalva, kai yra rodys image'a
        ),
        FlatButton.icon(
          onPressed: () {
            _pickImage();
          },
          icon: Icon(Icons.image),
          label: Text('add image'),
        ),
      ],
    );
  }
}
