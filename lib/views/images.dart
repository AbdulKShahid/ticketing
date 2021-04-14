import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
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

  final FirebaseStorage _storage = FirebaseStorage(storageBucket: 'gs://ticketing-be5bf.appspot.com');
  UploadTask storageEvent;
  PickedFile _image;
  File selectedImg;
  List<String> images1 = ["https://firebasestorage.googleapis.com/v0/b/ticketing-be5bf.appspot.com/o/2021-04-13%2000%3A36%3A34.746232?alt=media&token=02d0e226-5b34-4218-bad6-a518931b1a34"];
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
          itemCount: this.images1.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 4.0, mainAxisSpacing: 4.0),
          itemBuilder: (BuildContext context, int index){
            //return Image.network(this.images1[index]);
            return CachedNetworkImage(
              imageUrl: this.images1[index],
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
            );
          },
        ));
  }

  Future getImage() async {
    var image = await ImagePicker().getImage(source: ImageSource.camera);
    setState(() {
      this._image = image;
      this.selectedImg = File(_image.path);
      this.images.add(this.selectedImg);
      // upload to firebase
      this.storeImage(this.selectedImg);
    });
  }

  storeImage(File selectedImg) {
    String filePath = '${DateTime.now()}';
    String status;
    setState(() {
      var ref =  _storage.ref().child(filePath).putFile(selectedImg);
      print(ref.snapshot.metadata);
      var downloadUrl;
      ref.snapshotEvents.listen((TaskSnapshot taskSnapshot) async {
        print(taskSnapshot.state.toString());
        status = taskSnapshot.state.toString();
        if (status == 'TaskState.success') {
          downloadUrl = await taskSnapshot.ref.getDownloadURL();
          print(downloadUrl);
          this.images1.add(downloadUrl);
        } else {

        }
      });
    });

  }
  @override
  void dispose() {
    super.dispose();
  }

  getImages() {
    return this.images;


  }
}
