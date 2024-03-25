import 'package:flutter/material.dart';

class RenderUtils {
  List<Widget> groupCountedWidgetsByRow({
    required List<Widget> widgets,
    required int widgetsPerRow,
  }) {
    return List.generate(
      (widgets.length / widgetsPerRow).ceil(),
      (rIndex) => Row(
        children: List.generate(
          widgetsPerRow,
          (iIndex) => (rIndex * widgetsPerRow + iIndex < widgets.length)
              ? Expanded(
                  child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                  child: widgets[rIndex * widgetsPerRow + iIndex],
                ))
              : const Expanded(child: SizedBox()),
        ),
      ),
    );
  }
}
