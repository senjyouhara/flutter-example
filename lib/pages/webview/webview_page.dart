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

  String? name;
  String? url;

  @override
  void initState() {
    super.initState();

    // 如果直接name = map["title"];在build会获取不到值，因为路由信息获取晚于build 或者在 didChangeDependencies 获取值
    // WidgetsBinding.instance.addPostFrameCallback((timestamp){
    //   var map = ModalRoute.of(context)?.settings?.arguments;
    //   if(map is Map){
    //     name = map["title"];
    //     setState(() {});
    //   }
    // });
  }


  @override
  void didChangeDependencies() {
    var map = ModalRoute.of(context)?.settings?.arguments;
    if(map is Map){
      this.name = map["title"];
      this.url = map["url"];
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(this.name ?? widget.title),),
      body: SafeArea(child: Column(children: [

      ])),
    );
  }


}
