import 'package:flutter/material.dart';
import 'package:spotify_clone/ui/pages/home/components/home_page_drawer.dart';
import 'package:spotify_clone/ui/pages/home/screens/library/components/body/home_page_library_screen_body.dart';
import 'package:spotify_clone/ui/pages/home/screens/library/components/home_page_library_screen_app_bar.dart';

class HomePageLibraryScreen extends StatefulWidget {
  const HomePageLibraryScreen({super.key});

  @override
  State<HomePageLibraryScreen> createState() => _HomePageLibraryScreenState();
}

class _HomePageLibraryScreenState extends State<HomePageLibraryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size(double.infinity, 120),
        child: HomePageLibraryScreenAppBar(),
      ),
      drawer: const HomePageDrawer(),
      drawerScrimColor:
          Theme.of(context).scaffoldBackgroundColor.withOpacity(0.8),
      body: const HomePageLibraryScreenBody(),
    );
  }
}

class CustomFilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final Function onSelected;

  const CustomFilterChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onSelected();
      },
      child: Container(
        height: 40,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: selected ? null : Border.all(color: Colors.white54),
          color: selected ? Colors.green : Colors.transparent,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelLarge!.copyWith(
                color: selected ? Colors.black : Colors.white54,
              ),
        ),
      ),
    );
  }
}
