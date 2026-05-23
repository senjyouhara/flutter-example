import 'package:example/pages/search/search_vm.dart';
import 'package:example/routes/route_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../components/loading.dart';
import '../../routes/routes.dart';
import 'search_model_entity.dart';

class SearchPage extends HookConsumerWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final focusNode = useFocusNode();
    final name = useState('');
    final searchValueController = useTextEditingController();
    final refreshController = useMemoized(
      () => RefreshController(initialRefresh: false),
    );

    Future<void> onSearch(String value) async {
      try {
        FocusScope.of(context).unfocus();
        Loading.showLoading();
        final next = await ref.read(searchProvider.notifier).search(value);
        if (next.isPageEnd) {
          refreshController.loadNoData();
        } else {
          refreshController.resetNoData();
        }
      } catch (_) {
      } finally {
        Loading.dismissAll();
      }
    }

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final map = ModalRoute.of(context)?.settings.arguments;
        if (map is! Map) {
          return;
        }

        final routeTitle = map['title']?.toString() ?? '';
        if (routeTitle.isNotEmpty) {
          name.value = routeTitle;
          searchValueController.text = routeTitle;
          Loading.showLoading();
          onSearch(routeTitle);
        } else {
          FocusScope.of(context).requestFocus(focusNode);
        }
      });
      return refreshController.dispose;
    }, const []);

    Future<void> onRefresh() async {
      final next = await ref.read(searchProvider.notifier).refresh();
      refreshController.refreshCompleted();
      if (next.isPageEnd) {
        refreshController.loadNoData();
      } else {
        refreshController.resetNoData();
      }
    }

    Future<void> onLoading() async {
      final next = await ref.read(searchProvider.notifier).loadNextPage();
      if (next.isPageEnd) {
        refreshController.loadNoData();
      } else {
        refreshController.loadComplete();
      }
    }

    final searchState = ref.watch(searchProvider).asData?.value;
    final searchList = searchState?.searchList ?? const [];

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: SmartRefresher(
          controller: refreshController,
          enablePullDown: true,
          enablePullUp: true,
          onRefresh: onRefresh,
          onLoading: onLoading,
          header: const MaterialClassicHeader(),
          footer: const ClassicFooter(
            loadingText: '正在加载中',
            failedText: '加载失败请重试',
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                _searchBar(
                  context,
                  focusNode: focusNode,
                  name: name,
                  searchValueController: searchValueController,
                  onSearch: onSearch,
                ),
                _searchList(context, searchList),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _searchBar(
    BuildContext context, {
    required FocusNode focusNode,
    required ValueNotifier<String> name,
    required TextEditingController searchValueController,
    required Future<void> Function(String value) onSearch,
  }) {
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: const BoxDecoration(color: Color(0xff018b7d)),
      child: Row(
        spacing: 12.w,
        children: [
          GestureDetector(
            onTap: () {
              RouteUtils.pop(context);
            },
            child: const Icon(Icons.chevron_left, size: 21, color: Colors.white),
          ),
          Expanded(
            child: TextFormField(
              controller: searchValueController,
              onChanged: (val) {
                name.value = val;
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
                contentPadding: const EdgeInsets.symmetric(
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
                labelText: '请输入',
                labelStyle: const TextStyle(color: Colors.black45),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _searchList(BuildContext context, List<SearchModelDatas> searchList) {
    return ListView.builder(
      itemCount: searchList.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final item = searchList[index];
        return GestureDetector(
          onTap: () {
            RouteUtils.pushNamed(
              context,
              RoutesPath.webviewPage,
              arguments: {
                'title': item.title?.replaceAll(RegExp(r'<[^>]*>'), ''),
                'url': item.link,
              },
            );
          },
          child: Container(
            decoration: BoxDecoration(
              border: searchList.length - 1 == index
                  ? null
                  : Border(
                      bottom: BorderSide(
                        color: const Color(0x66000000),
                        width: 1.w,
                      ),
                    ),
            ),
            padding: EdgeInsets.fromLTRB(6.w, 10.w, 6.w, 10.w),
            child: Html(
              data: item.title ?? '',
              style: {'html': Style(fontSize: FontSize(16.sp))},
            ),
          ),
        );
      },
    );
  }
}
