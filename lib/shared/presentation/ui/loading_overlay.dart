import 'package:fluent_ui/fluent_ui.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:sales_system/shared/presentation/theme/app_colors.dart';

class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = FluentTheme.of(context).brightness == Brightness.dark;

    return Container(
      color: isDark 
          ? ExtraColors.black.withValues(alpha: 0.7) 
          : ExtraColors.black.withValues(alpha: 0.3),
      child: Center(
        child: SizedBox(
          child: LoadingIndicator(
            indicatorType: Indicator.ballClipRotatePulse,
            colors: [
              isDark ? ExtraColors.white : FluentTheme.of(context).accentColor,
            ],
          ),
        ),
      ),
    );
  }
}

// ballClipRotatePulse
// ballGridBeat
// ballScale
// orbit
// pacman