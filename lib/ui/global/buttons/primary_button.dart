import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final Function onPressed;
  final Widget? icon;
  final String label;
  final double? width;
  const PrimaryButton(
      {super.key,
      required this.onPressed,
      this.icon,
      required this.label,
      this.width});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: ElevatedButton(
        style: const ButtonStyle(
          elevation: MaterialStatePropertyAll(0),
          backgroundColor: MaterialStatePropertyAll(
            Color(0xff1ED760),
          ),
          overlayColor: MaterialStatePropertyAll(Colors.black26),
          foregroundColor: MaterialStatePropertyAll(Colors.black),
          padding: MaterialStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 24),
          ),
          minimumSize: MaterialStatePropertyAll(
            Size(double.infinity, 48),
          ),
        ),
        onPressed: () {
          onPressed();
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null)
              SizedBox(
                width: 24,
                height: 24,
                child: ColorFiltered(
                  colorFilter:
                      const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                  child: icon,
                ),
              ),
            Padding(
              padding: EdgeInsets.only(left: icon != null ? 16 : 0),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}
