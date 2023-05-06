import 'package:flutter/material.dart';

class TabletContainer extends StatelessWidget {
  final String text;
  final Color? color;
  final Color? textColor;
  const TabletContainer({
    super.key,
    required this.text,
    this.color,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color?.withOpacity(.2) ?? Colors.transparent,
        border: Border.all(
          color: textColor ?? Theme.of(context).colorScheme.onPrimary,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(100),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 7,
        vertical: 3,
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelMedium!.copyWith(
              color: textColor ?? Theme.of(context).colorScheme.onPrimary,
            ),
      ),
    );
  }
}
