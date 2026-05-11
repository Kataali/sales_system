import 'package:fluent_ui/fluent_ui.dart';
import 'package:sales_system/shared/presentation/theme/app_colors.dart';

class MiniStatCard extends StatelessWidget {
  final IconData icon;
  final String label, value;
  final Color accent;

  const MiniStatCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ExtraColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ExtraColors.linkLight),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: accent, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value,
                    style: const TextStyle(
                      color: ExtraColors.black,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                    ),
                    overflow: TextOverflow.ellipsis),
                Text(label,
                    style: const TextStyle(
                        color: ExtraColors.darkGrey, fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
