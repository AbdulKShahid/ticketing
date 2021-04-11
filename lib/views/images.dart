import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ticketing/services/authentication_service.dart';
import 'package:provider/provider.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class ImagesScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Images();
  }
}

class _Images extends State<ImagesScreen> {
  PickedFile _image;
  File selectedImg;
  List<String> images1 = ["https://placeimg.com/500/500/any", "https://placeimg.com/500/500/any", "https://placeimg.com/500/500/any", "https://placeimg.com/500/500/any", "https://placeimg.com/500/500/any"];
  List<File> images = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: imagesList(context), // This trailing comma makes auto-formatting nicer for build methods.
      //body: this.selectedImg != null ? imagesList(context) : Text('Images go here') , // This trailing comma makes auto-formatting nicer for build methods.
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Add your onPressed code here!
          getImage();
        },
        label: const Text(''),
        icon: const Icon(Icons.camera_alt),
      ),
    );
  }

  Widget imagesList(BuildContext context){
    return Container(
        padding: EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: this.images.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 4.0, mainAxisSpacing: 4.0),
          itemBuilder: (BuildContext context, int index){
            return Image.file(this.images[index]);
          },
        ));
  }

  Future getImage() async {
    var image = await ImagePicker().getImage(source: ImageSource.camera);
    setState(() {
      this._image = image;
      this.selectedImg = File(_image.path);
      this.images.add(this.selectedImg);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

}