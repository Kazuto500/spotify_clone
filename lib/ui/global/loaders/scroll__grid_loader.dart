import 'package:flutter/widgets.dart';
import 'package:spotify_clone/utils/render_utils.dart';

class ScrollGridLoader extends StatefulWidget {
  final List<Widget> items;
  final int itemsPerRow;
  final int totalAvailableItems;
  final Function onMoreItemsRequested;

  const ScrollGridLoader({
    super.key,
    required this.items,
    required this.itemsPerRow,
    required this.totalAvailableItems,
    required this.onMoreItemsRequested,
  });

  @override
  State<ScrollGridLoader> createState() => _ScrollGridLoaderState();
}

class _ScrollGridLoaderState extends State<ScrollGridLoader> {
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
        padding: const EdgeInsets.only(top: 4, right: 8, bottom: 7, left: 8),
        children: RenderUtils().groupCountedWidgetsByRow(
          widgets: widget.items,
          widgetsPerRow: widget.itemsPerRow,
        ),
      ),
    );
  }
}
