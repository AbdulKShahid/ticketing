

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class details extends StatefulWidget {
  @override
  State<StatefulWidget> createState(){
    return _details();
  }
}


class _details extends State<details> {

  var db;

  @override
  Future<void> initState() async {

    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Future<void> dispose() async {
    super.dispose();
  }

  void onPressedButton() {
    debugPrint('hgjhgjhg');
  }

  Widget form(){
    return TextButton(
      child: Text('hello'),
      onPressed: () => onPressedButton(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: form()
    );
  }
}