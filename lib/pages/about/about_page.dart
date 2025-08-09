import 'package:example/extensions/image_extension.dart';
import 'package:example/routes/route_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../routes/routes.dart';

class AboutPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AboutPageState();
  }




}

class _AboutPageState extends State<AboutPage> {



  String? _version;

  @override
  void initState() {

    getVersion();
  }

  Future getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    _version = "v" + packageInfo.version;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    const HTML_TEXT = r"""<h2>软件介绍</h2>
    <p>项目使用flutter进行开发，作为flutter学习过程产物，有可能有些bug未测试出来请见谅</p>
		<p>软件api使用wanandroid.com开放api进行数据对接调试，<a href="https://wanandroid.com/blog/show/2">wanandroid.com</a></p>
		<p>本app项目地址在 <a href="https://github.com/senjyouhara/flutter-example">flutter-example</a>  </p>
    """;

    return Scaffold(
      appBar: AppBar(title: Center(child: Text("关于我们")),),
      body: SafeArea(
        child: SingleChildScrollView(child: Container(
          padding: EdgeInsets.only(top: 18.r),
          child:Column(
              spacing: 8.w,
              children: [
                SvgPicture.asset("logo.svg".img, width: 70.r, height: 70.r,),
                Text(_version??"", style: TextStyle(
    fontSize: 16.sp,
                ),),
                Html(data: HTML_TEXT, style: {
                  'html': Style(fontSize: FontSize(15.sp)),
                  'h2': Style(fontSize: FontSize(21.sp), fontWeight: FontWeight.bold, textAlign: TextAlign.center),
                }, onLinkTap: (url, attributes, element){
                  RouteUtils.pushNamed(
                    context,
                    RoutesPath.webviewPage,
                    arguments: {"title": "关于我们", "url": url},
                  );
                },),
              ]),
        )),
      ),
    );
  }

}
