import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify_clone/data/controllers/search_media_controller.dart';
import 'package:spotify_clone/data/controllers/session_controller.dart';
import 'package:spotify_clone/ui/pages/home/components/home_page_drawer.dart';
import 'package:spotify_clone/ui/pages/home/screens/search/components/body/home_page_search_screen_body.dart';
import 'package:spotify_clone/ui/pages/home/screens/search/components/home_page_search_screen_app_bar.dart';

class HomePageSearchScreen extends StatefulWidget {
  const HomePageSearchScreen({
    super.key,
  });

  @override
  State<HomePageSearchScreen> createState() => _HomePageSearchScreenState();
}

class _HomePageSearchScreenState extends State<HomePageSearchScreen> {
  bool isSearching = false;

  @override
  Widget build(BuildContext context) {
    return Consumer2<SessionController, SearchMediaController>(
      builder: (context, sessionController, searchMediaController, child) {
        return PopScope(
          canPop: false,
          onPopInvoked: (didPop) {
            if (isSearching) {
              setState(
                () {
                  isSearching = false;
                },
              );
              searchMediaController.searchInputController.clear();
              FocusScope.of(context).unfocus();
            }
          },
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size(double.infinity, 120),
              child: HomePageSearchScreenAppBar(
                isSearching: isSearching,
                controller: searchMediaController.searchInputController,
                onSearchOpened: () {
                  setState(
                    () {
                      isSearching = true;
                    },
                  );
                },
                onSearchChanged: (search) {
                  if (searchMediaController.searchInputController.value.text
                      .trim()
                      .isNotEmpty) {
                    searchMediaController.search(
                      token: sessionController.token,
                      search: searchMediaController
                          .searchInputController.value.text
                          .trim(),
                      language: sessionController.language,
                    );
                  } else {
                    searchMediaController.clearSearch();
                  }
                },
              ),
            ),
            drawer: const HomePageDrawer(),
            drawerScrimColor:
                Theme.of(context).scaffoldBackgroundColor.withOpacity(0.75),
            body: HomePageSearchScreenBody(
              isRequestedSearchEmpty: searchMediaController
                  .searchInputController.value.text
                  .trim()
                  .isEmpty,
            ),
          ),
        );
      },
    );
  }
}
