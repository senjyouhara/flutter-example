import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WebviewPage extends StatefulWidget {
  final String title;
  const WebviewPage({super.key, required this.title});

  @override
  State<WebviewPage> createState() {
    return _WebviewPageState();
  }
}

class _WebviewPageState extends State<WebviewPage> {

  String name = "";

  @override
  void initState() {
    super.initState();
    var map = ModalRoute.of(context)?.settings?.arguments;
    if(map is Map){
      name = map["title"];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title ?? name),),
      body: SafeArea(child: Column(children: [

      ])),
    );
  }


}
