import 'package:example/pages/search/search_vm.dart';
import 'package:example/routes/route_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../components/loading.dart';
import '../../routes/routes.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() {
    return _SearchPageState();
  }
}

class _SearchPageState extends State<SearchPage> {
  FocusNode focusNode = new FocusNode();
  String name = "";
  final SearchValueController = TextEditingController();
  final vm = SearchViewModel();
  RefreshController _refreshController = RefreshController(
    initialRefresh: false,
  );
  int _page = 1;

  void _onRefresh() async {
    _page = 1;
    // monitor network fetch
    await vm.search(name, _page);
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    _page++;
    // monitor network fetch
    await vm.search(name, _page);
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    if (mounted) setState(() {});

    _refreshController.loadComplete();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var map = ModalRoute.of(context)?.settings?.arguments;
      if (map is Map) {
        if (map["title"]?.toString().isNotEmpty == true) {
          this.name = map["title"];
          SearchValueController.text = map["title"];
          setState(() {});
          Loading.showLoading();
          onSearch(this.name);
        } else {
          FocusScope.of(context).requestFocus(focusNode);
        }
      }
    });
  }

  void onSearch(String value) async {
    _page = 1;
    try {
      // 隐藏软键盘
      // SystemChannels.textInput.invokeMethod("TextInput.hide");
      FocusScope.of(context).unfocus();
      Loading.showLoading();
      await vm.search(value, _page);
    } catch (e) {}
    Loading.dismissAll();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SearchViewModel>(
      create: (context) {
        return vm;
      },
      child: Scaffold(
        // appBar: AppBar(title: Text(this.name!),),
        body: SafeArea(
          bottom: false,
          child: SmartRefresher(
            controller: _refreshController,
            enablePullDown: true,
            enablePullUp: true,
            onRefresh: _onRefresh,
            onLoading: _onLoading,
            header: MaterialClassicHeader(),
            footer: ClassicFooter(loadingText: "正在加载中", failedText: "加载失败请重试"),
            child: SingleChildScrollView(
              child: Column(children: [_searchBar(), _searchList()]),
            ),
          ),
        ),
      ),
    );
  }

  Widget _searchBar() {
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(color: Color(0xff018b7d)),
      child: Row(
        spacing: 12.w,
        children: [
          GestureDetector(
            onTap: () {
              RouteUtils.pop(context);
            },
            child: Icon(Icons.chevron_left, size: 21, color: Colors.white),
          ),
          Expanded(
            child: TextFormField(
              controller: SearchValueController,
              onChanged: (val) {
                SearchValueController.text = val;
                name = val;
              },
              focusNode: focusNode,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.search,
              onFieldSubmitted: onSearch,
              cursorColor: Colors.black,
              style: TextStyle(color: Colors.black, fontSize: 14.sp),
              decoration: InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.never,
                fillColor: Colors.white,
                filled: true,
                isCollapsed: true,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 5,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 0.5.w),
                  borderRadius: BorderRadius.all(Radius.circular(15.r)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 0.5.w),
                  borderRadius: BorderRadius.all(Radius.circular(15.r)),
                ),
                labelText: "请输入",
                labelStyle: TextStyle(color: Colors.black45),
              ),
            ),
          ),
          // GestureDetector(
          //   onTap: (){
          //
          //   },
          //   child: Text("取消", style: TextStyle(fontSize: 14, color: Colors.white),),
          // ),
        ],
      ),
    );
  }

  Widget _searchList() {
    return Consumer<SearchViewModel>(
      builder: (context, vm, child) {
        return Container(
          child: ListView.builder(
            itemCount: vm.searchList.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  RouteUtils.pushNamed(
                    context,
                    RoutesPath.webviewPage,
                    arguments: {
                      "title": vm.searchList[index].title?.replaceAll(
                        RegExp(r"<[^>]*>"),
                        "",
                      ),
                      "url": vm.searchList[index].link,
                    },
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: vm.searchList.length - 1 == index
                        ? null
                        : Border(
                            bottom: BorderSide(
                              color: Color(0x66000000),
                              width: 1.w,
                            ),
                          ),
                  ),
                  padding: EdgeInsets.fromLTRB(6.w, 10.w, 6.w, 10.w),
                  child: Html(
                    data: vm.searchList[index].title ?? "",
                    style: {'html': Style(fontSize: FontSize(16.sp))},
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
