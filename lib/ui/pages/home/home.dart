import 'package:flutter/material.dart';
import 'package:spotify_clone/ui/pages/home/components/bottom_navigation_bar_tab.dart';
import 'package:spotify_clone/ui/pages/home/components/home_page_bottom_navigation_bar.dart';
import 'package:spotify_clone/ui/pages/home/screens/home/home_page_screen.dart';
import 'package:spotify_clone/ui/pages/home/screens/library/home_page_library_screen.dart';
import 'package:spotify_clone/ui/pages/home/screens/search/home_page_search_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (newPageIndex) {
          setState(
            () {
              currentPageIndex = newPageIndex;
            },
          );
        },
        children: const [
          HomePageScreen(),
          HomePageSearchScreen(),
          HomePageLibraryScreen(),
        ],
      ),
      extendBody: true,
      bottomNavigationBar: HomePageBottomNavigationBar(
        items: [
          BottomNavigationBarTab(
            svgAssetRoute: "lib/assets/svg/icons/home_active.svg",
            inactiveSvgAssetRoute: "lib/assets/svg/icons/home_inactive.svg",
            label: "Home",
            active: currentPageIndex == 0,
          ),
          BottomNavigationBarTab(
            svgAssetRoute: "lib/assets/svg/icons/search_active.svg",
            inactiveSvgAssetRoute: "lib/assets/svg/icons/search_inactive.svg",
            label: "Search",
            active: currentPageIndex == 1,
          ),
          BottomNavigationBarTab(
            svgAssetRoute: "lib/assets/svg/icons/your_library_active.svg",
            inactiveSvgAssetRoute:
                "lib/assets/svg/icons/your_library_inactive.svg",
            label: "Your library",
            active: currentPageIndex == 2,
          ),
        ],
        onPageRequested: (requestedPageIndex) {
          _pageController.jumpToPage(requestedPageIndex);
        },
      ),
    );
  }
}
