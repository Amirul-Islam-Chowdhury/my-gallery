import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ShowPhotos extends StatefulWidget {
  const ShowPhotos({Key? key, this.userId}) : super(key: key);
  final String? userId;
  @override
  _ShowPhotosState createState() => _ShowPhotosState();
}

class _ShowPhotosState extends State<ShowPhotos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Uploaded Photos ")),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(widget.userId)
            .collection("photos")
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return (const Center(child: Text("No Images Found")));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (BuildContext context, int index) {
                String url = snapshot.data!.docs[index]['downloadURL'];
                return Image.network(
                  url,
                  height: 300,
                  fit: BoxFit.fitWidth,
                );
              },
            );
          }
        },
      ),
    );
  }
}
