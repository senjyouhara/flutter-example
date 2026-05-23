import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LabelIcons {
  const LabelIcons({required this.label, required this.icon});

  final String label;
  final Widget icon;
}

class NavigationBarWidget extends StatelessWidget {
  const NavigationBarWidget({
    super.key,
    required this.navigationShell,
    required this.tabs,
    this.onTabChanged,
  });

  final StatefulNavigationShell navigationShell;
  final List<LabelIcons> tabs;
  final ValueChanged<int>? onTabChanged;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Theme(
        data: ThemeData(
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          currentIndex: navigationShell.currentIndex,
          selectedFontSize: 14,
          unselectedFontSize: 14,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.black45,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          items: tabs
              .map(
                (item) => BottomNavigationBarItem(
                  label: item.label,
                  icon: item.icon,
                  tooltip: '',
                ),
              )
              .toList(),
          onTap: (index) {
            onTabChanged?.call(index);
            navigationShell.goBranch(
              index,
              initialLocation: index == navigationShell.currentIndex,
            );
          },
        ),
      ),
    );
  }
}
