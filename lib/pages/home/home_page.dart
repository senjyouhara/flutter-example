import 'package:cached_network_image/cached_network_image.dart';
import 'package:example/pages/webview/webview_page.dart';
import 'package:example/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';

import '../../routes/route_utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {

  final images = [
    Image.asset("assets/1.jpg", fit: BoxFit.cover,),
    Image.asset("assets/2.jpg", fit: BoxFit.cover,),
    Image.asset("assets/3.jpg", fit: BoxFit.cover,),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 150.h,
              child: Swiper(
                outer: false,
                autoplayDelay: 5000,
                itemCount: 3,
                autoplay: true,
                loop: true,
                indicatorLayout: PageIndicatorLayout.NONE,
                itemBuilder: (context, index) {
                  return Container(
                    width: double.infinity,
                    child: images[index],
                  );
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Container(padding: EdgeInsets.all(12),child:
                  GestureDetector(
                    child: _listItemView(index),
                    behavior: HitTestBehavior.translucent, // 或 .translucent
                    onTap: (){
                      print("路由跳转");
                      // RouteUtils.push(context, WebviewPage(title: "跳转页面标题"));
                      RouteUtils.pushNamed(context, RoutesPath.webviewPage, arguments: {"title": "跳转页面标题222"});
                      // Navigator.push(context, MaterialPageRoute(builder: (c) => WebviewPage(title: "跳转页面标题")));
                    },
                  )
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _listItemView(int index) {
    return Container(
      padding: EdgeInsets.fromLTRB(12, 18, 12, 18),
      // width: double.infinity,
      // height: 100.h,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Color(0xffcccccc), // 边框颜色
          width: 2, // 边框宽度
        ),
        borderRadius: BorderRadius.circular(8),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            // mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.asset(
                  "assets/avatar.jpg",
                  width: 30.w,
                  height: 30.h,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  "username",
                  style: TextStyle(fontSize: 16, color: Color(0xff555555)),
                ),
              ),
              Text(
                "2025-09-09: 22:22:22",
                style: TextStyle(fontSize: 16, color: Color(0xff555555)),
              ),
              SizedBox(width: 12,),
              TextButton(onPressed: (){
                print("置顶");
              }, child: Text("置顶", style: TextStyle(fontSize: 16, color: Colors.blueAccent),),
                style: ButtonStyle(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  minimumSize: WidgetStateProperty.all(Size(0, 0)),
                  padding: WidgetStateProperty.all(EdgeInsets.zero),
                ),
              ),
            ],
          ),
          Padding(padding: EdgeInsets.only(top: 10, bottom: 10),
          child: Text("内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容",
            maxLines: 2,
            softWrap: false,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xff555555)),),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: Text("类别", style: TextStyle(fontSize: 16, color: Color(0xffff00ff)),)),
              Icon(Icons.star, size: 24, color: Color(0xff999999),),
            ],
          )
        ],
      ),
    );
  }
}
