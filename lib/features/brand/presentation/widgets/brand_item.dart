import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';

class BrandItem extends StatelessWidget {
  final String name;
  final String? logo;
  final VoidCallback? onTap;
  final IconData? icon;

  const BrandItem({
    super.key,
    required this.name,
    this.logo,
    this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final textTheme = theme.textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          children: [
            Container(
              width: 51,
              height: 51,
              decoration: BoxDecoration(
                color: logo != null ? colors.surface : colors.primary,
                border: Border.all(color: colors.primary, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: colors.primary.withAlpha(50),
                    blurRadius: 2,
                    spreadRadius: 1,
                  ),
                ],
                shape: BoxShape.circle,
              ),
              child: logo != null
                  ? Padding(
                      padding: const EdgeInsets.all(3),
                      child: ClipOval(
                        child: Image.network(
                          logo!,
                          width: 51,
                          height: 51,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              icon ?? Icons.business,
                              color: colors.onSurfaceVariant,
                            );
                          },
                        ),
                      ),
                    )
                  : HeroIcon(
                      HeroIcons.squares2x2,
                      style: HeroIconStyle.outline,
                      color: colors.onPrimary,
                    ),
            ),

            const SizedBox(height: 5),

            Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: textTheme.bodySmall?.copyWith(color: colors.onSurface),
            ),
          ],
        ),
      ),
    );
  }
}
