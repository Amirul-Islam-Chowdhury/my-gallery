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
      backgroundColor: Colors.black38,
      appBar: AppBar(title: const Text("Uploaded Photos ")),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(widget.userId)
            .collection("photos")
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Text('Loading....',
                  style: TextStyle(color: Colors.white, fontSize: 50.0));
            default:
              if (snapshot.hasError)
                return Text('Error: ${snapshot.error}');
              else
                return Container(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      crossAxisCount: 2,
                    ),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      String url = snapshot.data!.docs[index]['downloadURL'];
                      return Image.network(
                        url,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                );
          }
        },
      ),
    );
  }
}
