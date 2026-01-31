import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';

/// Custom loading indicator with animation
class LoadingIndicator extends StatelessWidget {
  final double progress;
  final bool isVisible;

  const LoadingIndicator({
    super.key,
    this.progress = 0.0,
    this.isVisible = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!isVisible) return const SizedBox.shrink();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: 3,
      child: LinearProgressIndicator(
        value: progress > 0 ? progress : null,
        backgroundColor: AppColors.borderDark,
        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
      ),
    ).animate().fadeIn(duration: 200.ms);
  }
}

/// Full screen loading overlay
class LoadingOverlay extends StatelessWidget {
  final String? message;

  const LoadingOverlay({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.backgroundDark.withValues(alpha: 0.8),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 48,
              height: 48,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),
            if (message != null) ...[
              const SizedBox(height: 16),
              Text(
                message!,
                style: TextStyle(
                  color: AppColors.textSecondaryDark,
                  fontSize: 14,
                ),
              ),
            ],
          ],
        ),
      ),
    ).animate().fadeIn(duration: 200.ms);
  }
}

/// Shimmer loading placeholder
class ShimmerPlaceholder extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const ShimmerPlaceholder({
    super.key,
    this.width = double.infinity,
    this.height = 20,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.shimmerBase,
        borderRadius: borderRadius ?? BorderRadius.circular(8),
      ),
    ).animate(
      onPlay: (controller) => controller.repeat(),
    ).shimmer(
      duration: 1500.ms,
      color: AppColors.shimmerHighlight.withValues(alpha: 0.5),
    );
  }
}

/// Pulsing dot indicator
class PulsingDot extends StatelessWidget {
  final Color color;
  final double size;

  const PulsingDot({
    super.key,
    this.color = AppColors.primary,
    this.size = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    ).animate(
      onPlay: (controller) => controller.repeat(),
    ).scale(
      begin: const Offset(1, 1),
      end: const Offset(1.2, 1.2),
      duration: 600.ms,
    ).then().scale(
      begin: const Offset(1.2, 1.2),
      end: const Offset(1, 1),
      duration: 600.ms,
    );
  }
}
