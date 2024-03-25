import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:spotify_clone/data/controllers/user_controller.dart';
import 'package:spotify_clone/ui/global/media/image_loader.dart';

class HomePageSearchScreenAppBar extends StatefulWidget {
  final bool isSearching;
  final TextEditingController controller;
  final Function onSearchOpened;
  final Function(String search) onSearchChanged;

  const HomePageSearchScreenAppBar({
    super.key,
    required this.isSearching,
    required this.controller,
    required this.onSearchOpened,
    required this.onSearchChanged,
  });

  @override
  State<HomePageSearchScreenAppBar> createState() =>
      _HomePageSearchScreenAppBarState();
}

class _HomePageSearchScreenAppBarState
    extends State<HomePageSearchScreenAppBar> {
  String searchValue = "";

  Timer? searchTimer;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: MediaQuery.paddingOf(context).top + 4,
        right: 12,
        bottom: 4,
        left: 12,
      ),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Scaffold.of(context).openDrawer();
                },
                child: Container(
                  width: 40,
                  height: 40,
                  margin: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xff727272),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Consumer<UserController>(
                    builder: (context, userController, child) => ImageLoader(
                        imageUrl: userController.currentUser!.avatarUrl),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    "Search",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            child: TextField(
              controller: widget.controller,
              keyboardType: TextInputType.url,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontSize: 16,
                    color: Colors.black,
                  ),
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(12),
                  child: SvgPicture.asset(
                    "lib/assets/svg/icons/search_inactive.svg",
                    colorFilter: const ColorFilter.mode(
                      Color(0xff191919),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                hintText: "What do you want to listen?",
                hintStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontSize: 16,
                      color: const Color(0xff535353),
                    ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              onTap: () {
                widget.onSearchOpened();
              },
              onChanged: (value) {
                setState(
                  () {
                    searchValue = value;
                  },
                );

                if (searchTimer != null && searchTimer!.isActive) {
                  searchTimer!.cancel();
                }

                searchTimer = Timer(
                  const Duration(milliseconds: 500),
                  () {
                    widget.onSearchChanged(
                      searchValue.trim(),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
