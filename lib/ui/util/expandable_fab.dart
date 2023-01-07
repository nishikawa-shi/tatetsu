import 'dart:math';

import 'package:flutter/material.dart';

@immutable
class ExpandableFab extends StatefulWidget {
  const ExpandableFab({
    super.key,
    this.initialOpen,
    required this.distance,
    required this.children,
  });

  final bool? initialOpen;
  final double distance;
  final List<Widget> children;

  @override
  State<ExpandableFab> createState() => _ExpandableFabState();
}

class _ExpandableFabState extends State<ExpandableFab>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _expandAnimation;
  bool _open = false;

  @override
  void initState() {
    super.initState();
    _open = widget.initialOpen ?? false;
    _controller = AnimationController(
      value: _open ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      curve: Curves.fastOutSlowIn,
      reverseCurve: Curves.easeOutQuad,
      parent: _controller,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _open = !_open;
      if (_open) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        alignment: Alignment.bottomRight,
        clipBehavior: Clip.none,
        children: [
          _buildTapToCloseFab(),
          ..._buildExpandingActionButtons(),
          _buildTapToOpenFab(),
        ],
      ),
    );
  }

  List<Widget> _buildExpandingActionButtons() =>
      List.generate(widget.children.length, (n) => n)
          .map(
            (i) => _ExpandingActionButton(
              position: i,
              maxDistance: widget.distance,
              progress: _expandAnimation,
              child: widget.children[i],
            ),
          )
          .toList();

  Widget _buildTapToCloseFab() => SizedBox(
        width: 56.0,
        height: 56.0,
        child: Center(
          child: Material(
            shape: const CircleBorder(),
            clipBehavior: Clip.antiAlias,
            elevation: 4.0,
            child: InkWell(
              onTap: _toggle,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.close,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
        ),
      );

  Widget _buildTapToOpenFab() => IgnorePointer(
        ignoring: _open,
        child: AnimatedContainer(
          transformAlignment: Alignment.center,
          transform: Matrix4.diagonal3Values(
            _open ? 0.7 : 1.0,
            _open ? 0.7 : 1.0,
            1.0,
          ),
          duration: const Duration(milliseconds: 250),
          curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
          child: AnimatedOpacity(
            opacity: _open ? 0.0 : 1.0,
            curve: const Interval(0.25, 1.0, curve: Curves.easeInOut),
            duration: const Duration(milliseconds: 250),
            child: FloatingActionButton(
              // この指定がないと、自前のThemeDataを使っているためか、丸型ではなく角丸になってしまう
              shape: const CircleBorder(),
              onPressed: _toggle,
              child: const Icon(Icons.add, size: 32),
            ),
          ),
        ),
      );
}

@immutable
class _ExpandingActionButton extends StatelessWidget {
  const _ExpandingActionButton({
    required this.position,
    required this.maxDistance,
    required this.progress,
    required this.child,
  });

  final int position;
  final double maxDistance;
  final Animation<double> progress;
  final Widget child;

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: progress,
        builder: (context, child) {
          final offset = Offset.fromDirection(
            pi / 2,
            progress.value * (maxDistance / (position + 1)),
          );
          return Positioned(
            right: 4.0 + offset.dx,
            bottom: 4.0 + offset.dy,
            child: Transform.rotate(
              angle: (1.0 - progress.value) * pi / 2,
              child: child,
            ),
          );
        },
        child: FadeTransition(
          opacity: progress,
          child: child,
        ),
      );
}
