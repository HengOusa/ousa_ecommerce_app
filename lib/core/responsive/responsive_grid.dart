import 'package:flutter/material.dart';

class ResponsiveGrid extends StatelessWidget {
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;

  final double minItemWidth;
  final double maxItemWidth;
  final double spacing;
  final double runSpacing;
  final double childAspectRatio;
  final EdgeInsetsGeometry padding;
  final ScrollPhysics? physics;
  final bool shrinkWrap;

  const ResponsiveGrid({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.minItemWidth = 160,
    this.maxItemWidth = 280,
    this.spacing = 12,
    this.runSpacing = 12,
    this.childAspectRatio = 0.68,
    this.padding = const EdgeInsets.all(16),
    this.physics,
    this.shrinkWrap = false,
  }) : assert(minItemWidth > 0),
       assert(maxItemWidth >= minItemWidth),
       assert(spacing >= 0),
       assert(runSpacing >= 0),
       assert(childAspectRatio > 0);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;

        final columns = ((availableWidth + spacing) / (maxItemWidth + spacing))
            .ceil()
            .clamp(
              1,
              ((availableWidth + spacing) / (minItemWidth + spacing))
                  .floor()
                  .clamp(1, 100),
            );

        return GridView.builder(
          padding: padding,
          shrinkWrap: shrinkWrap,
          physics: physics,
          itemCount: itemCount,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: spacing,
            mainAxisSpacing: runSpacing,
            childAspectRatio: childAspectRatio,
          ),
          itemBuilder: itemBuilder,
        );
      },
    );
  }
}
