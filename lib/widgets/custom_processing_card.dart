import 'package:flutter/material.dart';

class CustomProcessingCard extends StatelessWidget {
  final BuildContext context;
  final bool isDarkMode;
  final bool isProcessing;
  final Animation<double> pulseAnimation;
  final bool shouldCancel;
  final bool isCreatingZip;
  final String currentOperation;
  final double progress;
  final VoidCallback? splitAndZip;
  final Function(double progress) getRemainingTime;
  final VoidCallback? cancelProcess;
  const CustomProcessingCard(
      {required this.context,
      required this.currentOperation,
      required this.isCreatingZip,
      required this.isDarkMode,
      required this.isProcessing,
      required this.progress,
      required this.pulseAnimation,
      required this.shouldCancel,
      required this.splitAndZip,
      required this.getRemainingTime,
      required this.cancelProcess,
      super.key});

  LinearGradient _progressGradient() {
    if (isCreatingZip) {
      return const LinearGradient(colors: [Colors.amber, Colors.orange]);
    }
    if (shouldCancel) {
      return const LinearGradient(colors: [Colors.red, Colors.redAccent]);
    }
    return const LinearGradient(
      colors: [Colors.indigoAccent, Colors.purpleAccent],
    );
  }

  @override
  Widget build(BuildContext context) {
    final clampedProgress = progress.isNaN ? 0.0 : progress.clamp(0.0, 1.0);

    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: isProcessing
                ? null
                : LinearGradient(
                    colors: [Colors.indigoAccent, Colors.purpleAccent],
                  ),
          ),
          child: ScaleTransition(
            scale: isProcessing ? pulseAnimation : AlwaysStoppedAnimation(1.0),
            child: ElevatedButton.icon(
              onPressed: isProcessing ? null : splitAndZip,
              icon: isProcessing
                  ? SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                    )
                  : const Icon(Icons.content_cut, color: Colors.white),
              label: Text(
                shouldCancel
                    ? 'Cancelling...'
                    : isProcessing
                        ? isCreatingZip
                            ? 'Creating ZIP...'
                            : currentOperation
                        : 'Split & Export',
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 56),
                backgroundColor: isProcessing
                    ? (isDarkMode ? Colors.grey[700] : Colors.grey[200])
                    : Colors.transparent,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ),
        if (isProcessing) ...[
          const SizedBox(height: 16),
          _GradientLinearProgressBar(
            value: clampedProgress,
            height: 10,
            borderRadius: 8,
            // Unfilled track should be black; fill is gradient.
            backgroundColor: Colors.black,
            gradient: _progressGradient(),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${(clampedProgress * 100).toStringAsFixed(1)}%',
                style: TextStyle(
                  fontSize: 12,
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
              Text(
                shouldCancel
                    ? 'Cancelling...'
                    : isCreatingZip
                        ? 'Creating ZIP...'
                        : 'Splitting video...',
                style: TextStyle(
                  fontSize: 12,
                  color: shouldCancel ? Colors.red : Colors.indigoAccent,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (!shouldCancel)
                Text(
                  getRemainingTime(clampedProgress),
                  style: TextStyle(
                    fontSize: 12,
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: shouldCancel ? null : cancelProcess,
              icon: const Icon(Icons.close, size: 18),
              label: const Text('Cancel'),
            ),
          ),
        ],
      ],
    );
  }
}

class _GradientLinearProgressBar extends StatelessWidget {
  final double value;
  final double height;
  final double borderRadius;
  final Color backgroundColor;
  final Gradient gradient;

  const _GradientLinearProgressBar({
    required this.value,
    required this.height,
    required this.borderRadius,
    required this.backgroundColor,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    final clamped = value.isNaN ? 0.0 : value.clamp(0.0, 1.0);

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: SizedBox(
        height: height,
        child: Stack(
          children: [
            Positioned.fill(child: ColoredBox(color: backgroundColor)),
            // Animate the fill width without forcing a full-width constraint.
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.0, end: clamped),
              duration: const Duration(milliseconds: 160),
              curve: Curves.easeOut,
              builder: (context, animatedValue, child) {
                return Align(
                  alignment: Alignment.centerLeft,
                  child: FractionallySizedBox(
                    widthFactor: animatedValue,
                    heightFactor: 1.0,
                    child: child,
                  ),
                );
              },
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: gradient,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
