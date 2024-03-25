import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:spotify_clone/data/controllers/favorites_controller.dart';
import 'package:spotify_clone/data/controllers/search_media_controller.dart';
import 'package:spotify_clone/data/controllers/session_controller.dart';
import 'package:spotify_clone/ui/pages/home/screens/library/components/body/sections/favorite_albums_section.dart';
import 'package:spotify_clone/ui/pages/home/screens/library/components/body/sections/favorite_artists_section.dart';
import 'package:spotify_clone/ui/pages/home/screens/library/components/body/sections/favorite_tracks_section.dart';
import 'package:spotify_clone/ui/pages/home/screens/library/home_page_library_screen.dart';

class HomePageLibraryScreenBody extends StatefulWidget {
  const HomePageLibraryScreenBody({super.key});

  @override
  State<HomePageLibraryScreenBody> createState() =>
      _HomePageLibraryScreenBodyState();
}

class _HomePageLibraryScreenBodyState extends State<HomePageLibraryScreenBody> {
  final PageController _pageController = PageController();
  int currentFilterIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer3<SessionController, SearchMediaController,
        FavoritesController>(
      builder: (context, sessionController, searchMediaController,
          favoritesController, child) {
        if (!favoritesController.favoritesInitialized) {
          favoritesController.initFavorites(
            token: sessionController.token,
            language: sessionController.language,
          );
        }

        return Column(
          children: [
            SizedBox(
              height: 56,
              child: ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                scrollDirection: Axis.horizontal,
                children: [
                  CustomFilterChip(
                    label: "Favorite tracks",
                    selected: currentFilterIndex == 0,
                    onSelected: () {
                      _pageController.jumpToPage(0);
                    },
                  ),
                  CustomFilterChip(
                    label: "Favorite artists",
                    selected: currentFilterIndex == 1,
                    onSelected: () {
                      _pageController.jumpToPage(1);
                    },
                  ),
                  CustomFilterChip(
                    label: "Favorite albums",
                    selected: currentFilterIndex == 2,
                    onSelected: () {
                      _pageController.jumpToPage(2);
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (newPageIndex) {
                  setState(
                    () {
                      currentFilterIndex = newPageIndex;
                    },
                  );
                },
                children: const [
                  FavoriteTracksSections(),
                  FavoriteArtistsSection(),
                  FavoriteAlbumsSection(),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
