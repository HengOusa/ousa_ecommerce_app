import 'package:flutter/material.dart';

class LoopingCircle extends StatefulWidget {
  const LoopingCircle({
    super.key,
    required this.begin,
    required this.end,
    required this.duration,
    required this.builder,
  });

  final double begin;
  final double end;
  final Duration duration;
  final Widget Function(BuildContext context, double value) builder;

  @override
  State<LoopingCircle> createState() => _LoopingCircleState();
}

class _LoopingCircleState extends State<LoopingCircle>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: widget.begin,
      end: widget.end,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return widget.builder(
          context,
          _animation.value,
        );
      },
    );
  }
}