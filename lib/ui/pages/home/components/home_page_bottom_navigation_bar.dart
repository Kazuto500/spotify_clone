import 'package:flutter/material.dart';
import 'package:spotify_clone/ui/pages/home/components/bottom_navigation_bar_tab.dart';

class HomePageBottomNavigationBar extends StatelessWidget {
  final List<BottomNavigationBarTab> items;
  final Function(int pageIndex) onPageRequested;
  const HomePageBottomNavigationBar({
    super.key,
    required this.items,
    required this.onPageRequested,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0x00121212),
            Color(0x7f121212),
            Color(0xaa121212),
            Color(0xff121212),
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(
            items.length,
            (index) => Expanded(
              child: GestureDetector(
                onTap: () {
                  onPageRequested(index);
                },
                child: Material(
                  color: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: items[index],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
