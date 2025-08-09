import 'package:example/extensions/image_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../pages/home/home_list_model_entity.dart';

class PostItemWidget extends StatelessWidget {
  final HomeListModelDatas data;
  final int index;
  final ValueChanged<HomeListModelDatas>? onFavoriteTap;

  const PostItemWidget({
    super.key,
    required this.data,
    required this.index,
    this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(12, 18, 12, 18),
      // width: double.infinity,
      // height: 100.h,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Color(0xffcccccc), // 边框颜色
          width: 2.w, // 边框宽度
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
                  "avatar.jpg".img,
                  width: 30.w,
                  height: 30.h,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  (data.author?.isNotEmpty == true
                          ? data.author
                          : data.shareUser) ??
                      "",
                  style: TextStyle(fontSize: 16.sp, color: Color(0xff555555)),
                ),
              ),
              Text(
                data.niceShareDate ?? "",
                style: TextStyle(fontSize: 16.sp, color: Color(0xff555555)),
              ),
              SizedBox(width: 12.w),
              data.type == null ? SizedBox():
              data.type == 1
                  ? TextButton(
                      onPressed: () {
                        print("置顶");
                      },
                      child: Text(
                        "置顶",
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.blueAccent,
                        ),
                      ),
                      style: ButtonStyle(
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        minimumSize: WidgetStateProperty.all(Size(0, 0)),
                        padding: WidgetStateProperty.all(EdgeInsets.zero),
                      ),
                    )
                  : SizedBox(),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child:
            Html(data: data.title ?? "", style: {
              'html': Style(fontSize: FontSize(14.sp)),
            }),
            // Text(
            //   data.title!,
            //   maxLines: 2,
            //   softWrap: false,
            //   overflow: TextOverflow.ellipsis,
            //   style: TextStyle(
            //     fontSize: 16.sp,
            //     fontWeight: FontWeight.w500,
            //     color: Color(0xff555555),
            //   ),
            // ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  data.chapterName ?? "",
                  style: TextStyle(fontSize: 16.sp, color: Color(0xffff00ff)),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  onFavoriteTap?.call(data);
                },
                child: Icon(
                  data.collect == true ? Icons.star : Icons.star_border,
                  size: 24.sp,
                  color: Color(0xff999999),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
