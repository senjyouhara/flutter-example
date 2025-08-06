import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oktoast/oktoast.dart';

class Loading {

  Loading._();

  static void showLoading() async {
    showToastWidget(
      Container(
        color: Colors.transparent,
        constraints: const BoxConstraints.expand(),
        child: Align(
          alignment: Alignment.center,
          child: Container(
            padding: EdgeInsets.all(20.r),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              color: Colors.black54,
            ),
            child: CircularProgressIndicator(
              strokeWidth: 2.w,
              valueColor: AlwaysStoppedAnimation(Colors.white),
            ),
          ),
        ),
      ),
      handleTouch: true,
      duration: Duration(days: 1),
    );
  }

  static void dismissAll() {
    dismissAllToast();
  }
}
