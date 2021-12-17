import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_gallery/Photos/ShowPhotos.dart';
import 'package:my_gallery/Photos/UploadedPhotos.dart';

import 'loginScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 150,
                child: Image.asset(
                  "assets/icon.png",
                  fit: BoxFit.contain,
                ),
              ),
              Padding(padding: EdgeInsets.all(10)),
              Text(
                " Welcome",
                style: TextStyle(fontSize: 30.0),
              ),
              SizedBox(
                height: 50,
              ),
              Center(
                child: ElevatedButton.icon(
                  icon: Icon(
                    Icons.add_a_photo_rounded,
                  ),
                  label: Text(" Upload Photo"),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UploadedPhotos()));
                  },
                ),
              ),
              Center(
                child: ElevatedButton.icon(
                  icon: Icon(
                    Icons.photo_album_rounded,
                  ),
                  label: Text(" Show Photo"),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ShowPhotos()));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _appBar() {
    final appBarHeight = AppBar().preferredSize.height;
    return PreferredSize(
        child: AppBar(
          title: const Text(" Profile "),
          actions: [IconButton(onPressed: () {}, icon: Icon(Icons.logout))],
        ),
        preferredSize: Size.fromHeight(appBarHeight));
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()));
  }
}
