import 'package:flutter/widgets.dart';

class ScrollLoader extends StatefulWidget {
  final List<Widget> items;
  final int totalAvailableItems;
  final Function onMoreItemsRequested;

  const ScrollLoader({
    super.key,
    required this.items,
    required this.totalAvailableItems,
    required this.onMoreItemsRequested,
  });

  @override
  State<ScrollLoader> createState() => _ScrollLoaderState();
}

class _ScrollLoaderState extends State<ScrollLoader> {
  final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      onNotification: (notification) {
        if (notification is ScrollNotification) {
          if (_scrollController.position.atEdge &&
              _scrollController.position.pixels != 0 &&
              widget.items.length < widget.totalAvailableItems) {
            _scrollController
                .animateTo(
                  _scrollController.offset - 1,
                  duration: const Duration(microseconds: 1),
                  curve: Curves.linear,
                )
                .then((value) => widget.onMoreItemsRequested());
          }
        }
        return false;
      },
      child: ListView(
        controller: _scrollController,
        padding: const EdgeInsets.only(top: 8, bottom: 64),
        children: List.generate(
          widget.items.length,
          (index) => widget.items[index],
        ),
      ),
    );
  }
}
