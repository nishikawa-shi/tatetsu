import 'package:flutter/material.dart';

@immutable
class ExpandableFabChildButton extends StatelessWidget {
  const ExpandableFabChildButton({
    super.key,
    this.onPressed,
    required this.icon,
  });

  final VoidCallback? onPressed;
  final Widget icon;

  @override
  Widget build(BuildContext context) => Material(
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        color: Theme.of(context).colorScheme.secondary,
        elevation: 4.0,
        child: IconButton(
          onPressed: onPressed,
          icon: icon,
          color: Theme.of(context).colorScheme.onSecondary,
        ),
      );
}
