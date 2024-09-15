import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';

import '../widgets/account_info/image_uploader_circle.dart';

import '../utils/color_utilis.dart';

import '../pages/home_page.dart';
import '../pages/search_page.dart';
import '../pages/profile_page.dart';
import '../pages/purchased_courses_page.dart';

class MainPage extends StatefulWidget {
  static const String id = 'MainPage';

  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final List<IconData> _iconList = [
    Icons.home,
    Icons.import_contacts_outlined,
    Icons.search,
  ];
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    PurchasedCoursesPage(),
    SearchPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _pages[_selectedIndex],
      bottomNavigationBar: AnimatedBottomNavigationBar.builder(
        itemCount: _iconList.length + 1,
        tabBuilder: (int index, bool isActive) {
          if (index == _iconList.length) {
            return Padding(
                padding: const EdgeInsets.all(10),
                child: ImageUploaderCircle(
                  radius: 10,
                  onTap: () {
                    setState(
                      () => _selectedIndex = index,
                    );
                  },
                ));
          }
          return Icon(
            _iconList[index],
            color: isActive ? ColorUtility.deepYellow : Colors.black,
            size: 30,
          );
        },
        activeIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        gapLocation: GapLocation.none,
        notchSmoothness: NotchSmoothness.smoothEdge,
        leftCornerRadius: 20,
        rightCornerRadius: 20,
      ),
    );
  }
}
