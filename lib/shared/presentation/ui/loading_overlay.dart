import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: SizedBox(child: LoadingIndicator(indicatorType: Indicator.ballClipRotatePulse),),);
  }
}

// ballClipRotatePulse
// ballGridBeat
// ballScale
// orbit
// pacman