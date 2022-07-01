import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;
  File? _compressedFile;

  Future<void> compress() async {
    var result = await FlutterImageCompress.compressAndGetFile(
      _imageFile!.absolute.path,
      _imageFile!.path + 'compressed.jpg',
      quality: 66,
    );
    setState(() {
      _compressedFile = result;
    });
  }

  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _imageFile = File(image!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Image Compress'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Before'),
            if (_imageFile != null)
              Image.file(
                _imageFile!,
                height: 200,
                width: 200,
              ),
            if (_imageFile != null) Text('${_imageFile!.lengthSync()} bytes'),
            const Divider(),
            const Text('After'),
            if (_compressedFile != null)
              Image.file(
                _compressedFile!,
                height: 200,
                width: 200,
              ),
            if (_compressedFile != null)
              Text('${_compressedFile!.lengthSync()} bytes'),
            const Divider(),
            ElevatedButton(
              onPressed: () async {
                await pickImage();
              },
              child: const Text('Select Image'),
            ),
            ElevatedButton(
              onPressed: () async {
                await compress();
              },
              child: const Text('Compress'),
            )
          ],
        ),
      ),
    );
  }
}
