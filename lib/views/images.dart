import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_viewer/image_viewer.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

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
  bool gridView = true;
  num currentImgIndex = 0;
  @override
  Widget build(BuildContext context) {
    var floatingButtons = [
      new Padding(padding: new EdgeInsets.all(20.0),child:


      FloatingActionButton.extended(
        onPressed: () {
          // switch to grid view
          setState(() {
            gridView = true;
          });
        },
        label: const Text(''),
        icon: const Icon(Icons.grid_view),
      ),

      ),
      /*new Padding(padding: new EdgeInsets.all(20.0),child:


      ElevatedButton(child: Text('Supprimer'), onPressed: () {
        // delete image both in storage and from the list for this ticket
        //deleteAnImage();
      }),

      ),*/
      new Padding(padding: new EdgeInsets.all(20.0),child:


      FloatingActionButton.extended(
        onPressed: () {
          // Add your onPressed code here!
          getImage();
        },
        label: const Text(''),
        icon: const Icon(Icons.camera_alt),
      ),

      ),




    ];
    if (gridView == true) {
      floatingButtons.removeAt(0);
      //floatingButtons.removeAt(0);
    }
    return Scaffold(
      body: gridView ? imageGridView(context) : imagesCaro(context) ,
      // This trailing comma makes auto-formatting nicer for build methods.
      //body: this.selectedImg != null ? imagesList(context) : Text('Images go here') , // This trailing comma makes auto-formatting nicer for build methods.
      floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: floatingButtons),
    );
  }

  Widget imagesCaro(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Container(
      height: height,
      margin: EdgeInsets.only(left: 15, right: 15),
      width: width,
      child: PhotoViewGallery.builder(
        itemCount: widget.images.length,
        builder: (context, index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: CachedNetworkImageProvider(
              widget.images[index],
            ),
            minScale: PhotoViewComputedScale.contained * 0.8,
            maxScale: PhotoViewComputedScale.covered * 2,
          );
        },
        scrollPhysics: BouncingScrollPhysics(),
        backgroundDecoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: Theme.of(context).canvasColor,
        ),
        enableRotation: true,
        loadingBuilder: (context, event) => Center(
          child: Container(
            width: 30.0,
            height: 30.0,
            child: CircularProgressIndicator(
              backgroundColor: Colors.orange,
              value: event == null
                  ? 0
                  : event.cumulativeBytesLoaded / event.expectedTotalBytes,
            ),
          ),
        ),
        onPageChanged: (int index) {
          setState(() {
            currentImgIndex = index;
          });
        },
      ),
    );
  }

  Widget imageGridView(BuildContext context) {
        return Container(
        padding: EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: widget.images != null ? widget.images.length : 0,

          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, crossAxisSpacing: 4.0, mainAxisSpacing: 4.0),
          itemBuilder: (BuildContext context, int index) {
            //return Image.network(widget.images[index]);


            return GestureDetector(
                onTap: () {
                // ontap of each card, set the defined int to the grid view index
                  setState(() {
                    gridView = false;
                  });
            },
              child: CachedNetworkImage(
                imageUrl: widget.images[index],
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
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
    widget.docToEdit.reference
        .collection('images')
        .add({'url': widget.images[widget.images.length - 1]});

    setState(() {
      gridView = true;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  getImages() {
    return widget.images;
  }

/*  deleteAnImage() {
    print(currentImgIndex);
    var m;
    widget.docToEdit.reference.collection('images').get().then((value) => {
      m = value.docs.asMap(),
      m.values.forEach((element) => {
        print(element)
      }),
      value.docs[currentImgIndex].data().delte
    });

    Firestore.instance.collection("chats").document("ROOM_1")
        .collection("messages").document(snapshot.data.documents[index]["id"])
        .delete();

  }*/
}
