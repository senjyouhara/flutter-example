import 'package:example/components/wbview/base_webview_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../components/wbview/base_webview_widget.dart';

class WebviewPage extends StatefulWidget {
  final String? title;

  const WebviewPage({super.key, this.title});

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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      var map = ModalRoute.of(context)?.settings?.arguments;
      if (map is Map) {
        this.name = map["title"];
        this.url = map["url"];
        print("map : ${map}");
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return this.url?.isNotEmpty == true
        ? BaseWebViewPage(
            webviewType: WebviewType.URL,
            loadResource: this.url!,
            showTitle: true,
            title: this.name ?? "",
          )
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(),
            body: SafeArea(
              bottom: false,
              child: Center(
                child: Text(
                  "参数有误，请返回！",
                  style: TextStyle(fontSize: 22.sp, color: Colors.black54),
                ),
              ),
            ),
          );
  }
}
