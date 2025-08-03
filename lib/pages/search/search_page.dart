
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() {
    return _SearchPageState();
  }
}

class _SearchPageState extends State<SearchPage> {

  String? name;

  @override
  void didChangeDependencies() {
    var map = ModalRoute.of(context)?.settings?.arguments;
    if(map is Map){
      this.name = map["title"];
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(this.name!),),
      body: SafeArea(child: Column(children: [

      ])),
    );
  }
}