import 'package:flutter/material.dart';

class HorizontalItemsDisplayer extends StatelessWidget {
  final String title;
  final double scrollHeight;
  final List<Widget> items;
  final Widget extendedModal;

  const HorizontalItemsDisplayer({
    super.key,
    required this.title,
    required this.scrollHeight,
    required this.items,
    required this.extendedModal,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: TextButton(
                onPressed: () {
                  Scaffold.of(context).showBottomSheet(
                    (context) => Container(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      constraints: BoxConstraints(
                        maxWidth: double.infinity,
                        maxHeight: MediaQuery.of(context).size.height -
                            MediaQuery.of(context).padding.top -
                            120,
                      ),
                      child: extendedModal,
                    ),
                  );
                },
                style: const ButtonStyle(
                  minimumSize: MaterialStatePropertyAll(
                    Size(31, 31),
                  ),
                  maximumSize: MaterialStatePropertyAll(
                    Size(double.infinity, 31),
                  ),
                ),
                child: Text(
                  "See all",
                  style: TextStyle(
                    color: Colors.green.withOpacity(0.8),
                  ),
                ),
              ),
            )
          ],
        ),
        SizedBox(
          height: scrollHeight,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            children: List.generate(
              items.length <= 5 ? items.length : 5,
              (index) => Container(
                width: 130,
                margin: const EdgeInsets.all(8),
                child: items[index],
              ),
            ),
          ),
        )
      ],
    );
  }
}
