import 'package:example/components/loading.dart';
import 'package:example/components/wbview/base_webview_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BaseWebViewPage extends StatefulWidget {
  final WebviewType webviewType;
  final String loadResource;
  final Map<String, JsChannelCallback>? jsChannelMap;
  final String? title;
  final bool? showTitle;

  const BaseWebViewPage({
    super.key,
    required this.webviewType,
    required this.loadResource,
    this.jsChannelMap,
    this.title,
    this.showTitle,
  });

  @override
  State<BaseWebViewPage> createState() {
    return _BaseWebViewPageState();
  }
}

class _BaseWebViewPageState extends State<BaseWebViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.showTitle == false
          ? null
          : AppBar(title: _buildAppbarTitle(widget.title)),
      body: SafeArea(
        bottom: false,
        child: BaseWebViewWidget(
          webviewType: widget.webviewType,
          loadResource: widget.loadResource,
          jsChannelMap: widget.jsChannelMap,
        ),
      ),
    );
  }

  @override
  void dispose() {
    Loading.dismissAll();
    super.dispose();
  }

  Widget _buildAppbarTitle(String? title) {
    return Html(
      data: title ?? "",
      style: {'html': Style(fontSize: FontSize(15.sp))},
    );
  }

  String limitStr(String? str, {int limit = 15}) {
    if (str == null || str.isEmpty) {
      return "";
    }

    if (str.length > 15) {
      return str.substring(0, limit);
    }
    return str;
  }
}
