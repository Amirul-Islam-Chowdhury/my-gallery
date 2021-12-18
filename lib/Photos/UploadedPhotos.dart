import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadedPhotos extends StatefulWidget {
  final String? userId;
  UploadedPhotos({Key? key, this.userId}) : super(key: key);

  @override
  _UploadedPhotosState createState() => _UploadedPhotosState();
}

class _UploadedPhotosState extends State<UploadedPhotos> {
  File? image;
  final imagePicker = ImagePicker();
  String? downloadURL;

  Future imagePickerMethod() async {
    final pick = await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pick != null) {
        image = File(pick.path);
      } else {
        showSnackBar("No File selected", Duration(milliseconds: 200));
      }
    });
  }

  showSnackBar(String snackText, Duration d) {
    final snackBar = SnackBar(content: Text(snackText), duration: d);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future uploadImage(File _image) async {
    final imgId = DateTime.now().millisecondsSinceEpoch.toString();
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    Reference reference = FirebaseStorage.instance
        .ref()
        .child('${widget.userId}/photos')
        .child("post_$imgId");

    await reference.putFile(_image);
    downloadURL = await reference.getDownloadURL();

    // cloud firestore
    await firebaseFirestore
        .collection("users")
        .doc(widget.userId)
        .collection("photos")
        .add({'downloadURL': downloadURL}).whenComplete(
            () => showSnackBar("Photos Uploaded", Duration(seconds: 2)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Photo Picker "),
      ),
      body: Center(
        child: Padding(
            padding: const EdgeInsets.all(8),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: SizedBox(
                    height: 500,
                    width: double.infinity,
                    child: Column(children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        flex: 4,
                        child: Container(
                          width: 300,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.red),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                    child: image == null
                                        ? const Center(
                                            child: Text("No image selected"))
                                        : Image.file(image!)),
                                Center(
                                  child: ElevatedButton.icon(
                                    icon: Icon(Icons.add_a_photo),
                                    label: Text(" Select Photo"),
                                    onPressed: () {
                                      imagePickerMethod();
                                    },
                                  ),
                                ),
                                Center(
                                  child: ElevatedButton.icon(
                                    icon: Icon(
                                      Icons.upload_file,
                                    ),
                                    label: Text(" Upload Photo"),
                                    onPressed: () {
                                      if (image != null) {
                                        uploadImage(image!);
                                      } else {
                                        showSnackBar("No photos selected ",
                                            Duration(milliseconds: 400));
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ])))),
      ),
    );
  }
}
