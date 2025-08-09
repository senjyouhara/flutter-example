import 'dart:io';

import 'package:dio/dio.dart';
import 'package:example/pages/personal/person_vm.dart';
import 'package:example/routes/route_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:install_plugin_v3/install_plugin_v3.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import '../../utils/filedir_path.dart';
import '../../utils/request/request.dart';

class UpdateDialog extends Dialog {
  final String upDateContent;
  final bool isForce;

  UpdateDialog({required this.upDateContent, required this.isForce});

  @override
  Widget build(BuildContext context) {
    return DialogContent(upDateContent: upDateContent, isForce: isForce);
  }

  static showUpdateDialog(
    BuildContext context,
    String mUpdateContent,
    bool mIsForce,
  ) async {
    var canPop = await _onWillPop();

    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return PopScope(
          child: UpdateDialog(upDateContent: mUpdateContent, isForce: mIsForce),
          canPop: canPop,
        );
      },
    );
  }

  static Future<bool> _onWillPop() async {
    return false;
  }
}

class DialogContent extends StatefulWidget {
  final String upDateContent;
  final bool isForce;

  DialogContent({required this.upDateContent, required this.isForce});

  @override
  _DialogContentState createState() => _DialogContentState();
}

class _DialogContentState extends State<DialogContent> {
  int total = 0;
  int received = 0;
  double precent = 0;
  String precentString = "0%";
  String totalMB = "0MB";
  String receivedMB = "0MB";
  bool isMain = true;

  Future onDownloadFile() async {
    final localPath = await FileDirPath.prepareSaveDir();
    String savePath = '$localPath/flutter-example-lastest.apk';
    File savePathFile = new File(savePath);
    if (!savePathFile.existsSync()) {
      await savePathFile.create();
    }

    var pageUrl =
        "https://github.com/senjyouhara/flutter-example/releases/download/lastest/flutter-example-lastest.apk";

    try {

      await Request.download(
        "$pageUrl",
        savePath: savePath,
        options: Options(
          receiveTimeout: Duration(days: 1),
          sendTimeout: Duration(days: 1),
          responseType: ResponseType.bytes,
          headers: {
            HttpHeaders.refererHeader:
            "https://github.com/senjyouhara/flutter-example/releases/download/lastest/flutter-example-lastest.apk",
            HttpHeaders.userAgentHeader:
            "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/118.0.0.0 Safari/537.36",
          },
        ),
        onReceiveProgress: (rec, t) {
          total = t;
          received = rec;
          precent = double.parse("${received / total}");
          totalMB = (total / 1024 / 1024).toStringAsFixed(2) + "MB";
          receivedMB = (received / 1024 / 1024).toStringAsFixed(2) + "MB";
          precentString = (precent * 100).toStringAsFixed(1).toString() + "%";
          print(
            "received: ${received}, total :${total}, precent: ${(received / total * 100).toStringAsFixed(2)}",
          );
          setState(() {});
        },
      );

      var result = await InstallPlugin.installApk(savePath);
      print(
        "apk install: ${result["isSuccess"] == true ? 'success' : 'faild${result['errorMessage'] ?? ''}'}",
      );

      if (result["isSuccess"] == true) {
      } else {}

    } catch (e) {
      print("err : $e");
      RouteUtils.pop(context);
      // showToast("下载失败");
    }

  }

  Widget _mainContent() {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 10.r),
            child: Text(
              '发现新版本',
              style: TextStyle(
                fontSize: 20.sp,
                color: Colors.black,
                decoration: TextDecoration.none,
              ),
            ),
          ),
          Text(
            widget.upDateContent,
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.black54,
              decoration: TextDecoration.none,
            ),
          ),
          Container(
            width: 250.w,
            height: 42.h,
            margin: EdgeInsets.only(bottom: 40.r),
            child: FilledButton(
              child: Text(
                '立即更新',
                style: TextStyle(fontSize: 20.sp, color: Colors.white),
              ),
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.red),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                ),
              ),
              onPressed: () async {
                setState(() {
                  isMain = false;
                });
                await onDownloadFile();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _progressContent() {
    return Container(
      width: double.infinity,
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 10.r, bottom: 70.r),
            child: Text(
              '下载文件',
              style: TextStyle(
                fontSize: 20.sp,
                color: Colors.black,
                decoration: TextDecoration.none,
              ),
            ),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 100.h,
                width: 100.w,
                child: CircularProgressIndicator(
                  strokeWidth: 4.w,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation(Colors.blue),
                  value: precent,
                ),
              ),
              Text(precentString, style: TextStyle(fontSize: 21.sp)),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 30.r, bottom: 20.r),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(receivedMB, style: TextStyle(fontSize: 16.sp)),
                Text("  /  ", style: TextStyle(fontSize: 16.sp)),
                Text(totalMB, style: TextStyle(fontSize: 16.sp)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 319.w,
            height: 350.h,
            child: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(8.r)),
                  ),
                ),
                isMain ? _mainContent() : _progressContent(),
              ],
            ),
          ),
          // GestureDetector(
          //   onTap: () {
          //     Navigator.pop(context);
          //   },
          //   child: Offstage(
          //     offstage: isForce,
          //     child: Container(
          //         margin: EdgeInsets.only(top: 30),
          //         child: Image.asset(
          //           AssetsUtil.getImagePath(
          //               imageName: 'ic_update_close', suffix: 'png'),
          //           width: 35,
          //           height: 35,
          //         )),
          //   ),
          // )
        ],
      ),
    );
  }
}
