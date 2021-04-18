import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';


final FirebaseAuth _auth = FirebaseAuth.instance;

class ImagesScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Images();
  }
  // Declare a field that holds the Todo.
  DocumentSnapshot docToEdit;
  List<String> images = [];

  ImagesScreen({this.images, this.docToEdit});
}

class _Images extends State<ImagesScreen> {
  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: 'gs://ticketing-fe06a.appspot.com');
  UploadTask storageEvent;
  PickedFile _image;
  File selectedImg;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: imagesList(context),
      // This trailing comma makes auto-formatting nicer for build methods.
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

  Widget imagesList(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: widget.images != null ? widget.images.length : 0,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, crossAxisSpacing: 4.0, mainAxisSpacing: 4.0),
          itemBuilder: (BuildContext context, int index) {
            //return Image.network(widget.images[index]);
            return CachedNetworkImage(
              imageUrl: widget.images[index],
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
            );
          },
        ));
  }

  Future getImage() async {
    var image = await ImagePicker().getImage(source: ImageSource.camera);
    this._image = image;
    this.selectedImg = File(_image.path);
    // upload to firebase
    this.storeImage(this.selectedImg);
  }

  storeImage(File selectedImg) {
    String filePath = '${DateTime.now()}';
    String status;
    setState(() {
      var ref = _storage.ref().child(filePath).putFile(selectedImg);
      var downloadUrl;
      ref.snapshotEvents.listen((TaskSnapshot taskSnapshot) async {
        status = taskSnapshot.state.toString();
        if (status == 'TaskState.success') {
          downloadUrl = await taskSnapshot.ref.getDownloadURL();
          setState(() {
            widget.images.add(downloadUrl);
            widget.images = [...widget.images];
            this.updateImgInTicket();
          });
        } else {}
      });
    });
  }

  updateImgInTicket() {
    widget.docToEdit.reference.collection('images').add({'url': widget.images[widget.images.length-1]});
  }

  @override
  void dispose() {
    super.dispose();
  }

  getImages() {
    return widget.images;
  }
}
