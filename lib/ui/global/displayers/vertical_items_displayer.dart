import 'package:flutter/material.dart';

class VerticalItemsDisplayer extends StatelessWidget {
  final String title;
  final List<Widget> items;
  final Widget? extendedModal;

  const VerticalItemsDisplayer({
    super.key,
    required this.title,
    required this.items,
    this.extendedModal,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 16, vertical: extendedModal != null ? 8 : 16),
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
            ),
            if (extendedModal != null)
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
                      color: const Color(0xff1ED760).withOpacity(0.75),
                    ),
                  ),
                ),
              )
          ],
        ),
        ...List.generate(
          items.length <= 5 ? items.length : 5,
          (index) => Padding(
            padding: const EdgeInsets.all(8),
            child: items[index],
          ),
        ),
      ],
    );
  }
}
