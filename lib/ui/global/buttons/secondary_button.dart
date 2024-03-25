import 'package:flutter/material.dart';

class SecondaryButton extends StatelessWidget {
  final Function onPressed;
  final Widget? icon;
  final String label;
  final double? width;

  const SecondaryButton(
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
            Colors.transparent,
          ),
          overlayColor: MaterialStatePropertyAll(Colors.white12),
          foregroundColor: MaterialStatePropertyAll(Colors.white),
          padding: MaterialStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 24),
          ),
          side: MaterialStatePropertyAll(
            BorderSide(color: Colors.white60),
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
                      const ColorFilter.mode(Colors.white, BlendMode.srcIn),
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
