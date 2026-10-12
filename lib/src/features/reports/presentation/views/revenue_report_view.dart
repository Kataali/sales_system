import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:sales_system/shared/presentation/theme/app_colors.dart';
import 'package:sales_system/shared/presentation/ui/loading_overlay.dart';
import 'package:sales_system/src/features/authentication/presentation/providers/auth_provider.dart';
import 'package:sales_system/src/features/reports/domain/entities/report_entity.dart';
import 'package:sales_system/src/features/reports/presentation/providers/revenue_report_provider.dart';
import 'package:sales_system/src/features/reports/presentation/widgets/error_state.dart';
import 'package:sales_system/src/features/reports/presentation/widgets/report_body.dart';

class RevenueReportView extends ConsumerStatefulWidget {
  const RevenueReportView({super.key});

  @override
  ConsumerState<RevenueReportView> createState() => _RevenueReportViewState();
}

class _RevenueReportViewState extends ConsumerState<RevenueReportView> {
  ReportPeriod _selectedPeriod = ReportPeriod.today;
  DateTime _customDate = DateTime.now();

  List<ReportPeriod> _getAllowedPeriods(String role) {
    if (role == 'admin') {
      return [
        ReportPeriod.today,
        ReportPeriod.yesterday,
        ReportPeriod.weekly,
        ReportPeriod.monthly,
        ReportPeriod.custom,
      ];
    }
    return [ReportPeriod.today];
  }

  RevenueReportParams get _currentParams {
    return RevenueReportParams(
      period: _selectedPeriod,
      customDate: _selectedPeriod == ReportPeriod.custom ? _customDate : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final userRole = authState.value?.role ?? 'employee';
    final periods = _getAllowedPeriods(userRole);
    final state = ref.watch(reportsControllerProvider(_currentParams));

    return ScaffoldPage(
      header: PageHeader(
        title: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Revenue'),
                  Text(
                    'Sales performance report',
                    style: FluentTheme.of(context).typography.caption?.copyWith(
                          color: ExtraColors.darkGrey,
                        ),
                  ),
                ],
              ),
            ),
            Tooltip(
              message: 'Refresh report',
              child: IconButton(
                icon: const Icon(FluentIcons.refresh),
                onPressed: () {
                  ref
                      .read(reportsControllerProvider(_currentParams).notifier)
                      .fetchReport(_currentParams);
                },
              ),
            ),
          ],
        ),
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Period Selection ────────────────────────────────────────────────
          if (periods.length > 1)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: periods.length,
                  itemBuilder: (context, index) {
                    final period = periods[index];
                    final isSelected = _selectedPeriod == period;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: PillButton(
                        label: period.label,
                        isSelected: isSelected,
                        onPressed: () {
                          setState(() => _selectedPeriod = period);
                          if (period == ReportPeriod.custom) {
                            _showCustomDatePicker();
                          }
                        },
                      ),
                    );
                  },
                ),
              ),
            ),

          // ── Custom Date Display ─────────────────────────────────────────────
          if (_selectedPeriod == ReportPeriod.custom)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: CommandBar(
                primaryItems: [
                  CommandBarButton(
                    icon: const Icon(FluentIcons.calendar),
                    label: Text(DateFormat('MMM d, yyyy').format(_customDate)),
                    onPressed: _showCustomDatePicker,
                  ),
                ],
              ),
            ),

          const SizedBox(height: 12),

          // ── Main Content ────────────────────────────────────────────────────
          Expanded(
            child: state.when(
              data: (report) => ReportBody(report: report),
              loading: () => const Center(child: LoadingOverlay()),
              error: (e, _) => ErrorState(
                error: e.toString(),
                onRetry: () =>
                    ref.invalidate(reportsControllerProvider(_currentParams)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCustomDatePicker() async {
    await showDialog(
      context: context,
      builder: (context) => ContentDialog(
        title: const Text('Pick a custom date'),
        content: DatePicker(
          selected: _customDate,
          onChanged: (v) => setState(() => _customDate = v),
        ),
        actions: [
          Button(
            child: const Text('Close'),
            onPressed: () {
              Navigator.pop(context);
              ref.invalidate(reportsControllerProvider(_currentParams));
            },
          ),
        ],
      ),
    );
  }
}

class PillButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onPressed;

  const PillButton({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Button(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(
          isSelected ? FluentTheme.of(context).accentColor : null,
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : null,
          fontWeight: isSelected ? FontWeight.bold : null,
        ),
      ),
    );
  }
}
