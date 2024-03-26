import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BottomNavigationBarTab extends StatelessWidget {
  final String svgRoute;
  final String? inactiveSvgRoute;
  final String label;
  final bool active;
  final Color? activeColor;
  final Color? inactiveColor;
  const BottomNavigationBarTab({
    super.key,
    required this.svgRoute,
    this.inactiveSvgRoute,
    required this.label,
    required this.active,
    this.activeColor,
    this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: AspectRatio(
            aspectRatio: 1,
            child: SvgPicture.asset(
              active ? svgRoute : inactiveSvgRoute ?? svgRoute,
              fit: BoxFit.contain,
              alignment: Alignment.center,
              colorFilter: ColorFilter.mode(
                active
                    ? activeColor ?? Colors.white
                    : inactiveColor ?? const Color(0xffB3B3B3),
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelSmall!.copyWith(
                  fontSize: 9,
                  height: 1,
                  color: active
                      ? activeColor ?? Colors.white
                      : inactiveColor ?? const Color(0xffB3B3B3),
                ),
          ),
        ),
      ],
    );
  }
}
