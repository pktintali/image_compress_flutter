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
  final List<File?> _imageFiles = [];
  final List<File?> _compressedFiles = [];

  Future<void> compress() async {
    for (var imageFile in _imageFiles) {
      var result = await FlutterImageCompress.compressAndGetFile(
        imageFile!.absolute.path,
        imageFile.path + 'compressed.jpg',
        quality: 50,
      );
      _compressedFiles.add(result);
    }
    setState(() {});
  }

  Future<void> pickImage() async {
    _imageFiles.clear();
    _compressedFiles.clear();
    final List<XFile>? images = await _picker.pickMultiImage();

    for (int i = 0; i < images!.length; i++) {
      _imageFiles.add(File(images[i].path));
    }
    setState(() {});
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
            if (_imageFiles.isNotEmpty)
              SizedBox(
                height: 550,
                child: ListView.builder(
                    itemCount: _imageFiles.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (c, i) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            const Text('Before'),
                            Image.file(
                              _imageFiles[i]!,
                              height: 200,
                              width: 200,
                            ),
                            Text(
                                '${(_imageFiles[i]!.lengthSync() / 1024).round()} kb'),
                            const Divider(),
                            if (_compressedFiles.isNotEmpty)
                              Column(
                                children: [
                                  const Text('After'),
                                  Image.file(
                                    _compressedFiles[i]!,
                                    height: 200,
                                    width: 200,
                                  ),
                                  Text(
                                      '${(_compressedFiles[i]!.lengthSync() / 1024).round()} kb'),
                                  const Divider(),
                                ],
                              )
                          ],
                        ),
                      );
                    }),
              ),
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
