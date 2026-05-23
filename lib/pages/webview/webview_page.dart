import 'package:example/components/wbview/base_webview_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../components/wbview/base_webview_widget.dart';

class WebviewPage extends StatelessWidget {
  const WebviewPage({super.key, this.title, this.url});

  final String? title;
  final String? url;

  @override
  Widget build(BuildContext context) {
    return url?.isNotEmpty == true
        ? BaseWebViewPage(
            webviewType: WebviewType.URL,
            loadResource: url!,
            showTitle: true,
            title: title ?? '',
          )
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(),
            body: SafeArea(
              bottom: false,
              child: Center(
                child: Text(
                  '参数有误，请返回！',
                  style: TextStyle(fontSize: 22.sp, color: Colors.black54),
                ),
              ),
            ),
          );
  }
}
